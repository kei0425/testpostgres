'use strict';
var containers = [];
var images = [];
var portSet = new Set();
var dbport = 0;
var waitingDialog = waitingDialog || (function ($) {
    // Creating modal dialog's DOM
    var $dialog = $('<div class="modal fade" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-hidden="true" style="padding-top:15%; overflow-y:visible;">' +
        '<div class="modal-dialog modal-m">' +
        '<div class="modal-content">' +
        '<div class="modal-header"><h3 style="margin:0;"></h3></div>' +
        '<div class="modal-body">' +
        '<div class="progress progress-striped active" style="margin-bottom:0;"><div class="progress-bar" style="width: 100%"></div></div>' +
        '</div>' +
        '</div></div></div>');
    return {
        /**
         * Opens our dialog
         * @param message Custom message
         * @param options Custom options:
         * 				  options.dialogSize - bootstrap postfix for dialog size, e.g. "sm", "m";
         * 				  options.progressType - bootstrap postfix for progress bar type, e.g. "success", "warning".
         */
        show: function (message, options) {
            // Assigning defaults
            if (typeof options === 'undefined') {
                options = {};
            }
            if (typeof message === 'undefined') {
                message = '実行中';
            }
            var settings = $.extend({
                dialogSize: 'm',
                progressType: '',
                onHide: null // This callback runs after the dialog was hidden
            }, options);
            // Configuring dialog
            $dialog.find('.modal-dialog').attr('class', 'modal-dialog').addClass('modal-' + settings.dialogSize);
            $dialog.find('.progress-bar').attr('class', 'progress-bar');
            if (settings.progressType) {
                $dialog.find('.progress-bar').addClass('progress-bar-' + settings.progressType);
            }
            $dialog.find('h3').text(message);
            // Adding callbacks
            if (typeof settings.onHide === 'function') {
                $dialog.off('hidden.bs.modal').on('hidden.bs.modal', function (e) {
                    settings.onHide.call($dialog);
                });
            }
            // Opening dialog
            $dialog.modal();
        },
        /**
         * Closes dialog
         */
        hide: function () {
            $dialog.modal('hide');
        }
    };
})(jQuery);

function waitingAjax(params, message) {
    if (message === void 0) { message = undefined; }
    waitingDialog.show(message);
    return $.ajax(params).then(function (data) {
        waitingDialog.hide();
        return data;
    }, function (err) {
        waitingDialog.show('通信エラー', err);
        waitingDialog.hide();
        //            modal('error!');
        return $.Deferred().reject(err);
    });
}
function init() {
    containerlist_refresh();
    imagelist_refresh();
    $('#dbport').change(function (e) {
        let port = Number($(this).val());
        while (portSet.has(port)) {
            port += Math.sign(port - dbport);
        }
        $(this).val(port);
        dbport = port;
    });

    $('#create').click(function () {
        const index = $('#image_id option:selected').val();
        const Image = images[index];
        const port = $('#dbport').val();
        const comment = $('#comment').val();
        waitingAjax({
            type: 'POST',
            url: 'api/create',
            data: {Image, port, comment}
        }).then(
            containerlist_refresh
        );});
}
function imagelist_refresh() {
    return $.get('api/dblist').then(function (result) {
        images = result;
        $('#image_id').empty();
        result.forEach(function (data, index) {
            $('#image_id').append($('<option value="' + index + '">' + data + '</option>'));
        });
    });
}
var buttontable = {
    start: '開始',
    stop: '停止',
    delete: '削除'
};
function createbutton(kind, index) {
    return '<button class="' + kind + '-btn btn btn-primary " data-index="' + index + '">' + buttontable[kind] + '</button>';
}
function containerlist_refresh() {
    return $.get('api/list').then(function (result) {
        portSet.clear();
        containers = result;
        $('#table').empty();
        result.forEach(function (data, index) {
            if (data.ports) {
                let publicPorts = data.ports.map(x => Number(x.split('->')[1]));
                for (let port of publicPorts) {
                    portSet.add(port);
                }
            }
            else {
                portSet.add(Number(data.name.split('_')[2]));
            }
            let buttonhtml;
            if (data.status.startsWith('Up')) {
                buttonhtml = createbutton('stop', index);
            }
            else {
                buttonhtml = createbutton('start', index) + createbutton('delete', index);
            }
            $('#table').append($('<tr><td>' + data.name + '</td><td>' + data.image + '</td><td>' + data.status + '</td><td>' + buttonhtml + '</td></tr>'));
        });
        dbport = 10000;
        while (portSet.has(dbport)) {
            dbport++;
        }
        $('#dbport').val(dbport);
        $('#dbport').attr('min', dbport);
        $('.start-btn').click(function () {
            var index = $(this).data('index');
            var id = containers[index].id;
            waitingAjax({
                type: 'POST',
                url: 'api/start',
                data: { id: id }
            }).then(containerlist_refresh);
        });
        $('.stop-btn').click(function () {
            var index = $(this).data('index');
            var id = containers[index].id;
            waitingAjax({
                type: 'POST',
                url: 'api/stop',
                data: { id: id }
            }).then(containerlist_refresh);
        });
        $('.delete-btn').click(function () {
            var index = $(this).data('index');
            var id = containers[index].id;
            waitingAjax({
                type: 'POST',
                url: 'api/remove',
                data: { id: id }
            }).then(containerlist_refresh);
        });
    });
}
