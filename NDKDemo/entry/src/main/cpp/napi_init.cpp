#include "hilog/log.h"
#include "napi/native_api.h"
#include <cstdio>
#include <filemanagement/file_uri/oh_file_uri.h>
#include <stdio.h>
#include <string.h>

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
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &uriLen);//调两次，第一次获取长度

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
    
    delete [] uri;
    if (pathResult != NULL) {
        free(pathResult);
    }
}
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {{"add", nullptr, Add, nullptr, nullptr, nullptr, napi_default, nullptr},
                                       {"test", nullptr, Test, nullptr, nullptr, nullptr, napi_default, nullptr}};
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
