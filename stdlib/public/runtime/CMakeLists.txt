
add_library(swiftRuntime OBJECT
  AccessibleFunction.cpp
  AnyHashableSupport.cpp
  Array.cpp
  AutoDiffSupport.cpp
  Bincompat.cpp
  Casting.cpp
  CygwinPort.cpp
  Demangle.cpp
  DynamicCast.cpp
  Enum.cpp
  EnvironmentVariables.cpp
  ErrorDefaultImpls.cpp
  ErrorObject.mm
  ErrorObjectCommon.cpp
  ErrorObjectNative.cpp
  Errors.cpp
  Exclusivity.cpp
  ExistentialContainer.cpp
  Float16Support.cpp
  FoundationSupport.cpp
  FunctionReplacement.cpp
  Heap.cpp
  HeapObject.cpp
  ImageInspectionCOFF.cpp
  ImageInspectionCommon.cpp
  ImageInspectionELF.cpp
  ImageInspectionMachO.cpp
  ImageInspectionStatic.cpp
  ImageInspectionWasm.cpp
  KeyPaths.cpp
  KnownMetadata.cpp
  Metadata.cpp
  MetadataLookup.cpp
  MutexPThread.cpp
  MutexWin32.cpp
  Numeric.cpp
  ObjCRuntimeGetImageNameFromClass.mm
  Once.cpp
  Portability.cpp
  ProtocolConformance.cpp
  RefCount.cpp
  ReflectionMirror.cpp
  ReflectionMirrorObjC.mm
  RuntimeInvocationsTracking.cpp
  SwiftDtoa.cpp
  SwiftObject.mm
  SwiftTLSContext.cpp
  SwiftValue.mm)
target_sources(swiftRuntime PRIVATE
  ${PROJECT_SOURCE_DIR}/public/CompatibilityOverride/CompatibilityOverride.cpp
  $<$<BOOL:${SWIFT_RUNTIME_ENABLE_LEAK_CHECKER}>:Leaks.mm>)
target_compile_definitions(swiftRuntime PRIVATE
  swiftCore_EXPORTS
  SWIFT_TARGET_LIBRARY_NAME=swiftRuntime
  $<$<BOOL:${SWIFT_RUNTIME_ENABLE_CRASH_REPORTER_CLIENT}>:SWIFT_HAVE_CRASHREPORTERCLIENT>
  $<$<BOOL:${SWIFT_RUNTIME_ENABLE_LEAK_CHECKER}>:SWIFT_RUNTIME_ENABLE_LEAK_CHECKER>
  $<$<BOOL:${SWIFT_RUNTIME_CLOBBER_FREED_OBJECTS}>:SWIFT_RUNTIME_CLOBBER_FREED_OBJECTS>
  $<$<BOOL:${SWIFT_RUNTIME_ENABLE_ENVIRONMENT}>:SWIFT_STDLIB_HAS_ENVIRON>)
target_compile_options(swiftRuntime PRIVATE
  "SHELL:$<$<PLATFORM_ID:OpenBSD>:-x c++>")
target_link_libraries(swiftRuntime PUBLIC
  swiftLLVMSupport)

if(NOT CMAKE_SYSTEM_NAME STREQUAL Darwin)
  if(CMAKE_SYSTEM_NAME STREQUAL Windows)
    add_library(registrar STATIC
      SwiftRT-COFF.cpp)
  else()
    add_library(registrar STATIC
      SwiftRT-ELF.cpp)
  endif()
  add_custom_command(TARGET registrar POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/lib/swift
    COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_OBJECTS:registrar> ${CMAKE_BINARY_DIR}/lib/swift$<$<BOOL:${BUILD_SHARED_LIBS}>:_static>/swiftrt.o$<$<PLATFORM_ID:Windows>:bj>)
endif()
