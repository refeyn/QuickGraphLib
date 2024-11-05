# SPDX-FileCopyrightText: Copyright (C) 2023 The Qt Company Ltd.
# SPDX-FileCopyrightText: Copyright (c) 2024 Refeyn Ltd and other QuickGraphLib contributors
# SPDX-License-Identifier: BSD-3-Clause

set(CMAKE_PROGRAM_PATH "${CMAKE_PROGRAM_PATH};${CMAKE_SOURCE_DIR}/venv/Scripts")
find_package(Python COMPONENTS Interpreter Development.SABIModule REQUIRED)

# Query for the shiboken generator path, Python path, include paths and linker flags.
set(CMAKE_FIND_DEBUG_MODE TRUE)
find_program(shiboken_path NAMES shiboken6 REQUIRED)
find_path(
    pyside_typesystems_path
    NAMES PySide6/typesystems
    PATH_SUFFIXES share
    PATHS "${Python_SITELIB}"
    REQUIRED
)
find_path(
    shiboken_include_dir
    NAMES sbkpython.h
    PATH_SUFFIXES shiboken6 shiboken6_generator/include
    PATHS "${Python_SITELIB}"
    REQUIRED
)
find_path(
    pyside_include_dir
    NAMES pyside.h
    PATH_SUFFIXES PySide6 PySide6/include
    PATHS "${Python_SITELIB}"
    REQUIRED
)
find_library(
    shiboken_shared_libraries
    NAMES shiboken6 shiboken6.abi3 libshiboken6.abi3.so.6.8
    PATH_SUFFIXES shiboken6
    PATHS "${Python_SITELIB}"
    REQUIRED
)
find_library(
    pyside_shared_library
    NAMES pyside6 pyside6.abi3 libpyside6.abi3.so.6.8
    PATH_SUFFIXES PySide6
    PATHS "${Python_SITELIB}"
    REQUIRED
)
find_library(
    pyside_qml_shared_library
    NAMES pyside6qml pyside6qml.abi3 libpyside6qml.abi3.so.6.8
    PATH_SUFFIXES PySide6
    PATHS "${Python_SITELIB}"
    REQUIRED
)
set(CMAKE_FIND_DEBUG_MODE FALSE)

if(NOT EXISTS ${shiboken_path})
    message(
        FATAL_ERROR
        "Shiboken executable not found at path: ${shiboken_path}"
    )
endif()

if(EXISTS $ENV{LLVM_PATH})
    # Update shiboken's libclang to fix parsing of recent MSVC C++ headers
    configure_file(
        "$ENV{LLVM_PATH}/bin/libclang.dll"
        "${Python_SITELIB}/shiboken6_generator/libclang.dll"
        COPYONLY
    )
endif()

# Set up the options to pass to shiboken.
set(INCLUDES "")
if(DEFINED QT_HOST_PATH)
    list(APPEND INCLUDES "-I${QT_HOST_PATH}/include")
    list(APPEND INCLUDES "-I${QT_HOST_PATH}/include/QtCore")
    list(APPEND INCLUDES "-I${QT_HOST_PATH}/include/QtGui")
else()
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
endif()

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
    -T${pyside_typesystems_path}/PySide6/typesystems
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
    3.9
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
        ${pyside_shared_library}
        ${pyside_qml_shared_library}
        ${shiboken_shared_libraries}
        QuickGraphLib
        Qt6::Core
        Qt6::Gui
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
        DEPENDS $<TARGET_FILE:_QuickGraphLib>
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Running stub generation for for _QuickGraphLib."
    )

    add_custom_target(QuickGraphLibPythonStubs ALL DEPENDS ${pyi_path})
endif()

# Install files
install(TARGETS _QuickGraphLib DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib)
install(FILES ${pyi_path} DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib)
