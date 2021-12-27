
add_library(swiftLLVMSupport STATIC
  ErrorHandling.cpp
  Hashing.cpp
  MemAlloc.cpp
  SmallPtrSet.cpp
  SmallVector.cpp
  StringRef.cpp)
target_compile_definitions(swiftLLVMSupport PUBLIC
  $<$<PLATFORM_ID:Windows>:_CRT_NONSTDC_NO_WARNINGS>)
target_compile_options(swiftLLVMSupport PRIVATE
  -Wno-error=format-nonliteral)
target_include_directories(swiftLLVMSupport PUBLIC
  ${PROJECT_SOURCE_DIR}/include)
