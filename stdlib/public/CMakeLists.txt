
add_compile_options(
  # Build the runtime with -Wall to catch, e.g., uninitialized variables
  # warnings.
  $<$<COMPILE_LANGUAGE:CXX>:-Wall>

  # We should avoid non-literals in format strings, or appropriately mark
  # functions.
  $<$<COMPILE_LANGUAGE:CXX>:-Werror=format-nonliteral>

  # C++ code in the runtime and standard library should generally avoid
  # introducing static constructors.
  $<$<COMPILE_LANGUAGE:CXX>:-Wglobal-constructors>
  $<$<COMPILE_LANGUAGE:CXX>:-Werror=global-constructors>

  # C++ code in the runtime and standard library should generally avoid
  # introducing static destructors.
  $<$<COMPILE_LANGUAGE:CXX>:-Wexit-time-destructors>
  $<$<COMPILE_LANGUAGE:CXX>:-Werror=exit-time-destructors>

  # The concurrency library uses double-word atomics.  MSVC's `std::atomic` uses
  # a spin lock for this, so to get reasonable behaviour we have to implement it
  # ourselves using `_InterlockedCompareExchange128`.  `clang-cl` requires us to
  # enable the `cx16` target feature to use this intrinsic.
  #
  # This is already enabled on Darwin targets as the minimum x86_64 platform
  # supports this.  On other targets, this is required for preventing an
  # unnecessary dependency on libatomic for the use of the double-wide atomics.
  #
  # TODO(compnerd) limit this to x86_64 targets
  $<$<COMPILE_LANGUAGE:C,CXX>:-mcx16>

  "SHELL:$<$<COMPILE_LANGUAGE:Swift>:-Xfrontend -verify-syntax-tree>"

  "SHELL:$<$<AND:$<COMPILE_LANGUAGE:Swift>,$<BOOL:${SWIFT_STDLIB_SIL_DEBUGGING}>>:-Xfrontend -sil-based-debuginfo>"
)

add_compile_definitions(
  $<$<AND:$<PLATFORM_ID:Windows>,$<COMPILE_LANGUAGE:CXX>>:_ENABLE_ATOMIC_ALIGNMENT_FIX>
  $<$<AND:$<PLATFORM_ID:Windows>,$<COMPILE_LANGUAGE:CXX>>:_ENABLE_EXTENDED_ALIGNED_STORAGE>
)

include_directories(
  $<$<COMPILE_LANGUAGE:CXX>:${PROJECT_SOURCE_DIR}/include>
  # TODO(compnerd) wire up the swift source and build trees; we need the runtime
  # headers from the source tree, and the build tree is used for a singular
  # generated header.
  $<$<COMPILE_LANGUAGE:C,CXX>:${SWIFT_SOURCE_DIR}/include>
  $<$<COMPILE_LANGUAGE:C,CXX>:${SWIFT_BUILD_DIR}/include>
)

add_subdirectory(LLVMSupport)
add_subdirectory(SwiftShims)
add_subdirectory(CommandLineSupport)

add_subdirectory(runtime)
add_subdirectory(stubs)
add_subdirectory(core)
add_subdirectory(SwiftOnoneSupport)

add_library(swiftDemangling STATIC
  ${SWIFT_SOURCE_DIR}/lib/Demangling/Context.cpp
  ${SWIFT_SOURCE_DIR}/lib/Demangling/Demangler.cpp
  ${SWIFT_SOURCE_DIR}/lib/Demangling/ManglingUtils.cpp
  ${SWIFT_SOURCE_DIR}/lib/Demangling/NodePrinter.cpp
  ${SWIFT_SOURCE_DIR}/lib/Demangling/Punycode.cpp
  ${SWIFT_SOURCE_DIR}/lib/Demangling/Remangler.cpp
  ${SWIFT_SOURCE_DIR}/lib/Demangling/NodeDumper.cpp)
if(SWIFT_STDLIB_ENABLE_OBJC_INTEROP)
  target_sources(swiftDemangling PRIVATE
    ${SWIFT_SOURCE_DIR}/lib/Demangling/OldDemangler.cpp
    ${SWIFT_SOURCE_DIR}/lib/Demangling/OldRemangler.cpp)
  target_compile_definitions(swiftDemangling PRIVATE
    SWIFT_SUPPORT_OLD_MANGLING=1)
else()
  target_compile_definitions(swiftDemangling PRIVATE
    SWIFT_SUPPORT_OLD_MANGLING=0)
endif()
target_compile_definitions(swiftDemangling PRIVATE
  swiftCore_EXPORTS
  $<$<BOOL:${SWIFT_STDLIB_HAS_TYPE_PRINTING}>:SWIFT_STDLIB_HAS_TYPE_PRINTING>)
target_compile_definitions(swiftDemangling PUBLIC
  $<$<COMPILE_LANGUAGE:C,CXX>:SWIFT_INLINE_NAMESPACE=__runtime>)
target_link_libraries(swiftDemangling PRIVATE
  swiftLLVMSupport)

add_subdirectory(Reflection)
add_subdirectory(SwiftRemoteMirror)

add_subdirectory(Platform)
if(CMAKE_SYSTEM_NAME STREQUAL Windows)
  add_subdirectory(Windows)
endif()

if(SWIFT_ENABLE_EXPERIMENTAL_CONCURRENCY)
  add_subdirectory(Concurrency)
endif()
if(SWIFT_ENABLE_EXPERIMENTAL_DIFFERENTIABLE_PROGRAMMING)
  add_subdirectory(Differentiation)
endif()
if(SWIFT_ENABLE_EXPERIMENTAL_DISTRIBUTED)
  add_subdirectory(Distributed)
endif()

## set(SWIFT_RUNTIME_CXX_FLAGS)
## set(SWIFT_RUNTIME_LINK_FLAGS)
## set(SWIFT_RUNTIME_SWIFT_COMPILE_FLAGS)
## set(SWIFT_RUNTIME_SWIFT_LINK_FLAGS)
## 
## if(SWIFT_RUNTIME_USE_SANITIZERS)
##   # TODO: Refactor this
##   if("Thread" IN_LIST SWIFT_RUNTIME_USE_SANITIZERS)
##     list(APPEND SWIFT_RUNTIME_CXX_FLAGS "-fsanitize=thread")
##     list(APPEND SWIFT_RUNTIME_LINK_FLAGS "-fsanitize=thread")
##     list(APPEND SWIFT_RUNTIME_SWIFT_COMPILE_FLAGS "-sanitize=thread")
##     list(APPEND SWIFT_RUNTIME_SWIFT_LINK_FLAGS "-fsanitize=thread")
##   endif()
## endif()
## 
## if(SWIFT_BUILD_STDLIB)
##   add_subdirectory(core)
## 
##   if(SWIFT_ENABLE_EXPERIMENTAL_STRING_PROCESSING)
##     add_subdirectory(MatchingEngine)
##     add_subdirectory(StringProcessing)
##   endif()
## endif()
