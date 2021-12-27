#===----------------------------------------------------------------------===#
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2014 - 2019 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See https://swift.org/LICENSE.txt for license information
# See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
#
#===----------------------------------------------------------------------===#

find_package(Python3 COMPONENTS Interpreter REQUIRED)

function(swift_gyb_target_sources target scope)
  foreach(source ${ARGN})
    get_filename_component(generated_source ${source} NAME_WLE)
    add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${generated_source}
      COMMAND
        $<TARGET_FILE:Python3::Interpreter> ${PROJECT_SOURCE_DIR}/../utils/gyb -D CMAKE_SIZEOF_VOID_P=${CMAKE_SIZEOF_VOID_P} -o $<TARGET_PROPERTY:${target},BINARY_DIR>/${generated_source}.tmp ${CMAKE_CURRENT_SOURCE_DIR}/${source}
      COMMAND
        ${CMAKE_COMMAND} -E copy_if_different $<TARGET_PROPERTY:${target},BINARY_DIR>/${generated_source}.tmp $<TARGET_PROPERTY:${target},BINARY_DIR>/${generated_source}
      COMMAND
        ${CMAKE_COMMAND} -E remove $<TARGET_PROPERTY:${target},BINARY_DIR>/${generated_source}.tmp
      DEPENDS
        ${CMAKE_CURRENT_SOURCE_DIR}/${source})
    set_source_files_properties($<TARGET_PROPERTY:${target},BINARY_DIR>/${generated_source} PROPERTIES
      GENERATED TRUE)
    target_sources(${target} ${scope}
      $<TARGET_PROPERTY:${target},BINARY_DIR>/${generated_source})
  endforeach()
endfunction()
