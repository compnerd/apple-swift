cmake_minimum_required(VERSION 3.16)
project(swift-stdlib
  LANGUAGES C CXX Swift)

if(NOT CMAKE_C_COMPILER_ID MATCHES Clang OR NOT CMAKE_CXX_COMPILER_ID MATCHES Clang)
  message(FATAL_ERROR "clang is required to build the Swift Runtime")
endif()

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules)

option(ENABLE_EXPERIMENTAL_DIFFERENTIATION_PROGRAMMING_SUPPORT
  "enable experimental differentiation programming support" NO)
option(SWIFT_RUNTIME_ENABLE_LEAK_CHECKER "enable leak checking entrypoints" NO)
option(SWIFT_STDLIB_BUILD_ESSENTIAL_ONLY "build essential subset of standard library" NO)
option(SWIFT_STDLIB_ENABLE_SIL_DEBUGGING "enable SIL debug info generation" NO)
option(SWIFT_STDLIB_ENABLE_STDLIBCORE_EXCLUSIVITY_CHECKING "" NO)

set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)

find_package(ICU COMPONENTS i18n uc REQUIRED)

# Do not enforce checks for LLVM's ABI-breaking build settings.
# The Swift runtime uses some header-only code from LLVM's ADT classes,
# but we do not want to link libSupport into the runtime. These checks rely
# on the presence of symbols in libSupport to identify how the code was
# built and cause link failures for mismatches. Without linking that library,
# we get link failures regardless, so instead, this just disables the checks.
add_compile_options(
  $<$<COMPILE_LANGUAGE:C,CXX>:-DLLVM_DISABLE_ABI_BREAKING_CHECKS_ENFORCING=1>)

add_subdirectory(public)







###### DEAD ######

# FIXME: Include the toolchain directory before the public directory. Otherwise
# the clang resource directory symlink stops installing correctly.
# add_subdirectory(toolchain)
# add_subdirectory(private)
# add_subdirectory(tools)
