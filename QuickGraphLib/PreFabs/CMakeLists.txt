# SPDX-FileCopyrightText: Copyright (c) 2024 Matthew Joyce and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

qt_add_qml_module(QuickGraphLibPreFabs
    URI QuickGraphLib.PreFabs
    SHARED
    VERSION 1.0
    QML_FILES XYAxes.qml
    PLUGIN_TARGET QuickGraphLibPreFabs
)

target_compile_definitions(QuickGraphLibPreFabs PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(QuickGraphLibPreFabs PRIVATE Qt6::Quick)

install(TARGETS QuickGraphLibPreFabs DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib/PreFabs)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/qmldir ${CMAKE_CURRENT_BINARY_DIR}/QuickGraphLibPreFabs.qmltypes
    DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib/PreFabs
)
