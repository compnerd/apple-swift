
# Honour CMAKE_CXX_STANDARD in try_compile()
if(POLICY CMP0067)
  cmake_policy(SET CMP0067 NEW)
endif()

# Don't clobber existing variable values when evaluating `option()` declarations.
if(POLICY CMP0077)
  cmake_policy(SET CMP0077 NEW)
endif()

# Select MSVC runtime based on CMAKE_MSVC_RUNTIME_LIBRARY (CMake 3.15+)
if(POLICY CMP0091)
  cmake_policy(SET CMP0091 NEW)
endif()

cmake_minimum_required(VERSION 3.16.0)
project(SwiftCore
  LANGUAGES C CXX Swift)
enable_testing()

if(NOT CMAKE_C_COMPILER_ID MATCHES Clang OR NOT CMAKE_CXX_COMPILER_ID MATCHES Clang)
  message(FATAL_ERROR "clang is required to build the Swift Runtime")
endif()
if(CMAKE_SYSTEM_NAME STREQUAL Darwin AND NOT BUILD_SHARED_LIBS)
  message(FATAL_ERROR "cannot build Swift standard library statically for Darwin")
endif()

set(CMAKE_DISABLE_IN_SOURCE_BUILD YES)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)

set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)

set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL" CACHE
  STRING "MSVC Runtime Library")

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_Swift_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/swift)

option(SWIFT_STDLIB_ENABLE_ASSERTIONS "Build swiftCore with assertions" FALSE)
option(SWIFT_STDLIB_BUILD_STATIC_PRINT "Build swiftCore with compile-time evaluated vprintf()" FALSE)
option(SWIFT_STDLIB_ENABLE_REFLECTION "Build swiftCore with support for runtime reflection and mirrors" TRUE)
option(SWIFT_STDLIB_EXCLUSIVITY_CHECKING "Build swiftCore with exclusivity checking enabled" FALSE)
option(SWIFT_STDLIB_SINGLE_THREADED_RUNTIME "Build swiftCore assuming it will be used single threaded" FALSE)
option(SWIFT_STDLIB_SIL_DEBUGGING "Build swiftCore with -sil-based-debuginfo to enable debugging and profiling SIL" FALSE)

option(SWIFT_RUNTIME_ENABLE_LEAK_CHECKER "Enable non-thread-safe leak detection entrypoints" FALSE)
option(SWIFT_RUNTIME_ENABLE_FUNCTION_COUNTERS "Enable runtime function counters" FALSE)
option(SWIFT_RUNTIME_ENABLE_CRASH_REPORTER_CLIENT "Enable CrashReporter integration" FALSE)
option(SWIFT_RUNTIME_ENABLE_ENVIRONMENT "" TRUE)
if(SWIFT_STDLIB_ENABLE_ASSERTIONS)
  set(SWIFT_RUNTIME_CLOBBER_FREED_OBJECTS_default TRUE)
else()
  set(SWIFT_RUNTIME_CLOBBER_FREED_OBJECTS_default FALSE)
endif()
option(SWIFT_RUNTIME_CLOBBER_FREED_OBJECTS "Overwrite memory for deallocated Swift objects" "${SWIFT_RUNTIME_CLOBBER_FREED_OBJECTS_default}")

option(SWIFT_ENABLE_EXPERIMENTAL_CONCURRENCY "Build _Concurrency module"  FALSE)
option(SWIFT_ENABLE_EXPERIMENTAL_DIFFERENTIABLE_PROGRAMMING "Build _Differentiation module" FALSE)
option(SWIFT_ENABLE_EXPERIMENTAL_DISTRIBUTED "Build _Distributed module" FALSE)
option(SWIFT_ENABLE_EXPERIMENTAL_STRING_PROCESSING "Build _StringProcessing module" FALSE)

if(SWIFT_STDLIB_SINGLE_THREADED_RUNTIME)
  set(SWIFT_CONCURRENCY_GLOBAL_EXECUTOR_default "singlethreaded")
else()
  set(SWIFT_CONCURRENCY_GLOBAL_EXECUTOR_default "dispatch")
endif()
set(SWIFT_CONCURRENCY_GLOBAL_EXECUTOR ${SWIFT_CONCURRENCY_GLOBAL_EXECUTOR_default} CACHE STRING "Build _Concurrency to use the specified global executor")
set_property(CACHE SWIFT_CONCURRENCY_GLOBAL_EXECUTOR PROPERTY STRINGS dispatch;singlethreaded;hooked)

if(SWIFT_ENABLE_EXPERIMENTAL_CONCURRENCY AND
   SWIFT_CONCURRENCY_GLOBAL_EXECUTOR STREQUAL dispatch AND
   NOT CMAKE_SYSTEM_NAME STREQUAL Darwin)
  # TODO(compnerd) support a non-config mode search
  find_package(dispatch CONFIG REQUIRED)
endif()

message(STATUS "Building Swift Standard Library and Overlays for ${CMAKE_SYSTEM_NAME}")
message(STATUS "  Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "  Assertions: ${SWIFT_STDLIB_ENABLE_ASSERTIONS}")
message(STATUS "")
message(STATUS "Building Swift Runtime With:")
message(STATUS "  Leak Detection Checker Entrypoints: ${SWIFT_RUNTIME_ENABLE_LEAK_CHECKER}")
message(STATUS "")
message(STATUS "Differential Programming Support: ${SWIFT_ENABLE_EXPERIMENTAL_DIFFERENTIABLE_PROGRAMMING}")
message(STATUS "Concurrency Support: ${SWIFT_ENABLE_EXPERIMENTAL_CONCURRENCY}")
message(STATUS "Distributed Support: ${SWIFT_ENABLE_EXPERIMENTAL_DISTRIBUTED}")
message(STATUS "String Processing Support: ${SWIFT_ENABLE_EXPERIMENTAL_STRING_PROCESSING}")
message(STATUS "")

# Do not enforce checks for LLVM's ABI-breaking build settings.  The Swift
# runtime uses some header-only code from LLVM's ADT classes, but we do not want
# to link libSupport into the runtime. These checks rely on the presence of
# symbols in libSupport to identify how the code was built and cause link
# failures for mismatches. Without linking that library, we get link failures
# regardless, so instead, this just disables the checks.
add_compile_definitions($<$<OR:$<COMPILE_LANGUAGE:C>,$<COMPILE_LANGUAGE:CXX>>:LLVM_DISABLE_ABI_BREAKING_CHECKS_ENFORCING>)

add_compile_options(
  "SHELL:$<$<COMPILE_LANGUAGE:Swift>:-Xfrontend -define-availability -Xfrontend \"SwiftStdlib 9999:macOS 9999, iOS 9999, watchOS 9999, tvOS 9999\">"
  "SHELL:$<$<COMPILE_LANGUAGE:Swift>:-Xfrontend -define-availability -Xfrontend \"SwiftStdlib 5.0:macOS 10.14.4, iOS 12.2, watchOS 5.2, tvOS 12.2\">"
  "SHELL:$<$<COMPILE_LANGUAGE:Swift>:-Xfrontend -define-availability -Xfrontend \"SwiftStdlib 5.1:macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0\">"
  "SHELL:$<$<COMPILE_LANGUAGE:Swift>:-Xfrontend -define-availability -Xfrontend \"SwiftStdlib 5.2:macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4\">"
  "SHELL:$<$<COMPILE_LANGUAGE:Swift>:-Xfrontend -define-availability -Xfrontend \"SwiftStdlib 5.3:macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0\">"
  "SHELL:$<$<COMPILE_LANGUAGE:Swift>:-Xfrontend -define-availability -Xfrontend \"SwiftStdlib 5.4:macOS 11.3, iOS 14.5, watchOS 7.4, tvOS 14.5\">"
  "SHELL:$<$<COMPILE_LANGUAGE:Swift>:-Xfrontend -define-availability -Xfrontend \"SwiftStdlib 5.5:macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0\">"
  "SHELL:$<$<COMPILE_LANGUAGE:Swift>:-Xfrontend -define-availability -Xfrontend \"SwiftStdlib 5.6:macOS 9999, iOS 9999, watchOS 9999, tvOS 9999\">"
)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules)
include(SwiftGYBSupport)

add_subdirectory(public)
add_subdirectory(private)

## if("${SWIFT_HOST_VARIANT_SDK}" MATCHES "(OSX|IOS*|TVOS*|WATCHOS*)")
##   # All Darwin platforms have ABI stability.
##   set(SWIFT_STDLIB_STABLE_ABI_default TRUE)
## elseif("${SWIFT_HOST_VARIANT_SDK}" STREQUAL "LINUX")
##   # TODO(mracek): This should get turned off, as this is not an ABI stable platform.
##   set(SWIFT_STDLIB_STABLE_ABI_default TRUE)
## elseif("${SWIFT_HOST_VARIANT_SDK}" STREQUAL "FREEBSD")
##   # TODO(mracek): This should get turned off, as this is not an ABI stable platform.
##   set(SWIFT_STDLIB_STABLE_ABI_default TRUE)
## elseif("${SWIFT_HOST_VARIANT_SDK}" STREQUAL "OPENBSD")
##   # TODO(mracek): This should get turned off, as this is not an ABI stable platform.
##   set(SWIFT_STDLIB_STABLE_ABI_default TRUE)
## elseif("${SWIFT_HOST_VARIANT_SDK}" STREQUAL "CYGWIN")
##   # TODO(mracek): This should get turned off, as this is not an ABI stable platform.
##   set(SWIFT_STDLIB_STABLE_ABI_default TRUE)
## elseif("${SWIFT_HOST_VARIANT_SDK}" STREQUAL "WINDOWS")
##   # TODO(mracek): This should get turned off, as this is not an ABI stable platform.
##   set(SWIFT_STDLIB_STABLE_ABI_default TRUE)
## elseif("${SWIFT_HOST_VARIANT_SDK}" STREQUAL "HAIKU")
##   # TODO(mracek): This should get turned off, as this is not an ABI stable platform.
##   set(SWIFT_STDLIB_STABLE_ABI_default TRUE)
## elseif("${SWIFT_HOST_VARIANT_SDK}" STREQUAL "ANDROID")
##   # TODO(mracek): This should get turned off, as this is not an ABI stable platform.
##   set(SWIFT_STDLIB_STABLE_ABI_default TRUE)
## else()
##   # Any new platform should have non-stable ABI to start with.
##   set(SWIFT_STDLIB_STABLE_ABI_default FALSE)
## endif()
## 
## if(SWIFT_BUILD_SDK_OVERLAY OR SWIFT_INCLUDE_TESTS)
##   set(SWIFT_BUILD_TEST_SUPPORT_MODULES_default TRUE)
## else()
##   set(SWIFT_BUILD_TEST_SUPPORT_MODULES_default FALSE)
## endif()
## 
## if("${SWIFT_HOST_VARIANT_SDK}" MATCHES "(OSX|IOS*|TVOS*|WATCHOS*)")
##   set(SWIFT_STDLIB_ENABLE_PRESPECIALIZATION_default TRUE)
## elseif("${SWIFT_HOST_VARIANT_SDK}" STREQUAL "LINUX")
##   set(SWIFT_STDLIB_ENABLE_PRESPECIALIZATION_default TRUE)
## else()
##   set(SWIFT_STDLIB_ENABLE_PRESPECIALIZATION_default FALSE)
## endif()
## 
## if("${SWIFT_HOST_VARIANT_SDK}" MATCHES "CYGWIN")
##   set(SWIFT_STDLIB_SUPPORTS_BACKTRACE_REPORTING_default FALSE)
## elseif("${SWIFT_HOST_VARIANT_SDK}" MATCHES "HAIKU")
##   set(SWIFT_STDLIB_SUPPORTS_BACKTRACE_REPORTING_default FALSE)
## elseif("${SWIFT_HOST_VARIANT_SDK}" MATCHES "WASI")
##   set(SWIFT_STDLIB_SUPPORTS_BACKTRACE_REPORTING_default FALSE)
## else()
##   set(SWIFT_STDLIB_SUPPORTS_BACKTRACE_REPORTING_default TRUE)
## endif()
## 
## if("${SWIFT_HOST_VARIANT_SDK}" MATCHES "CYGWIN")
##   set(SWIFT_STDLIB_HAS_LOCALE_default FALSE)
## elseif("${SWIFT_HOST_VARIANT_SDK}" MATCHES "HAIKU")
##   set(SWIFT_STDLIB_HAS_LOCALE_default FALSE)
## else()
##   set(SWIFT_STDLIB_HAS_LOCALE_default TRUE)
## endif()
## 
## if("${SWIFT_HOST_VARIANT_SDK}" IN_LIST SWIFT_DARWIN_PLATFORMS)
##   set(SWIFT_STDLIB_HAS_ASL_default TRUE)
## else()
##   set(SWIFT_STDLIB_HAS_ASL_default FALSE)
## endif()
## 
## #
## # User-configurable options for the standard library.
## #
## 
## # New options should be added to stdlib/cmake/modules/StdlibOptions.cmake,
## # so that they are considered in configurations using StandaloneOverlay.cmake
## 
## # NOTE: Some of these variables are also initialized in StandaloneOverlay.cmake
## # so that interfaces are emitted when overlays are separately built.
## 
## # TODO: migrate this section to StdlibOptions.cmake to reduce duplication
## 
## option(SWIFT_STDLIB_STABLE_ABI
##        "Should stdlib be built with stable ABI (library evolution, resilience)."
##        "${SWIFT_STDLIB_STABLE_ABI_default}")
## 
## option(SWIFT_ENABLE_MODULE_INTERFACES
##        "Generate .swiftinterface files alongside .swiftmodule files"
##        "${SWIFT_STDLIB_STABLE_ABI}")
## 
## option(SWIFT_STDLIB_SUPPORTS_BACKTRACE_REPORTING
##        "Build stdlib assuming the runtime environment provides the backtrace(3) API."
##        "${SWIFT_STDLIB_SUPPORTS_BACKTRACE_REPORTING_default}")
## 
## option(SWIFT_STDLIB_HAS_ASL
##        "Build stdlib assuming we can use the asl_log API."
##        "${SWIFT_STDLIB_HAS_ASL_default}")
## 
## option(SWIFT_STDLIB_HAS_LOCALE
##        "Build stdlib assuming the platform has locale support."
##        "${SWIFT_STDLIB_HAS_LOCALE_default}")
## 
## option(SWIFT_BUILD_TEST_SUPPORT_MODULES
##        "Whether to build StdlibUnittest and other test support modules. Defaults to On when SWIFT_BUILD_SDK_OVERLAY is On, or when SWIFT_INCLUDE_TESTS is On."
##        "${SWIFT_BUILD_TEST_SUPPORT_MODULES_default}")
## 
## option(SWIFT_STDLIB_ENABLE_PRESPECIALIZATION
##        "Should stdlib be built with generic metadata prespecialization enabled. Defaults to On on Darwin and on Linux."
##        "${SWIFT_STDLIB_ENABLE_PRESPECIALIZATION_default}")
## 
## include(StdlibOptions)
## 
## #
## # End of user-configurable options.
## #
## 
## include(AddSwiftStdlib)
## 
## # Create convenience targets for the Swift standard library.
## 
## if(SWIFT_BUILD_RUNTIME_WITH_HOST_COMPILER)
##   if(NOT "${CMAKE_C_COMPILER_ID}" MATCHES "Clang")
##     message(FATAL_ERROR "Building the swift runtime is not supported with ${CMAKE_C_COMPILER_ID}. Use the just-built clang instead.")
##   else()
##     message(WARNING "Building the swift runtime using the host compiler, and not the just-built clang.")
##   endif()
## else()
##   # If we use Clang-cl or MSVC, CMake provides default compiler and linker flags that are incompatible
##   # with the frontend of Clang or Clang++.
##   if(SWIFT_COMPILER_IS_MSVC_LIKE)
##     set(CMAKE_CXX_COMPILER "${SWIFT_NATIVE_CLANG_TOOLS_PATH}/clang-cl")
##     set(CMAKE_C_COMPILER "${SWIFT_NATIVE_CLANG_TOOLS_PATH}/clang-cl")
##   else()
##     set(CMAKE_CXX_COMPILER "${SWIFT_NATIVE_CLANG_TOOLS_PATH}/clang++")
##     set(CMAKE_C_COMPILER "${SWIFT_NATIVE_CLANG_TOOLS_PATH}/clang")
##   endif()
## 
##   # The sanitizers require using the same version of the compiler for
##   # everything and there are various places where we link runtime code with
##   # code built by the host compiler. Disable sanitizers for the runtime for
##   # now.
##   add_compile_options(-fno-sanitize=all)
## endif()
## 
## if("${SWIFT_CONCURRENCY_GLOBAL_EXECUTOR}" STREQUAL "singlethreaded"
##    AND NOT SWIFT_STDLIB_SINGLE_THREADED_RUNTIME)
##   message(SEND_ERROR "Cannot enable the single-threaded global executor without enabling SWIFT_STDLIB_SINGLE_THREADED_RUNTIME")
## endif()
## 
## # FIXME: Include the toolchain directory before the public directory. Otherwise
## # the clang resource directory symlink stops installing correctly.
## add_subdirectory(toolchain)
## add_subdirectory(public)
## if(SWIFT_STDLIB_BUILD_PRIVATE)
##   add_subdirectory(private)
## endif()
## add_subdirectory(tools)
