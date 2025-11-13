# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: MIT

list(APPEND CMAKE_PROGRAM_PATH "${CMAKE_SOURCE_DIR}/venv/Scripts")
find_package(Python COMPONENTS Interpreter REQUIRED)
list(APPEND CMAKE_PREFIX_PATH "${Python_SITELIB}/shiboken6_generator/lib/cmake")

if(ENABLE_MANYLINUX_BUILD)
    # HACK https://bugreports.qt.io/browse/PYSIDE-3233
    file(
        READ
        "${Python_SITELIB}/shiboken6_generator/lib/cmake/Shiboken6Tools/Shiboken6ToolsConfig.cmake"
        FILE_CONTENTS
    )
    string(
        REPLACE
        "find_dependency(Python COMPONENTS Interpreter Development)"
        "find_dependency(Python COMPONENTS Interpreter Development.Module)"
        FILE_CONTENTS
        "${FILE_CONTENTS}"
    )
    file(
        WRITE
        "${Python_SITELIB}/shiboken6_generator/lib/cmake/Shiboken6Tools/Shiboken6ToolsConfig.cmake"
        "${FILE_CONTENTS}"
    )
    file(
        READ
        "${Python_SITELIB}/shiboken6/lib/cmake/Shiboken6/ShibokenHelpers.cmake"
        FILE_CONTENTS
    )
    string(
        REPLACE
        "COMPONENTS Interpreter Development\n"
        "COMPONENTS Interpreter Development.Module\n"
        FILE_CONTENTS
        "${FILE_CONTENTS}"
    )
    file(
        WRITE
        "${Python_SITELIB}/shiboken6/lib/cmake/Shiboken6/ShibokenHelpers.cmake"
        "${FILE_CONTENTS}"
    )
endif()

find_package(Shiboken6Tools REQUIRED)

shiboken_generator_create_binding(
    EXTENSION_TARGET _QuickGraphLib
    GENERATED_SOURCES
        ${CMAKE_CURRENT_BINARY_DIR}/QuickGraphLib/_QuickGraphLib/_quickgraphlib_module_wrapper.cpp
        ${CMAKE_CURRENT_BINARY_DIR}/QuickGraphLib/_QuickGraphLib/qglpolygonf_wrapper.cpp
        ${CMAKE_CURRENT_BINARY_DIR}/QuickGraphLib/_QuickGraphLib/qgldoublelist_wrapper.cpp
        ${CMAKE_CURRENT_BINARY_DIR}/QuickGraphLib/_QuickGraphLib/helpers_wrapper.cpp
    HEADERS ${CMAKE_CURRENT_SOURCE_DIR}/Bindings.hpp
    TYPESYSTEM_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Bindings.xml
    LIBRARY_TARGET QuickGraphLib
    FORCE_LIMITED_API
    QT_MODULES Core Gui Qml Quick Network OpenGL
)
target_sources(
    _QuickGraphLib
    PRIVATE Bindings.hpp ShibokenHelpers.hpp ShibokenHelpers.cpp
)

# Generate .pyi stub file
if(ENABLE_STUB_GENERATION)
    set(pyi_path ${CMAKE_BINARY_DIR}/QuickGraphLib/_QuickGraphLib.pyi)
    add_custom_command(
        OUTPUT ${pyi_path}
        COMMAND
            "${Python_EXECUTABLE}" ${CMAKE_CURRENT_SOURCE_DIR}/pyigen.py
            $<TARGET_FILE:_QuickGraphLib> --outpath
            ${CMAKE_BINARY_DIR}/QuickGraphLib
        DEPENDS
            $<TARGET_FILE:_QuickGraphLib>
            ${CMAKE_CURRENT_SOURCE_DIR}/pyigen.py
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Running stub generation for for _QuickGraphLib."
    )

    add_custom_target(QuickGraphLibPythonStubs ALL DEPENDS ${pyi_path})
endif()

# Install files
install(TARGETS _QuickGraphLib DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib)
install(FILES ${pyi_path} DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib)
