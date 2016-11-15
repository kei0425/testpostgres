"use strict";
const Docker = require('node-docker-api').Docker;
const net = require('net');

exports.hostip = '192.168.255.120';
exports.docker_port = 2375;
exports.containerName = 'test_postgres_';
exports.imageName = 'testpostgres_';
var docker = exports.docker = new Docker({ protocol: 'http', host: exports.hostip, port: exports.docker_port });
var promisifyStream = function (stream) { return new Promise(function (resolve, reject) {
    var data = '';
    stream.on('data', function (d) { return data += d; });
    stream.on('end', function (x) { return resolve(data); });
    stream.on('error', reject);
}); };
exports.copy = function (id, opts) {
    return get_container(id).then(function (container) { return new Promise(function (resolve, reject) {
        var call = {
            path: '/containers/' + container.id + '/copy',
            method: 'POST',
            isStream: true,
            options: opts,
            statusCodes: {
                200: true,
                400: 'bad request',
                404: 'no such container',
                500: 'server error'
            }
        };
        container.modem.dial(call, function (err, stream) {
            if (err)
                return reject(err);
            resolve(stream);
        });
    }); }).then(promisifyStream);
};
exports.get_comment = function (id) {
    return exports.copy(id, { Resource: '/tmp/comment' });
};
exports.db_port = 10000;
var used_port = {};
exports.searchport = function (host, port, retry_count, callback) {
    if (retry_count == null) {
        retry_count = 100;
    }
    var socket = new net.Socket();
    return new Promise(function (resolve, reject) {
        socket.on('error', function (e) {
            resolve(port);
            if (callback) {
                callback(null, port);
            }
        });
        socket.connect(port, host, function () {
            socket.destroy();
            reject('no free port');
        });
    }).catch(function (err) {
        if (retry_count > 1) {
            return exports.searchport(host, 1 + port * 1, retry_count - 1, callback);
        }
        else {
            throw err;
        }
    });
};
exports.list_postgres = function (params) {
    return docker.container.list(params)
        .then(function (containers) { return containers.map(function (x) {
        var data = {
            id: x.Id,
            image: x.Image,
            status: x.Status,
            name: x.Names[0].substr(1),
            ports: null
        };
        var ports = x.Ports.filter(function (port) {
            return port.PublicPort;
        }).map(function (port) {
            used_port[port.PublicPort] = 1;
            return port.PrivatePort + '->' + port.PublicPort;
        });
        if (ports.length > 0) {
            data.ports = ports;
        }
        return data;
    }).filter(function (x) { return x.name.startsWith(exports.containerName); }); });
};
exports.list_images = function (params) {
    return docker.image.list().then(function (data) { return Array.prototype.concat.apply([], data.map(function (x) { return x.RepoTags; }))
        .filter(function (x) { return x.startsWith(exports.imageName); }); });
};
var get_container = exports.get_container = function (id) {
    return docker.container.list({ all: 1 })
        .then(function (containers) {
        var container = containers.find(function (x) { return x.id == id; });
        if (!container) {
            throw 'no such container id:' + id;
        }
        return container;
    });
};
exports.stop_container = function (id) {
    return get_container(id).then(function (container) { return container.stop(); }).then(function (container) { id: container.id; });
};
exports.remove_container = function (id, params) {
    return get_container(id).then(function (container) { return container.delete(params); }).then(function (x) {
        return null;
    });
};
exports.start_container = function (id) {
    return get_container(id).then(function (container) { return container.start(); }).then(function (container) { id: container.id; });
};
exports.search_postgres_port = function (hostip, port, containers) {
    return Promise.all([
        exports.searchport(hostip, port),
        containers || exports.list_postgres({ all: 1 })
    ]).then(function (results) {
        var port = results[0], containers = results[1];
        var newContainerName = exports.containerName + port;
        if (containers.find(function (container) {
            return container.name == newContainerName;
        })) {
            return exports.search_postgres_port(hostip, port + 1, containers);
        }
        else {
            return port;
        }
    });
};
exports.create_container = function (params) {
    var port = params.port || exports.db_port;
    delete params.port;
    return exports.search_postgres_port(exports.hostip, port)
        .then(function (port) {
        params.name = exports.containerName + port;
        params.HostConfig = {
            PortBindings: {
                '15432/tcp': [{ HostPort: port + '' }]
            }
        };
        return docker.container.create(params);
    }).then(function (container) { return container.id; }).then(exports.start_container);
};
