
add_library(RuntimeUnittestCXX OBJECT
  ExclusivityTests.cpp)
# TODO(compnerd) wire up the Swift source tree
target_include_directories(RuntimeUnittestCXX PRIVATE
  ${SWIFT_SOURCE_DIR}/include
  ${SWIFT_BUILD_DIR}/include)
target_link_libraries(RuntimeUnittestCXX PRIVATE
  swiftLLVMSupport)

add_library(RuntimeUnittest
  RuntimeUnittest.swift)
target_link_libraries(RuntimeUnittest PRIVATE
  $<TARGET_OBJECTS:RuntimeUnittestCXX>)
