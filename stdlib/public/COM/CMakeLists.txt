#===--- CMakeLists.txt - COM support library ------------------------------===#
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2025 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See https://swift.org/LICENSE.txt for license information
# See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
#
#===----------------------------------------------------------------------===#

set(SWIFT_COM_SWIFT_FLAGS)

set(SWIFT_COM_SWIFT_SOURCES
  CLSID.swift
  GUID.swift
  IID.swift
  ISwiftObject.swift
  IUnknown.swift
  QueryInterface.swift
  Types.swift)

add_swift_target_library(swiftCOM ${SWIFT_STDLIB_LIBRARY_BUILD_TYPES} IS_STDLIB
  ${SWIFT_COM_SWIFT_SOURCES}

  SWIFT_MODULE_DEPENDS_WINDOWS CRT

  SWIFT_COMPILE_FLAGS
    ${SWIFT_STANDARD_LIBRARY_SWIFT_FLAGS}
    ${SWIFT_COM_SWIFT_FLAGS}
    -enable-experimental-com-interop

  LINK_FLAGS "${SWIFT_RUNTIME_SWIFT_LINK_FLAGS}"

  INSTALL_IN_COMPONENT stdlib
)
