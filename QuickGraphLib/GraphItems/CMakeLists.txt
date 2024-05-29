# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

set(QGL_GI_QML_FILES
    AxHLine.qml AxVLine.qml BasicLegend.qml GraphItemDragHandler.qml Histogram.qml Marker.qml
    AxHSpan.qml AxVSpan.qml BasicLegendItem.qml Contour.qml Grid.qml Line.qml
)
qt_add_qml_module(QuickGraphLibGraphItems
    URI QuickGraphLib.GraphItems
    SHARED
    VERSION 1.0
    QML_FILES ${QGL_GI_QML_FILES}
    SOURCES helpers/HistogramHelper.cpp helpers/HistogramHelper.hpp helpers/GridHelper.hpp helpers/GridHelper.cpp
    PLUGIN_TARGET QuickGraphLibGraphItems
    DEPENDENCIES QtQuick QuickGraphLib
)

target_compile_definitions(QuickGraphLibGraphItems PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(QuickGraphLibGraphItems PRIVATE Qt6::Quick)
target_include_directories(QuickGraphLibGraphItems PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/helpers)

install(TARGETS QuickGraphLibGraphItems DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib/GraphItems)
install(FILES ${QGL_GI_QML_FILES} DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib/GraphItems)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/qmldir ${CMAKE_CURRENT_BINARY_DIR}/QuickGraphLibGraphItems.qmltypes
    DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib/GraphItems
)
