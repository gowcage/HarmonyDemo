# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(NDKDemo)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

# 增加hiloglib库引用
find_library(
    # Sets the name of the path variable.
    hilog-lib
    # Specifies the name of the NDK library that
    # you want CMake to locate.
    hilog_ndk.z
)

add_library(entry SHARED napi_init.cpp)
target_link_libraries(entry PUBLIC ${hilog-lib} libace_napi.z.so libohfileuri.so)