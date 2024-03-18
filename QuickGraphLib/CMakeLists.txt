qt_add_qml_module(QuickGraphLib
    URI QuickGraphLib
    SHARED
    VERSION 1.0
    QML_FILES AntialiasingContainer.qml Axis.qml GraphArea.qml ScalingContainer.qml ZoomPanHandler.qml
    SOURCES helpers/Helpers.cpp helpers/Helpers.hpp helpers/AxisHelper.hpp helpers/AxisHelper.cpp
    PLUGIN_TARGET QuickGraphLib
    DEPENDENCIES QtQuick
)

target_compile_definitions(QuickGraphLib PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(QuickGraphLib PRIVATE Qt6::Quick)
target_include_directories(QuickGraphLib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/helpers)

add_subdirectory(PreFabs)
add_subdirectory(GraphItems)
