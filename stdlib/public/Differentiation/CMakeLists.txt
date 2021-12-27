#===--- CMakeLists.txt - Differentiable programming support library ------===#
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2019 - 2020 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See https://swift.org/LICENSE.txt for license information
# See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
#
#===----------------------------------------------------------------------===#

add_library(_Differentiation-install_name OBJECT
  ${PROJECT_SOURCE_DIR}/linker-support/magic-symbols-for-install-name.c)

add_library(swift_Differentiation
  Differentiable.swift
  DifferentialOperators.swift
  DifferentiationUtilities.swift
  AnyDifferentiable.swift
  ArrayDifferentiation.swift
  OptionalDifferentiation.swift)
swift_gyb_target_sources(swift_Differentiation PRIVATE
  FloatingPointDifferentiation.swift.gyb
  TgmathDerivatives.swift.gyb
  SIMDDifferentiation.swift.gyb)
set_target_properties(swift_Differentiation PROPERTIES
  Swift_MODULE_NAME _Differentiation)
target_compile_options(swift_Differentiation PRIVATE
  -parse-stdlib)
target_link_libraries(swift_Differentiation PRIVATE
  $<TARGET_OBJECTS:_Differentiation-install_name>)
target_link_libraries(swift_Differentiation PUBLIC
  swiftCore)
