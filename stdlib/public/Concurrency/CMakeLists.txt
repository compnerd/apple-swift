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

add_library(_ConcurrencyRuntime OBJECT
  Actor.cpp
  AsyncLet.cpp
  AsyncStream.cpp
  Error.cpp
  GlobalExecutor.cpp
  Mutex.cpp
  Task.cpp
  TaskAlloc.cpp
  TaskGroup.cpp
  TaskLocal.cpp
  TaskStatus.cpp
  ThreadSanitizer.cpp)
target_sources(_ConcurrencyRuntime PRIVATE
  ${PROJECT_SOURCE_DIR}/linker-support/magic-symbols-for-install-name.c
  ${PROJECT_SOURCE_DIR}/public/CompatibilityOverride/CompatibilityOverride.cpp)
set_source_files_properties(TaskAlloc.cpp PROPERTIES
  COMPILE_OPTIONS -Wno-error=exit-time-destructors)
set_source_files_properties(Task.cpp PROPERTIES
  COMPILE_OPTIONS -Wno-error=global-constructors)
target_compile_definitions(_ConcurrencyRuntime PRIVATE
  swift_Concurrency_EXPORTS
  SWIFT_TARGET_LIBRARY_NAME=swift_Concurrency
  $<$<PLATFORM_ID:Windows>:_CRT_SECURE_NO_WARNINGS>
  $<$<NOT:$<STREQUAL:${SWIFT_CONCURRENCY_GLOBAL_EXECUTOR},dispatch>>:SWIFT_CONCURRENCY_ENABLE_DISPATCH=0>)
target_compile_options(_ConcurrencyRuntime PRIVATE
  $<$<PLATFORM_ID:Darwin>:-fswift-async-fp=always>
  $<$<NOT:$<PLATFORM_ID:Darwin>>:-fswift-async-fp=never>)
target_link_libraries(_ConcurrencyRuntime PUBLIC
  $<$<AND:$<STREQUAL:${SWIFT_CONCURRENCY_GLOBAL_EXECUTOR},dispatch>,$<NOT:$<PLATFORM_ID:Darwin>>>:dispatch>
  swiftLLVMSupport)

add_library(swift_Concurrency
  Actor.swift
  AsyncCompactMapSequence.swift
  AsyncDropFirstSequence.swift
  AsyncDropWhileSequence.swift
  AsyncFilterSequence.swift
  AsyncFlatMapSequence.swift
  AsyncIteratorProtocol.swift
  AsyncLet.swift
  AsyncMapSequence.swift
  AsyncPrefixSequence.swift
  AsyncPrefixWhileSequence.swift
  AsyncSequence.swift
  AsyncStream.swift
  AsyncStreamBuffer.swift
  AsyncThrowingCompactMapSequence.swift
  AsyncThrowingDropWhileSequence.swift
  AsyncThrowingFilterSequence.swift
  AsyncThrowingFlatMapSequence.swift
  AsyncThrowingMapSequence.swift
  AsyncThrowingPrefixWhileSequence.swift
  AsyncThrowingStream.swift
  CheckedContinuation.swift
  Deque.swift
  Errors.swift
  Executor.swift
  GlobalActor.swift
  MainActor.swift
  PartialAsyncTask.swift
  SourceCompatibilityShims.swift
  Task.swift
  TaskCancellation.swift
  TaskGroup.swift
  TaskLocal.swift
  TaskSleep.swift)
set_target_properties(swift_Concurrency PROPERTIES
  Swift_MODULE_NAME _Concurrency)
target_compile_options(swift_Concurrency PRIVATE
  -parse-stdlib
  # Don't emit extended frame info on platforms other than darwin, system
  # backtracer and system debugger are unlikely to support it.
  "SHELL:$<$<PLATFORM_ID:Darwin>:-Xfrontend -swift-async-frame-pointer=always>")
target_compile_options(swift_Concurrency PUBLIC
  "SHELL:-Xfrontend -enable-experimental-concurrency")
target_link_libraries(swift_Concurrency PRIVATE
  $<TARGET_OBJECTS:_ConcurrencyRuntime>)
target_link_libraries(swift_Concurrency PUBLIC
  $<$<AND:$<STREQUAL:${SWIFT_CONCURRENCY_GLOBAL_EXECUTOR},dispatch>,$<NOT:$<PLATFORM_ID:Darwin>>>:dispatch>
  swiftLLVMSupport
  swiftCore)
