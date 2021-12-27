
add_library(StdlibUnittestCXX OBJECT
  InspectValue.cpp
  InterceptTraps.cpp
  OpaqueIdentityFunctions.cpp)
target_compile_definitions(StdlibUnittestCXX PRIVATE
  $<$<PLATFORM_ID:Windows>:_CRT_SECURE_NO_WARNINGS>)
# TODO(compnerd) wire up Swift source and binary directories
target_include_directories(StdlibUnittestCXX PRIVATE
  ${SWIFT_SOURCE_DIR}/include
  ${SWIFT_BUILD_DIR}/include)
target_link_libraries(StdlibUnittestCXX PRIVATE
  swiftLLVMSupport)

add_library(StdlibUnittest
  StdlibUnittest.swift

  CheckStrideable.swift
  InspectValue.swift
  LifetimeTracked.swift
  MinimalTypes.swift
  OpaqueIdentityFunctions.swift
  RaceTest.swift
  Statistics.swift
  StdlibCoreExtras.swift
  StringConvertible.swift
  SymbolLookup.swift
  TestHelpers.swift
  TypeIndexed.swift)
target_compile_definitions(StdlibUnittest PRIVATE
  $<$<CONFIG:Debug>:SWIFT_STDLIB_DEBUG>
  $<$<BOOL:${SWIFT_STDLIB_ENABLE_REFLECTION}>:SWIFT_ENABLE_REFLECTION>
  $<$<BOOL:${SWIFT_RUNTIME_ENABLE_LEAK_CHECKER}>:SWIFT_RUNTIME_ENABLE_LEAK_CHECKER>)
target_compile_options(StdlibUnittest PRIVATE
  "SHELL:-Xfrontend -disable-objc-attr-requires-foundation-module")
target_link_libraries(StdlibUnittest PRIVATE
  $<TARGET_OBJECTS:StdlibUnittestCXX>
  SwiftPrivate
  SwiftPrivateLibcExtras
  SwiftPrivateThreadExtras
  $<$<BOOL:${SWIFT_ENABLE_EXPERIMENTAL_CONCURRENCY}>:swift_Concurrency>)
