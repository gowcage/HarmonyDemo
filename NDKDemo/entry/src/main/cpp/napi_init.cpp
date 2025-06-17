#include "hilog/log.h"
#include "napi/native_api.h"
#include <cstdio>
#include <filemanagement/file_uri/oh_file_uri.h>
#include <mutex>
#include <stdio.h>
#include <string.h>
#include <thread>

#define LOG_DOMAIN 0x0001
#define LOG_TAG "native: ->"

static napi_value Add(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    double value0;
    napi_get_value_double(env, args[0], &value0);

    double value1;
    napi_get_value_double(env, args[1], &value1);

    napi_value sum;
    napi_create_double(env, value0 + value1, &sum);

    return sum;
}

static napi_value Test(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    size_t uriLen;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &uriLen); // 调两次，第一次获取长度

    char *uri = new char[uriLen + 1];
    napi_get_value_string_utf8(env, args[0], uri, uriLen + 1, &uriLen);

    OH_LOG_INFO(LOG_APP, "url is %{public}s", uri);

    char *pathResult = NULL;
    unsigned int length = strlen(uri);
//    picker拿到的uri不能直接用，要通过OH_FileUri_GetPathFromUri转换，或者自己手动拼接
//    FileManagement_ErrCode ret = OH_FileUri_GetPathFromUri(uri, uriLen, &pathResult);
//    if (ret == 0 && pathResult != NULL) {
//        printf("pathResult=%s", pathResult); // PathResult值为：/data/storage/el2/base/files/test.txt
//        OH_LOG_INFO(LOG_APP, "pathResult=%s", pathResult);
//    }

    const char *fname = uri;
    const char *mod = "r";
    FILE *f = fopen(fname, mod);
    if (f) {
        OH_LOG_INFO(LOG_APP, "open file success");
    } else {
        OH_LOG_INFO(LOG_APP, "open file failed! %s", uri);
    }

    if (f)
        int ret = fclose(f);

    delete[] uri;
    if (pathResult != NULL) {
        free(pathResult);
    }
}

static napi_value getAudioInfo(napi_env env, napi_callback_info info) {
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    size_t nameLen;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &nameLen); // 调两次，第一次获取长度
    char *name = new char[nameLen + 1];
    napi_get_value_string_utf8(env, args[0], name, nameLen + 1, &nameLen);

    size_t pathLen;
    napi_get_value_string_utf8(env, args[1], nullptr, 0, &pathLen); // 调两次，第一次获取长度
    char *path = new char[pathLen + 1];
    napi_get_value_string_utf8(env, args[1], path, pathLen + 1, &pathLen);

    double size;
    napi_get_value_double(env, args[2], &size);

    OH_LOG_INFO(LOG_APP, "name is %{public}s", name);
    OH_LOG_INFO(LOG_APP, "path is %{public}s", path);
    OH_LOG_INFO(LOG_APP, "size is %{public}f", size);

    napi_value arg_obj;
    napi_create_object(env, &arg_obj);
    napi_set_named_property(env, arg_obj, "name", args[0]);
    napi_set_named_property(env, arg_obj, "path", args[1]);
    napi_set_named_property(env, arg_obj, "size", args[2]);

    free(name);
    free(path);
    return arg_obj;
}

//

// napi_ref callbackRef;

struct CallbackContext {
    napi_env env;
    napi_ref callbackRef; // 存储ArkTS回调的引用
    std::mutex mutex;     // 线程安全锁
} play_cb;

static napi_value registeCB(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1];

    // 获取传入的参数并依次放入参数数组中
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    // 创建持久化引用，防止GC回收
    napi_ref callbackRef;
    napi_create_reference(env, args[0], 1, &callbackRef);

    // 存储到全局上下文
    std::lock_guard<std::mutex> lock(play_cb.mutex);
    play_cb.env = env;
    play_cb.callbackRef = callbackRef;

    return NULL;
}

napi_ref cbObj = nullptr;
napi_threadsafe_function tsfn;
#define NUMBER 666

static void CallJs(napi_env env, napi_value js_cb, void *context, void *data) {
    napi_value argv;
    napi_create_int32(env, NUMBER, &argv);
    napi_value result = nullptr;
    napi_call_function(env, nullptr, js_cb, 1, &argv, &result);
}

static napi_value ThreadsTest(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value js_cb, work_name;
    napi_status status;
    status = napi_get_cb_info(env, info, &argc, &js_cb, nullptr, nullptr);
//    OH_LOG_INFO(LOG_APP, "ThreadSafeTest 0: %{public}d", status == napi_ok);
    // Set initial_refcount to 0 for a weak reference, >0 for a strong reference.
    status = napi_create_reference(env, js_cb, 1, &cbObj);
//    OH_LOG_INFO(LOG_APP, "napi_create_reference of js_cb to cbObj: %{public}d", status == napi_ok);
    status = napi_create_string_utf8(env, "Work Item", NAPI_AUTO_LENGTH, &work_name);
    status = napi_create_threadsafe_function(env, js_cb, NULL, work_name, 0, 1, NULL, NULL, NULL, CallJs, &tsfn);
//    OH_LOG_INFO(LOG_APP, "napi_create_threadsafe_function : %{public}d", status == napi_ok);
    std::thread t([]() {
        std::thread::id this_id = std::this_thread::get_id();
//        OH_LOG_INFO(LOG_APP, "thread0 %{public}d.\n", this_id);
        napi_status status;
        status = napi_acquire_threadsafe_function(tsfn);
//        OH_LOG_INFO(LOG_APP, "thread : %{public}d", status == napi_ok);
        napi_call_threadsafe_function(tsfn, NULL, napi_tsfn_blocking);
    });
    t.detach();
    return NULL;
}

static napi_value NAPI_Global_testCB(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int num;
    napi_get_value_int32(env, args[0], &num);

    // 构造参数
    napi_value obj;
    napi_create_object(env, &obj);

    switch (num) {
    case 1: {
        napi_value num;
        napi_create_int32(env, 666, &num);
        napi_set_named_property(env, obj, "num", num);
        break;
    }
    case 2: {
        napi_value str;
        napi_create_string_utf8(env, "hello", NAPI_AUTO_LENGTH, &str);
        napi_set_named_property(env, obj, "str", str);
        break;
    }
    case 3: {
        napi_value num;
        napi_create_int32(env, 666, &num);
        napi_set_named_property(env, obj, "num", num);
        napi_value str;
        napi_create_string_utf8(env, "hello", NAPI_AUTO_LENGTH, &str);
        napi_set_named_property(env, obj, "str", str);
        break;
    }
    }

    {
        std::lock_guard<std::mutex> lock(play_cb.mutex);

        // 获取回调函数
        napi_value jsCallback;
        napi_get_reference_value(env, play_cb.callbackRef, &jsCallback);

        // 执行回调
        napi_value result;
        napi_call_function(env, nullptr, jsCallback, 1, &obj, &result);
    }

    return NULL;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        {"add", nullptr, Add, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"test", nullptr, Test, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getAudioInfo", nullptr, getAudioInfo, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"registeCB", nullptr, registeCB, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"testCBInSubThread", nullptr, ThreadsTest, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"testCB", nullptr, NAPI_Global_testCB, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
