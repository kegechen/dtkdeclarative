set(BIN_NAME dtk-exhibition)

find_package(Qt5 COMPONENTS Quick QuickControls2)
find_package(DtkCore REQUIRED)
find_package(DtkGui REQUIRED)

message("${BIN_NAME} output dir:${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")

add_executable(${BIN_NAME} 
    ./main.cpp 
    ./qml.qrc
    ./assets.qrc
)

target_link_directories(${BIN_NAME} PRIVATE ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})

target_include_directories(${BIN_NAME} PUBLIC
    ${Qt5Quick_INCLUDE_DIRS}
    ${Qt5QuickControls2_INCLUDE_DIRS}
    ${DtkCore_INCLUDE_DIR}
    ${DtkGui_INCLUDE_DIR}
)

target_link_libraries(${BIN_NAME} PRIVATE
    Qt5::Quick 
    Qt5::QuickControls2
    ${DtkCore_LIBRARIES}
    ${DtkGui_LIBRARIES}
    dtkdeclarative
)

install(FILES ${BIN_NAME} DESTINATION "${CMAKE_INSTALL_PREFIX}/bin")
install(FILES ${CMAKE_CURRENT_LIST_DIR}/dtk-exhibition.desktop DESTINATION "${CMAKE_INSTALL_PREFIX}/share/applications")
