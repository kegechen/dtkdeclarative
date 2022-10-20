cmake_minimum_required (VERSION 3.10)

set (VERSION "1.0.10" CACHE STRING "define project version")

project (DtkDeclarative
    VERSION "${VERSION}"
    DESCRIPTION "DTK Declarative module"
    HOMEPAGE_URL "https://github.com/linuxdeepin/dtkdeclarative"
    LANGUAGES CXX
)

include(GNUInstallDirs)

set (BUILD_DOCS ON CACHE BOOL "Generate doxygen-based documentation")
set (BUILD_TESTING ON CACHE BOOL "Build unit tests")
set (CMAKE_EXPORT_COMPILE_COMMANDS ON)
message("
    BUILD_DOCS:   ${BUILD_DOCS} \n
    BUILD_TESTING:${BUILD_TESTING} \n"
)

if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX /usr)
endif ()

set (USE_QQuickStylePlugin OFF)
foreach(f ${Qt5QuickControls2_PRIVATE_INCLUDE_DIRS})
    if (EXISTS "${f}/private/qquickstyleplugin_p.h")
        message("exist QQuickStylePlugin")
        add_definitions(-DUSE_QQuickStylePlugin)
        set (USE_QQuickStylePlugin ON)
        break()
    else()
        #message("not exist ${f}/private/qquickstyleplugin_p.h")
    endif()
endforeach()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -Wall -Wextra")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--as-needed")
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    # 加上 ASAN 检查后可能会导致 DEBUG 应用启动后退出。可以加上 ASAN_OPTIONS 环境变量来防止应用退出
    # ASAN_OPTIONS="halt_on_error=0" ASAN_OPTIONS="new_delete_type_mismatch=0"
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0 -g -fsanitize=address -fno-omit-frame-pointer")
else ()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Ofast")
endif ()

set(uri_path "org/deepin/dtk")

add_subdirectory(src)
add_subdirectory(chameleon)
add_subdirectory(qmlplugin)
add_subdirectory(examples)

if (BUILD_DOCS)
    add_subdirectory(docs)
endif ()

if (BUILD_TESTING)
    add_subdirectory(tests)
endif ()
