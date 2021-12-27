#===--- CMakeLists.txt - Concurrency support library ---------------------===#
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

add_library(_Distributed-install_name OBJECT
  ${PROJECT_SOURCE_DIR}/linker-support/magic-symbols-for-install-name.c)

add_library(swift_Distributed
  AssertDistributed.swift
  DistributedActor.swift
  DistributedActorSystem.swift
  HeterogeneousBuffer.swift)
set_target_properties(swift_Distributed PROPERTIES
  Swift_MODULE_NAME _Distributed)
target_compile_options(swift_Distributed PRIVATE
  -parse-stdlib
  # FIXME(compnerd) is this needed for the Shims?
  "SHELL:-Xcc -Dswift_Distributed_EXPORTS")
target_compile_options(swift_Distributed PUBLIC
  "SHELL:-Xfrontend -enable-experimental-distributed")
target_link_libraries(swift_Distributed PRIVATE
  $<TARGET_OBJECTS:_Distributed-install_name>)
target_link_libraries(swift_Distributed PUBLIC
  swiftCore)
