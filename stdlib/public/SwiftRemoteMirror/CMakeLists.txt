# {(lib)?}swiftRemoteMirror.{(dll|dylib|so)} should not have runtime
# dependencies; it's always built as a shared library.
add_library(swiftRemoteMirror SHARED
  SwiftRemoteMirror.cpp)
target_compile_definitions(swiftRemoteMirror PRIVATE
  SWIFT_INLINE_NAMESPACE=__runtime
  $<$<PLATFORM_ID:Windows>:_CRT_SECURE_NO_WARNINGS>
  $<$<PLATFORM_ID:Windows>:_CRT_NONSTDC_NO_WARNINGS>)
target_link_libraries(swiftRemoteMirror PRIVATE
  swiftReflection
  )  # LLVMBinaryFormat)
# TODO(compnerd) use LLVMBinaryFormat and drop the include paths.
target_include_directories(swiftRemoteMirror PRIVATE
  ${LLVM_MAIN_INCLUDE_DIR}
  ${LLVM_INCLUDE_DIR})
