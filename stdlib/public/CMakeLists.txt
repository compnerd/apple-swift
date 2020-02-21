add_compile_options(
  $<$<AND:$<PLATFORM_ID:Windows>,$<COMPILE_LANGUAGE:C,CXX>>:-D_CRT_SECURE_NO_WARNINGS>
  $<$<AND:$<PLATFORM_ID:Cygwin>,$<COMPILE_LANGUAGE:C,CXX>>:-mcmodel=large>
  "SHELL:$<$<COMPILE_LANGUAGE:Swift>:-Xfrontend -verify-syntax-tree>")
include_directories(
  S:/BinaryCache/Release/Windows-x86_64/toolchain/tools/swift/include
  ../../include
  S:/BinaryCache/Release/Windows-x86_64/toolchain/include
  ../../../llvm/include)

add_library(demangling OBJECT
  ../../lib/Demangling/OldDemangler.cpp
  ../../lib/Demangling/Demangler.cpp
  ../../lib/Demangling/NodeDumper.cpp
  ../../lib/Demangling/NodePrinter.cpp
  ../../lib/Demangling/Context.cpp
  ../../lib/Demangling/ManglingUtils.cpp
  ../../lib/Demangling/Punycode.cpp)

add_library(darwin-linker-support OBJECT
  ../linker-support/magic-symbols-for-install-name.c)

add_subdirectory(SwiftShims)
add_subdirectory(runtime)
add_subdirectory(stubs)
add_subdirectory(core)
add_subdirectory(SwiftOnoneSupport)
if(SWIFT_ENABLE_EXPERIMENTAL_DIFFERENTIABLE_PROGRAMMING)
  add_subdirectory(Differentiation)
endif()
if(SWIFT_BUILD_REMOTE_MIRROR)
  add_subdirectory(Reflection)
  add_subdirectory(SwiftRemoteMirror)
endif()
if(SWIFT_BUILD_SDK_OVERLAY)
  add_subdirectory(Platform)
  if(CMAKE_SYSTEM_NAME STREQUAL Darwin)
    add_subdirectory(Darwin)
  endif()
  if(CMAKE_SYSTEM_NAME STREQUAL Windows)
    add_subdirectory(Darwin)
  endif()
endif()
