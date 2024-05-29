# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

set(QGL_QML_FILES AntialiasingContainer.qml Axis.qml GraphArea.qml ScalingContainer.qml ZoomPanHandler.qml TickLabel.qml)
qt_add_qml_module(QuickGraphLib
    URI QuickGraphLib
    SHARED
    VERSION 1.0
    QML_FILES ${QGL_QML_FILES}
    SOURCES helpers/Helpers.cpp helpers/Helpers.hpp helpers/AxisHelper.hpp helpers/AxisHelper.cpp helpers/Foreign.hpp
    PLUGIN_TARGET QuickGraphLib
    DEPENDENCIES QtQuick
)

target_compile_definitions(QuickGraphLib PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(QuickGraphLib PRIVATE Qt6::Quick Qt6::Svg)
target_include_directories(QuickGraphLib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/helpers)

install(TARGETS QuickGraphLib DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib)
install(FILES ${QGL_QML_FILES} DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/qmldir ${CMAKE_CURRENT_BINARY_DIR}/QuickGraphLib.qmltypes
    DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib
)

add_subdirectory(PreFabs)
add_subdirectory(GraphItems)
