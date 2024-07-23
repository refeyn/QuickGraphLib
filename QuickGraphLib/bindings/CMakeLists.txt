# SPDX-FileCopyrightText: Copyright (C) 2023 The Qt Company Ltd.
# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: BSD-3-Clause

set(CMAKE_PROGRAM_PATH "${CMAKE_PROGRAM_PATH};${CMAKE_SOURCE_DIR}/venv/Scripts")
find_package(Python COMPONENTS Interpreter Development.SABIModule REQUIRED)

# Macro to get various pyside / python include / link flags and paths.
# Uses the not entirely supported utils/pyside_config.py file.
macro(pyside_config option output_var)
    if(${ARGC} GREATER 2)
        set(is_list ${ARGV2})
    else()
        set(is_list "")
    endif()

    execute_process(
        COMMAND
            ${Python_EXECUTABLE} "${CMAKE_CURRENT_SOURCE_DIR}/pyside_config.py"
            ${option}
        OUTPUT_VARIABLE ${output_var}
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    if("${${output_var}}" STREQUAL "")
        message(
            FATAL_ERROR
            "Error: Calling pyside_config.py ${option} returned no output."
        )
    endif()
    if(is_list)
        string(REPLACE " " ";" ${output_var} "${${output_var}}")
    endif()
endmacro()

# Query for the shiboken generator path, Python path, include paths and linker flags.
pyside_config(--shiboken-generator-path shiboken_generator_path)
pyside_config(--pyside-path pyside_path)
pyside_config(--pyside-include-path pyside_include_dir 1)
pyside_config(--shiboken-generator-include-path shiboken_include_dir 1)
pyside_config(--shiboken-module-shared-libraries-cmake shiboken_shared_libraries 0)
pyside_config(--pyside-shared-libraries-cmake pyside_shared_libraries 0)

set(shiboken_path
    "${shiboken_generator_path}/shiboken6${CMAKE_EXECUTABLE_SUFFIX}"
)
if(NOT EXISTS ${shiboken_path})
    message(
        FATAL_ERROR
        "Shiboken executable not found at path: ${shiboken_path}"
    )
endif()

# Set up the options to pass to shiboken.
set(INCLUDES "")
get_property(
    QT_CORE_INCLUDE_DIRS
    TARGET Qt6::Core
    PROPERTY INTERFACE_INCLUDE_DIRECTORIES
)
foreach(INCLUDE_DIR ${QT_CORE_INCLUDE_DIRS})
    list(APPEND INCLUDES "-I${INCLUDE_DIR}")
endforeach()
get_property(
    QT_GUI_INCLUDE_DIRS
    TARGET Qt6::Gui
    PROPERTY INTERFACE_INCLUDE_DIRECTORIES
)
foreach(INCLUDE_DIR ${QT_GUI_INCLUDE_DIRS})
    list(APPEND INCLUDES "-I${INCLUDE_DIR}")
endforeach()

# We need to include the headers for the module bindings that we use.
set(pyside_additional_includes "")
foreach(INCLUDE_DIR ${pyside_include_dir})
    list(APPEND pyside_additional_includes "${INCLUDE_DIR}/QtCore")
    list(APPEND pyside_additional_includes "${INCLUDE_DIR}/QtGui")
endforeach()

set(shiboken_options
    --generator-set=shiboken
    --enable-parent-ctor-heuristic
    --enable-pyside-extensions
    --enable-return-value-heuristic
    --use-isnull-as-nb_nonzero
    --avoid-protected-hack
    ${INCLUDES}
    -I${CMAKE_SOURCE_DIR}
    -T${CMAKE_SOURCE_DIR}
    -T${pyside_path}/typesystems
    --output-directory=${CMAKE_CURRENT_BINARY_DIR}
    --compiler-path=${CMAKE_CXX_COMPILER}
)

set(wrapped_header ${CMAKE_CURRENT_SOURCE_DIR}/Bindings.hpp)
set(typesystem_file ${CMAKE_CURRENT_SOURCE_DIR}/Bindings.xml)
set(generated_sources_dependencies ${wrapped_header} ${typesystem_file})
set(generated_sources
    ${CMAKE_CURRENT_BINARY_DIR}/QuickGraphLib/_QuickGraphLib/_quickgraphlib_module_wrapper.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/QuickGraphLib/_QuickGraphLib/qglpolygonf_wrapper.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/QuickGraphLib/_QuickGraphLib/qgldoublelist_wrapper.cpp
)

# Add custom target to run shiboken to generate the binding cpp files.
add_custom_command(
    OUTPUT ${generated_sources}
    COMMAND
        ${shiboken_path} ${shiboken_options} ${wrapped_header}
        ${typesystem_file}
    DEPENDS ${generated_sources_dependencies}
    IMPLICIT_DEPENDS CXX ${wrapped_header}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Running generator for ${typesystem_file}."
)

python_add_library(
    _QuickGraphLib
    MODULE
    ${generated_sources}
    Bindings.hpp
    ShibokenHelpers.hpp
    ShibokenHelpers.cpp
    WITH_SOABI
    USE_SABI
    3.7
)

# Apply relevant include and link flags.
target_include_directories(
    _QuickGraphLib
    PRIVATE
        ${pyside_additional_includes}
        ${pyside_include_dir}
        ${shiboken_include_dir}
        ${CMAKE_SOURCE_DIR}
)

target_link_libraries(
    _QuickGraphLib
    PRIVATE
        ${pyside_shared_libraries}
        ${shiboken_shared_libraries}
        QuickGraphLib
        Qt6::Core
        Qt6::Gui
)

# Generate .pyi stub file
set(pyi_path ${CMAKE_BINARY_DIR}/QuickGraphLib/_QuickGraphLib.pyi)
add_custom_command(
    OUTPUT ${pyi_path}
    COMMAND
        "${Python_EXECUTABLE}" ${CMAKE_CURRENT_SOURCE_DIR}/pyigen.py
        $<TARGET_FILE:_QuickGraphLib> --outpath
        ${CMAKE_BINARY_DIR}/QuickGraphLib
    DEPENDS $<TARGET_FILE:_QuickGraphLib>
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Running stub generation for for _QuickGraphLib."
)

add_custom_target(QuickGraphLibPythonStubs ALL DEPENDS ${pyi_path})

# Install files
install(TARGETS _QuickGraphLib DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib)
install(FILES ${pyi_path} DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib)
