# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

set(QGL_PF_QML_FILES XYAxes.qml ImageAxes.qml)
qt_add_qml_module(QuickGraphLibPreFabs
    URI QuickGraphLib.PreFabs
    SHARED
    VERSION 1.0
    QML_FILES ${QGL_PF_QML_FILES}
    PLUGIN_TARGET QuickGraphLibPreFabs
)

target_compile_definitions(
    QuickGraphLibPreFabs
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)
target_link_libraries(QuickGraphLibPreFabs PRIVATE Qt6::Quick)

install(
    TARGETS QuickGraphLibPreFabs
    DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib/PreFabs
)
install(
    FILES ${QGL_PF_QML_FILES}
    DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib/PreFabs
)
install(
    FILES
        ${CMAKE_CURRENT_BINARY_DIR}/qmldir
        ${CMAKE_CURRENT_BINARY_DIR}/QuickGraphLibPreFabs.qmltypes
    DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib/PreFabs
)
