const net = require('net');
function searchport(host, port, retry_count, callback) {
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
                return searchport(host, port + 1, retry_count - 1, callback);
            }
            else {
                return new Promise(
                    function (resolve, reject) {
                        reject(err);
                    }
                );
            }
        }
    );
}

searchport(
    '192.168.255.120', 10000
).then(
    function (port) {
        console.log('promise:' + port);
    },
    function (err) {
        console.log('reject:' + err);
    }
);