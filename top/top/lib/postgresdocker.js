const Docker = require('dockerode');
const net = require('net');

exports.hostip = '192.168.255.120';
exports.docker_port = 2375;
exports.containerName = 'test_postgres_';
exports.imageName = 'testpostgres_';

const docker = new Docker({protocol:'http', host: exports.hostip, port: exports.docker_port});

exports.db_port = 10000;

var used_port = {};

exports.searchport = function (host, port, retry_count, callback) {
    if (retry_count == null) {
        retry_count = 100;
    }
    var socket = new net.Socket();

    return new Promise(
        function (resolve, reject) {
            socket.on(
                'error',
                function (e) {
                    resolve(port);
                    if (callback) {
                        callback(null, port);
                    }
                }
            );
            socket.connect(
                port,
                host,
                function () {
                    socket.destroy();
                    reject('no free port');
                }
            );
        }
    ).catch(
        function (err) {
            if (retry_count > 1) {
                return exports.searchport(host, port + 1, retry_count - 1, callback);
            }
            else {
                throw err;
            }
        }
    );
};

exports.list_postgres = function (params) {
    return new Promise(
        function(resolve, reject) {
            docker.listContainers(
                params,
                function (err, containers) {
                    if (err) {
                        reject(err);
                    }
                    else {
                        used_port = {};
                        resolve(
                            containers.map(
                                function (x) {
                                    var data  = {
                                        id: x.Id,
                                        image: x.Image,
                                        status: x.Status,
                                        name: x.Names[0].substr(1)
                                    };
                                    var ports = x.Ports.filter(
                                        function (port) {
                                            return port.PublicPort;
                                        }
                                    ).map(
                                        function (port) {
                                            used_port[port.PublicPort] = 1;
                                            return port.PrivatePort + '->' + port.PublicPort;
                                        }
                                    );
                                    if (ports.length > 0) {
                                        data.ports = ports;
                                    }

                                    return data;
                                }
                            ).filter(
                                function (x) {
                                    return x.name.startsWith(exports.containerName);
                                }
                            )
                        );
                    }
                }
            );
        }
    );
};

exports.list_images = function (params) {
    return new Promise(
        function (resolve, reject) {
            docker.listImages(
                params,
                function (err, data) {
                    if (err) {
                        reject(err);
                    }
                    else{
                        resolve(
                            Array.prototype.concat.apply(
                                [],
                                data.map(
                                    function (x) {
                                        return x.RepoTags;
                                    }
                                )).filter(
                                    function (x) {
                                        return x.startsWith(exports.imageName);
                                    }
                                )
                        );
                    }
                });
        }
    );
};

exports.stop_container = function (id) {
    return new Promise(
        function (resolve, reject) {
            var container = docker.getContainer(id);
            container.stop(
                function (err, data) {
                    if (err) {
                        reject(err);
                    }
                    else {
                        resolve(data);
                    }
                }
            );
        }
    );
};

exports.remove_container = function (id) {
    return new Promise(
        function (resolve, reject) {
            var container = docker.getContainer(id);
            container.remove(
                function (err, data) {
                    if (err) {
                        reject(err);
                    }
                    else {
                        resolve(data);
                    }
                }
            );
        }
    );
};

exports.start_container = function (id) {
    return new Promise(
        function (resolve, reject) {
            var container = docker.getContainer(id);
            container.start(
                function (err, data) {
                    if (err) {
                        reject(err);
                    }
                    else {
                        resolve(data);
                    }
                }
            );
        }
    );
};

exports.search_postgres_port = function (hostip, port, containers) {
    return Promise.all(
        [
            exports.searchport(hostip, port),
            containers || exports.list_postgres({all:1})
        ]
    ).then(
        function (results) {
            var port = results[0];
            var containers = results[1];
            var newContainerName = exports.containerName + port;
            if (containers.find(
                    function (container) {
                        return container.name == newContainerName;
                    })) {
                return exports.search_postgres_port(hostip, port + 1, containers);
            }
            else {
                console.log('port:' + port);
                return port;
            }
        }
    );
}

exports.create_container = function (params) {
    return exports.search_postgres_port(
        exports.hostip, exports.db_port
    ).then(
        function (port) {
            params.name = exports.containerName + port;
            params.HostConfig = {
              PortBindings: {
                  '15432/tcp': [{HostPort: port + ''}]
              }
            };
            console.log(params.HostConfig.PortBindings);

            return new Promise(
                function (resolve, reject) {
                    docker.createContainer(
                        params,
                        function (err, container) {
                            if (err) {
                                err.params = params;
                                reject(err);
                            }
                            else {
                                resolve(container.id);
                            }
                        }
                    );
                }
            );
        }
    ).then(
        exports.start_container
    );
};
