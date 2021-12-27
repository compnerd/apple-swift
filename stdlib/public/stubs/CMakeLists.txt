
add_library(swiftStubs OBJECT
  Assert.cpp
  Availability.mm
  FoundationHelpers.mm
  GlobalObjects.cpp
  LibcShims.cpp
  MathStubs.cpp
  OptionalBridgingHelper.mm
  Random.cpp
  Reflection.mm
  Stubs.cpp
  SwiftNativeNSObject.mm
  SwiftNativeNSXXXBaseARC.m
  ThreadLocalStorage.cpp
  Unicode/UnicodeData.cpp
  Unicode/UnicodeGrapheme.cpp
  Unicode/UnicodeNormalization.cpp
  Unicode/UnicodeScalarProps.cpp)
swift_gyb_target_sources(swiftStubs PRIVATE
  SwiftNativeNSXXXBase.mm.gyb)
set_source_files_properties(SwiftNativeNSXXXBaseARC.m PROPERTIES
  COMPILE_FLAGS $<$<PLATFORM_ID:Darwin>:-fobjc-arc>)
target_compile_definitions(swiftStubs PRIVATE
  $<$<PLATFORM_ID:Windows>:_CRT_SECURE_NO_WARNINGS>
  swiftCore_EXPORTS)
target_include_directories(swiftStubs PRIVATE
  ${PROJECT_SOURCE_DIR}/public)
target_link_libraries(swiftStubs PRIVATE
  swiftLLVMSupport)
