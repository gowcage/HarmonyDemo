/*
 Copyright (c) 2012-2015, Pierre-Olivier Latour
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * The name of Pierre-Olivier Latour may not be used to endorse
 or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL PIERRE-OLIVIER LATOUR BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

var ENTER_KEYCODE = 13;

var _path = null;
var _pendingReloads = [];
var _reloadingDisabled = 0;

function formatFileSize(bytes) {
  if (bytes >= 0x40000000) {
    return (bytes / 0x40000000).toFixed(2) + ' GB';
  }
  if (bytes >= 0x100000) {
    return (bytes / 0x100000).toFixed(2) + ' MB';
  }
  return (bytes / 0x400).toFixed(2) + ' KB';
}

function _isRoot(path) {
  if(path=="/storage/"){
       return true;
  }
  return false;
}

function _showError(message, textStatus, errorThrown) {
  $("#alerts").prepend(tmpl("template-alert", {
    level: "danger",
    title: (errorThrown != "" ? errorThrown : textStatus) + ": ",
    description: message
  }));
}

function _disableReloads() {
  _reloadingDisabled += 1;
}

function _enableReloads() {
  _reloadingDisabled -= 1;
  
  if (_pendingReloads.length > 0) {
    _reload(_pendingReloads.shift());
  }
}

function _reload(path) {
  if (_reloadingDisabled) {
    if ($.inArray(path, _pendingReloads) < 0) {
      _pendingReloads.push(path);
    }
    return;
  }
  
  _disableReloads();
  $.ajaxSetup({ cache: false });
  $.ajax({
    url: 'list',
    type: 'GET',
    data: {path: path},
    dataType: 'json'
  }).fail(function(jqXHR, textStatus, errorThrown) {
    _showError("刷新列表失败 \"" + path + "\"", textStatus, errorThrown);
  }).done(function(data, textStatus, jqXHR) {
    var scrollPosition = $(document).scrollTop();
    
    if (path != _path) {
      $("#path").empty();
      if (path == "/") {
        $("#path").append('<eu>' + _deviceid+'</eu>');
//        $("#path").append('<li class="active">' + _directory + '</li>');
      } else {
        $("#path").append('<eu>' + _deviceid+'</eu>');
//        $("#path").append('<li data-path="/"><a>' + _directory + '</a></li>');
        var components = path.split("/").slice(1, -1);
        for (var i = 0; i < components.length - 1; ++i) {
          var subpath = "/" + components.slice(0, i + 1).join("/") + "/";
          $("#path").append('<li data-path="' + subpath + '"><a>' + components[i] + '</a></li>');
        }
        $("#path > li").click(function(event) {
          _reload($(this).data("path"));
          event.preventDefault();
        });
        $("#path").append('<li class="active">' + components[components.length - 1] + '</li>');
      }
      _path = path;
    }
    
    $("#listing").empty();
    for (var i = 0, file; file = data[i]; ++i) {
      $(tmpl("template-listing", file)).data(file).appendTo("#listing");
    }
    
    $(".edit").editable(function(value, settings) { 
      var name = $(this).parent().parent().data("name");
      if (value != name) {
        var path = $(this).parent().parent().data("path");
        $.ajax({
          url: 'move',
          type: 'POST',
          data: {oldPath: path, newPath: _path + value},
          dataType: 'json'
        }).fail(function(jqXHR, textStatus, errorThrown) {
          _showError("无法移动 \"" + path + "\" 到 \"" + _path + value + "\"", textStatus, errorThrown);
        }).always(function() {
          _reload(_path);
        });
      }
      return value;
    }, {
      onedit: function(settings, original) {
        _disableReloads();
      },
      onsubmit: function(settings, original) {
        _enableReloads();
      },
      onreset: function(settings, original) {
      var input = $(original).find('input');
              var tr = input.parent().parent().parent().parent();
              var value = $.trim(input.val());
              var name = tr.data("name");

              if(value == "") {
                _showError("无效的命名  ''", "ERROR", "");
              }

              if (value != "" && name != "" && value != name) {
                $.ajax({
                  url: 'move',
                  type: 'POST',
                  data: {oldPath: _path + name, newPath: _path + value},
                  dataType: 'json'
                }).fail(function(jqXHR, textStatus, errorThrown) {
                  _showError("无法重命名 \"" + _path + name + "\"到\"" + _path + value + "\"", textStatus, errorThrown);
                }).always(function() {
                  _reload(_path);
                });
              }

        _enableReloads();
      },
      tooltip: 'Click to rename...'
    });
    
    $(".button-download").click(function(event) {
      var path = $(this).parent().parent().data("path");
      setTimeout(function() {
        window.location = "download?path=" + encodeURIComponent(path);
      }, 0);
    });
    
    $(".button-open").click(function(event) {
      var path = $(this).parent().parent().data("path");
      _reload(_path.slice(0, -1) + path);
    });
    
    $(".button-move").click(function(event) {
       if(_isRoot(_path)){
             _showError("没有权限移动", "ERROR", "");
             return false;
        }
      var path = $(this).parent().parent().data("path");
      if (path[path.length - 1] == "/") {
        path = path.slice(0, path.length - 1);
      }
      $("#move-input").data("path", path);
      $("#move-input").val(path);
      $("#move-modal").modal("show");
    });

    $(".button-delete").click(function(event) {
       if(_isRoot(_path)){
             _showError("没有权限删除该目录", "ERROR", "");
             return false;
        }
        $(this).attr('disabled',true);
        var path = $(this).parent().parent().data("path");
        $.ajax({
            url: 'delete',
            type: 'POST',
            data: {path: path},
            dataType: 'json'
        }).fail(function(jqXHR, textStatus, errorThrown) {
            _showError("删除失败 \"" + path + "\"", textStatus, errorThrown);
            $(this).attr('disabled',false);
        }).always(function() {
            $(this).attr('disabled',false);
            _reload(_path);
            });
    });
    
    $(document).scrollTop(scrollPosition);
  }).always(function() {
    _enableReloads();
  });
}

$(document).ready(function() {

  // Workaround Firefox and IE not showing file selection dialog when clicking on "upload-file" <button>
  // Making it a <div> instead also works but then it the button doesn't work anymore with tab selection or accessibility
  $("#upload-file").click(function(event) {
    $("#fileupload").click();
  });

  // Prevent event bubbling when using workaround above
  $("#fileupload").click(function(event) {
    event.stopPropagation();
    if(_isRoot(_path)){
         _showError("没有权限上传内容到 " + _path, "ERROR", "");
         return false;
    }
  });

  $("#fileupload").fileupload({
    dropZone: $(document),
    pasteZone: null,
    autoUpload: true,
    sequentialUploads: true,
    // limitConcurrentUploads: 2,
    // forceIframeTransport: true,

    url: 'upload',
    type: 'POST',
    dataType: 'json',

    start: function(e) {
      $(".uploading").show();
    },

    stop: function(e) {
      $(".uploading").hide();
    },

    add: function(e, data) {
      var file = data.files[0];
      data.formData = {
        path: _path
      };
      data.context = $(tmpl("template-uploads", {
        path: _path + file.name
      })).appendTo("#uploads");
      var jqXHR = data.submit();
      data.context.find("button").click(function(event) {
        jqXHR.abort();
      });
    },

    progress: function(e, data) {
      var progress = parseInt(data.loaded / data.total * 100, 10);
      data.context.find(".progress-bar").css("width", progress + "%");
    },

    done: function(e, data) {
      _reload(_path);
    },

    fail: function(e, data) {
      var file = data.files[0];
      if (data.errorThrown != "abort") {
        _showError("上传 \"" + file.name + "\" 到 \"" + _path + "\" 失败", data.textStatus, data.errorThrown);
      }
    },

    always: function(e, data) {
      data.context.remove();
    },

  });

  $("#upload-folder").click(function(event) {
        $("#fileupload-folder").click();
  });

  $("#fileupload-folder").click(function(event) {
      event.stopPropagation();
         if(_isRoot(_path)){
               _showError("没有权限上传内容到" + _path, "ERROR", "");
               return false;
         }
  })

  $("#fileupload-folder").fileupload({
        dropZone:  $('#drop-folder'),
        pasteZone: null,
        autoUpload: true,
        sequentialUploads: true,
        // limitConcurrentUploads: 2,
        // forceIframeTransport: true,

        url: 'upload',
        type: 'POST',
        dataType: 'json',

        start: function(e) {
          $(".uploading").show();
        },

        stop: function(e) {
          $(".uploading").hide();
        },

        add: function(e, data) {
          var files = data.files;
          for (var i = 0; i < files.length; i++) {
            var file = files[i];
            var newData = $.extend({}, data);
            newData.files = [file];
            newData.formData = {
              path: _path + file.webkitRelativePath
            };
            newData.context = $(tmpl("template-uploads", {
              path: _path + file.webkitRelativePath
            })).appendTo("#uploads");
            var jqXHR = newData.submit();
            newData.context.find("button").click(function(event) {
              jqXHR.abort();
            });
          }
        },

        progress: function(e, data) {
          var progress = parseInt(data.loaded / data.total * 100, 10);
          data.context.find(".progress-bar").css("width", progress + "%");
        },

        done: function(e, data) {
          _reload(_path);
        },

        fail: function(e, data) {
          var file = data.files[0];
          if (data.errorThrown != "abort") {
            _showError("Failed uploading \"" + file.name + "\" to \"" + _path + "\"", data.textStatus, data.errorThrown);
          }
        },

        always: function(e, data) {
          data.context.remove();
        },
  });

  $("#create-input").keypress(function(event) {
    if (event.keyCode == ENTER_KEYCODE) {
      $("#create-confirm").click();
    };
  });

  $("#create-modal").on("shown.bs.modal", function(event) {
    $("#create-input").focus();
    $("#create-input").select();
  });

  $("#create-folder").click(function(event) {
  if(_isRoot(_path)){
     _showError("没有权限在创建该目录", "ERROR", "");
     return false;
  }
    $("#create-input").val("Untitled folder");
    $("#create-modal").modal("show");
  });

  $("#create-confirm").click(function(event) {
    $("#create-modal").modal("hide");
    var name = $("#create-input").val();
    if (name != "") {
      $.ajax({
        url: 'create',
        type: 'POST',
        data: {path: _path + name},
        dataType: 'json'
      }).fail(function(jqXHR, textStatus, errorThrown) {
        _showError("创建文件夹失败 \"" + name + "\" 到 \"" + _path + "\"", textStatus, errorThrown);
      }).always(function() {
        _reload(_path);
      });
    }
  });

  $("#move-input").keypress(function(event) {
    if (event.keyCode == ENTER_KEYCODE) {
      $("#move-confirm").click();
    };
  });

  $("#move-modal").on("shown.bs.modal", function(event) {
    $("#move-input").focus();
    $("#move-input").select();
  })

  $("#move-confirm").click(function(event) {
    $("#move-modal").modal("hide");
    var oldPath = $("#move-input").data("path");
    var newPath = $("#move-input").val();
    if ((newPath != "") && (newPath[0] == "/") && (newPath != oldPath)) {
      $.ajax({
        url: 'move',
        type: 'POST',
        data: {oldPath: oldPath, newPath: newPath},
        dataType: 'json'
      }).fail(function(jqXHR, textStatus, errorThrown) {
        _showError("无法移动 \"" + oldPath + "\" 到 \"" + newPath + "\"", textStatus, errorThrown);
      }).always(function() {
        _reload(_path);
      });
    }
  });

  $("#reload").click(function(event) {
    _reload(_path);
  });

  _reload(_postdir);

});
