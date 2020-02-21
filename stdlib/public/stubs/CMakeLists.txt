add_library(swiftStubs OBJECT
  Assert.cpp
  Availability.mm
  CommandLine.cpp
  FoundationHelpers.mm
  GlobalObjects.cpp
  LibcShims.cpp
  MathStubs.cpp
  OptionalBridgingHelper.mm
  Random.cpp
  Reflection.mm
  Stubs.cpp
  SwiftNativeNSXXXBase.mm.gyb
  SwiftNativeNSXXXBaseARC.m
  ThreadLocalStorage.cpp
  UnicodeNormalization.cpp)
# set_source_files_properties(SwiftNativeNSXXXBaseARC.m PROPERTIES
#   COMPILE_OPTIONS $<$<STREQUAL:${CMAKE_CXX_SIMULATE_ID},MSVC>:/clang:>-fobjc-arc)
target_compile_definitions(swiftStubs PRIVATE
  swiftCore_EXPORTS)
target_link_libraries(swiftStubs PRIVATE
  ICU::uc)
