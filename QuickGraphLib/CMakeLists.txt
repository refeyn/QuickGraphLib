# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

set(QGL_QML_FILES
    AntialiasingContainer.qml
    Axis.qml
    GraphArea.qml
    ScalingContainer.qml
    ZoomPanHandler.qml
    TickLabel.qml
    ShapeRepeater.qml
)

add_library(QuickGraphLibPlugin SHARED Plugin.cpp)
target_link_libraries(QuickGraphLibPlugin PRIVATE Qt6::Gui)
qt_add_qml_module(QuickGraphLib
    URI QuickGraphLib
    SHARED
    VERSION 1.0
    QML_FILES ${QGL_QML_FILES}
    PLUGIN_TARGET QuickGraphLibPlugin
    NO_GENERATE_PLUGIN_SOURCE
    NO_PLUGIN_OPTIONAL
    DEPENDENCIES QtQuick
    SOURCES
        helpers/Helpers.cpp helpers/Helpers.hpp helpers/AxisHelper.hpp helpers/AxisHelper.cpp helpers/Foreign.hpp
        ImageView.hpp ImageView.cpp ColorMaps.hpp ColorMaps.cpp DataTypes.hpp DataTypes.cpp bindings/Bindings.hpp QuickGraphLib.hpp
)
set_property(
    TARGET QuickGraphLib
    PROPERTY LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)
set_property(
    TARGET QuickGraphLib
    PROPERTY RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

target_compile_definitions(
    QuickGraphLib
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)
target_link_libraries(QuickGraphLib PRIVATE Qt6::Quick Qt6::Svg)
target_include_directories(
    QuickGraphLib
    PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/helpers
)

set(QGL_PYTHON_FILES
    __init__.py
    consts.py
    contours.py
    py.typed
    _version.py
)
foreach(PYTHON_FILE ${QGL_PYTHON_FILES})
    add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${PYTHON_FILE}
        COMMAND
            ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/${PYTHON_FILE}
            ${CMAKE_CURRENT_BINARY_DIR}/${PYTHON_FILE}
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${PYTHON_FILE}
    )
endforeach()
list(TRANSFORM QGL_PYTHON_FILES PREPEND "${CMAKE_CURRENT_BINARY_DIR}/")
add_custom_target(QuickGraphLibPythonFiles ALL DEPENDS ${QGL_PYTHON_FILES})

install(
    TARGETS QuickGraphLib
    RUNTIME DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib
    LIBRARY DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib
)
install(
    TARGETS QuickGraphLibPlugin
    RUNTIME DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib
    LIBRARY DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib
)
install(FILES ${QGL_QML_FILES} DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib)
install(
    FILES
        ${CMAKE_CURRENT_BINARY_DIR}/qmldir
        ${CMAKE_CURRENT_BINARY_DIR}/QuickGraphLib.qmltypes
    DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib
)
install(FILES ${QGL_PYTHON_FILES} DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib)

add_subdirectory(PreFabs)
add_subdirectory(GraphItems)
add_subdirectory(bindings)
