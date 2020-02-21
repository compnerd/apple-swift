add_library(swiftRuntime OBJECT
  AnyHashableSupport.cpp
  Array.cpp
  BackDeployment.cpp
  Casting.cpp
  CompatibilityOverride.cpp
  CygwinPort.cpp
  Demangle.cpp
  Enum.cpp
  ErrorObject.mm
  ErrorObjectCommon.cpp
  ErrorObjectConstants.cpp
  ErrorObjectNative.cpp
  Errors.cpp
  ErrorDefaultImpls.cpp
  Exclusivity.cpp
  ExistentialContainer.cpp
  Heap.cpp
  HeapObject.cpp
  ImageInspectionMachO.cpp
  ImageInspectionELF.cpp
  ImageInspectionCOFF.cpp
  KeyPaths.cpp
  KnownMetadata.cpp
  Leaks.mm
  LLVMSupport.cpp
  Metadata.cpp
  MetadataLookup.cpp
  MutexPThread.cpp
  MutexWin32.cpp
  Numeric.cpp
  ObjCRuntimeGetImageNameFromClass.mm
  Once.cpp
  Portability.cpp
  ProtocolConformance.cpp
  ReflectionMirror.mm
  RefCount.cpp
  RuntimeInvocationsTracking.cpp
  SwiftDtoa.cpp
  SwiftObject.mm
  SwiftValue.mm)
target_compile_definitions(swiftRuntime PRIVATE
  swiftCore_EXPORTS
  $<$<BOOL:${SWIFT_RUNTIME_CRASH_REPORTER_CLIENT}>:SWIFT_HAVE_CRASHREPORTERCLIENT>
  $<$<BOOL:${SWIFT_RUNTIME_CLOBBER_FREED_OBJECTS}>:SWIFT_RUNTIME_CLOBBER_FREED_OBJECTS>
  $<$<BOOL:${SWIFT_RUNTIME_ENABLE_LEAK_CHECKER}>:SWIFT_RUNTIME_ENABLE_LEAK_CHECKER>
  $<$<BOOL:${SWIFT_STDLIB_USE_NONATOMIC_RC}>:SWIFT_STDLIB_USE_NONATOMIC_RC>)
target_link_libraries(swiftRuntime PRIVATE
  demangling)

if(NOT CMAKE_SYSTEM_NAME STREQUAL Darwin)
  if(CMAKE_SYSTEM_NAME STREQUAL Windows)
    add_library(registrar OBJECT
      SwiftRT-COFF.cpp)
  else()
    add_library(registrar OBJECT
      SwiftRT-ELF.cpp)
  endif()
endif()

