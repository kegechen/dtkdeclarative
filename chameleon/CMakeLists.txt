set(pluginName qtquickcontrols2chameleonstyleplugin)

set(CMAKE_AUTORCC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(TARGETPATH "QtQuick/Controls.2/Chameleon")

find_package(DtkGui REQUIRED)
find_package(Qt5 REQUIRED COMPONENTS
    Qml
    QuickCompiler
    Quick
    QuickControls2 REQUIRED
)

# qtHaveModule(quickcontrols2-private)
foreach(f ${Qt5QuickControls2_PRIVATE_INCLUDE_DIRS})
    if (EXISTS "${f}/private/qquickstyleplugin_p.h")
        message("exist QQuickStylePlugin")
        add_definitions(-DUSE_QQuickStylePlugin)
        break()
    else()
        #message("not exist ${f}/private/qquickstyleplugin_p.h")
    endif()
endforeach()

#Qt5QuickControls2_PRIVATE_INCLUDE_DIRS
#Qt5Quick_PRIVATE_INCLUDE_DIRS

include(imports/Chameleon/qml.cmake)
include(src/src.cmake)

qtquick_compiler_add_resources(RESOURCES ${CMAKE_CURRENT_LIST_DIR}/imports/Chameleon/qml.qrc)

add_library(${pluginName} SHARED
  ${SRC_FILES}
  ${RESOURCES} #   imports/Chameleon/qml.qrc
)

include_directories(../src)

target_link_directories(${pluginName} PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}/../src
)

target_link_libraries(
    ${pluginName} PRIVATE
    Qt5::Qml
    Qt5::Quick
    Qt5::QuickControls2
    dtkdeclarative
    -lpthread
)

# add_dependencies(${pluginName} dtkdeclarative)

set(compiler_path "${_qt5Core_install_prefix}/bin/qmlcachegen")
set(QMLC_FILES)
foreach(it ${QML_FILES})
    get_filename_component(extension ${it} EXT)
    if(extension STREQUAL ".qml" OR extension STREQUAL ".js" OR extension STREQUAL ".ui.qml")
        set(output_file "${it}c")
#        message("compiler_path: ${compiler_path}\nintput_file: ${it}\noutput_file: ${output_file}")
        #add_custom_command(OUTPUT ${output_file} COMMAND ${compiler_path}  ARGS ${it} -o ${output_file})
        execute_process(COMMAND ${compiler_path} ${it} -o ${output_file})
        list(APPEND QMLC_FILES ${output_file})
    endif()
endforeach()

include(GNUInstallDirs)
install(FILES ${JS_FILES} DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt5/qml/${TARGETPATH}")
install(FILES ${QML_FILES} DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt5/qml/${TARGETPATH}")
install(FILES ${QMLC_FILES} DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt5/qml/${TARGETPATH}")
