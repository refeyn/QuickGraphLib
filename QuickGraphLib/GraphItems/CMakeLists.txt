qt_add_qml_module(QuickGraphLibGraphItems
    URI QuickGraphLib.GraphItems
    SHARED
    VERSION 1.0
    QML_FILES
        AxHLine.qml AxVLine.qml BasicLegend.qml GraphItemDragHandler.qml Histogram.qml Marker.qml
        AxHSpan.qml AxVSpan.qml BasicLegendItem.qml Contour.qml Grid.qml Line.qml
    SOURCES helpers/HistogramHelper.cpp helpers/HistogramHelper.hpp
    PLUGIN_TARGET QuickGraphLibGraphItems
    DEPENDENCIES QtQuick
)

target_compile_definitions(QuickGraphLibGraphItems PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(QuickGraphLibGraphItems PRIVATE Qt6::Quick)
target_include_directories(QuickGraphLibGraphItems PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/helpers)
