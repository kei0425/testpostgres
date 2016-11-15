"use strict";
var express = require('express');
var postgresdocker = require('../lib/postgresdocker');
var router = express.Router();
var apilist = {
    GET: {
        'list': function (req, res, next) {
            var params = req.query;
            if (!('all' in params)) {
                params.all = 1;
            }
            postgresdocker.list_postgres(params).then(function (data) {
                res.json(data);
                res.statusCode = 200;
            }, function (err) {
                res.status(500).json({ status: 'NG', err: err });
            });
        },
        'dblist': function (req, res, next) {
            var params = req.query;
            postgresdocker.list_images(params).then(function (data) {
                res.json(data);
                res.statusCode = 200;
            }, function (err) {
                res.status(500).json({ status: 'NG', err: err });
            });
        }
    },
    POST: {
        stop: function (req, res, next) {
            var params = req.body;
            postgresdocker.stop_container(params.id).then(function (data) {
                res.json({ status: 'OK', data: data });
            }, function (err) {
                res.status(500).json({ status: 'NG', err: err });
            });
        },
        remove: function (req, res, next) {
            var params = req.body;
            postgresdocker.remove_container(params.id).then(function (data) {
                res.json({ status: 'OK', data: data });
            }, function (err) {
                res.status(500).json({ status: 'NG', err: err });
            });
        },
        start: function (req, res, next) {
            var params = req.body;
            postgresdocker.start_container(params.id).then(function (data) {
                res.json({ status: 'OK', data: data });
            }, function (err) {
                res.status(500).json({ status: 'NG', err: err });
            });
        },
        create: function (req, res, next) {
            var params = req.body;
            postgresdocker.create_container(params).then(function (data) {
                res.json({ status: 'OK', data: data });
            }, function (err) {
                res.status(500).json({ status: 'NG', err: err });
            });
        }
    }
};
router.get('/', function (req, res, next) {
    res.render('index');
});
router.all('/api/:command', function (req, res, next) {
    var command = req.params.command;
    //        delete req.params.command;
    if (apilist[req.method] && apilist[req.method][command]) {
        apilist[req.method][command](req, res, next);
    }
    else {
        next();
    }
});
module.exports = router;
