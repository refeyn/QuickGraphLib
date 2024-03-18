qt_add_qml_module(QuickGraphLibPreFabs
    URI QuickGraphLib.PreFabs
    SHARED
    VERSION 1.0
    QML_FILES XYAxes.qml
    PLUGIN_TARGET QuickGraphLibPreFabs
)

target_compile_definitions(QuickGraphLibPreFabs PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(QuickGraphLibPreFabs PRIVATE Qt6::Quick)