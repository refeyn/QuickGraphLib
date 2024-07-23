# Copyright (C) 2023 The Qt Company Ltd.
# SPDX-License-Identifier: BSD-3-Clause

set(CMAKE_PROGRAM_PATH "${CMAKE_PROGRAM_PATH};${CMAKE_SOURCE_DIR}/venv/Scripts")
find_package(Python COMPONENTS Interpreter Development.SABIModule REQUIRED)

set(sample_library "QuickGraphLib")
set(bindings_library "_QuickGraphLib")
set(wrapped_header ${CMAKE_CURRENT_SOURCE_DIR}/Bindings.hpp)
set(typesystem_file ${CMAKE_CURRENT_SOURCE_DIR}/Bindings.xml)
set(generated_sources
    ${CMAKE_CURRENT_BINARY_DIR}/${sample_library}/${bindings_library}/_quickgraphlib_module_wrapper.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/${sample_library}/${bindings_library}/qglpolygonf_wrapper.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/${sample_library}/${bindings_library}/qgldoublelist_wrapper.cpp)


# ================================== Shiboken detection ======================================

# Macro to get various pyside / python include / link flags and paths.
# Uses the not entirely supported utils/pyside_config.py file.
macro(pyside_config option output_var)
    if(${ARGC} GREATER 2)
        set(is_list ${ARGV2})
    else()
        set(is_list "")
    endif()

    execute_process(
      COMMAND ${Python_EXECUTABLE} "${CMAKE_CURRENT_SOURCE_DIR}/pyside_config.py"
              ${option}
      OUTPUT_VARIABLE ${output_var}
      OUTPUT_STRIP_TRAILING_WHITESPACE)

    if ("${${output_var}}" STREQUAL "")
        message(FATAL_ERROR "Error: Calling pyside_config.py ${option} returned no output.")
    endif()
    if(is_list)
        string (REPLACE " " ";" ${output_var} "${${output_var}}")
    endif()
endmacro()

# Query for the shiboken generator path, Python path, include paths and linker flags.
pyside_config(--shiboken-generator-path shiboken_generator_path)
pyside_config(--pyside-path pyside_path)
pyside_config(--pyside-include-path pyside_include_dir 1)
pyside_config(--shiboken-generator-include-path shiboken_include_dir 1)
pyside_config(--shiboken-module-shared-libraries-cmake shiboken_shared_libraries 0)
pyside_config(--pyside-shared-libraries-cmake pyside_shared_libraries 0)

set(shiboken_path "${shiboken_generator_path}/shiboken6${CMAKE_EXECUTABLE_SUFFIX}")
if(NOT EXISTS ${shiboken_path})
    message(FATAL_ERROR "Shiboken executable not found at path: ${shiboken_path}")
endif()

# Set up the options to pass to shiboken.
set(INCLUDES "")
get_property(QT_CORE_INCLUDE_DIRS TARGET Qt6::Core PROPERTY INTERFACE_INCLUDE_DIRECTORIES)
foreach(INCLUDE_DIR ${QT_CORE_INCLUDE_DIRS})
    list(APPEND INCLUDES "-I${INCLUDE_DIR}")
endforeach()
get_property(QT_GUI_INCLUDE_DIRS TARGET Qt6::Gui PROPERTY INTERFACE_INCLUDE_DIRECTORIES)
foreach(INCLUDE_DIR ${QT_GUI_INCLUDE_DIRS})
    list(APPEND INCLUDES "-I${INCLUDE_DIR}")
endforeach()

# We need to include the headers for the module bindings that we use.
set(pyside_additional_includes "")
foreach(INCLUDE_DIR ${pyside_include_dir})
    list(APPEND pyside_additional_includes "${INCLUDE_DIR}/QtCore")
    list(APPEND pyside_additional_includes "${INCLUDE_DIR}/QtGui")
endforeach()

set(shiboken_options --generator-set=shiboken --enable-parent-ctor-heuristic
    --enable-pyside-extensions --enable-return-value-heuristic --use-isnull-as-nb_nonzero
    --avoid-protected-hack
    ${INCLUDES}
    -I${CMAKE_SOURCE_DIR}
    -T${CMAKE_SOURCE_DIR}
    -T${pyside_path}/typesystems
    --output-directory=${CMAKE_CURRENT_BINARY_DIR}
    )

set(generated_sources_dependencies ${wrapped_header} ${typesystem_file})

# Add custom target to run shiboken to generate the binding cpp files.
add_custom_command(OUTPUT ${generated_sources}
                    COMMAND ${shiboken_path}
                    ${shiboken_options} ${wrapped_header} ${typesystem_file}
                    DEPENDS ${generated_sources_dependencies}
                    IMPLICIT_DEPENDS CXX ${wrapped_header}
                    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                    COMMENT "Running generator for ${typesystem_file}.")


# =============================== CMake target - bindings_library =============================

python_add_library(${bindings_library} MODULE
    ${generated_sources} Bindings.hpp ShibokenHelpers.hpp ShibokenHelpers.cpp
    WITH_SOABI USE_SABI 3.7)

# Apply relevant include and link flags.
target_include_directories(${bindings_library} PRIVATE
    ${pyside_additional_includes} ${pyside_include_dir} ${shiboken_include_dir} ${CMAKE_SOURCE_DIR})

target_link_libraries(${bindings_library} PRIVATE
    ${pyside_shared_libraries} ${shiboken_shared_libraries} ${sample_library} Qt6::Core Qt6::Gui)

# Generate .pyi stub file
set(PYI_PATH ${CMAKE_BINARY_DIR}/${sample_library}/${bindings_library}.pyi)
add_custom_command(OUTPUT ${PYI_PATH}
                    COMMAND "${Python_EXECUTABLE}" ${CMAKE_CURRENT_SOURCE_DIR}/pyigen.py
                        $<TARGET_FILE:${bindings_library}>
                        --outpath ${CMAKE_BINARY_DIR}/${sample_library}
                    DEPENDS $<TARGET_FILE:${bindings_library}>
                    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                    COMMENT "Running stub generation for for ${bindings_library}.")

add_custom_target(QuickGraphLibPythonStubs ALL DEPENDS ${PYI_PATH})

# Install files
install(TARGETS ${bindings_library} DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib)
install(FILES ${PYI_PATH} DESTINATION ${INSTALL_SUBPATH}/QuickGraphLib)
