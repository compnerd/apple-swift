#===--- CMakeLists.txt - Build the core standard library -----------------===#
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2014 - 2019 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See https://swift.org/LICENSE.txt for license information
# See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
#
#===----------------------------------------------------------------------===#

add_library(swiftCore-install_name OBJECT
  ${PROJECT_SOURCE_DIR}/linker-support/magic-symbols-for-install-name.c)
target_compile_definitions(swiftCore-install_name PRIVATE
  swiftCore_EXPORTS
  SWIFT_TARGET_LIBRARY_NAME=swiftCore)

add_library(swiftCore
  Algorithm.swift
  AnyHashable.swift
  Array.swift
  ArrayBody.swift
  ArrayBuffer.swift
  ArrayBufferProtocol.swift
  ArrayCast.swift
  ArrayShared.swift
  ArraySlice.swift
  ArrayType.swift
  ASCII.swift
  Assert.swift
  AssertCommon.swift
  BidirectionalCollection.swift
  Bitset.swift
  Bool.swift
  BridgeObjectiveC.swift
  BridgeStorage.swift
  BridgingBuffer.swift
  Builtin.swift
  BuiltinMath.swift
  Character.swift
  CharacterProperties.swift
  ClosedRange.swift
  CocoaArray.swift
  Codable.swift
  Collection.swift
  CollectionAlgorithms.swift
  Comparable.swift
  CompilerProtocols.swift
  ContiguousArray.swift
  ContiguousArrayBuffer.swift
  ContiguouslyStored.swift
  CString.swift
  CTypes.swift
  DebuggerSupport.swift
  Dictionary.swift
  DictionaryBridging.swift
  DictionaryBuilder.swift
  DictionaryCasting.swift
  DictionaryStorage.swift
  DictionaryVariant.swift
  DropWhile.swift
  Dump.swift
  EmptyCollection.swift
  Equatable.swift
  ErrorType.swift
  ExistentialCollection.swift
  Filter.swift
  FixedArray.swift
  FlatMap.swift
  Flatten.swift
  FloatingPoint.swift
  Hashable.swift
  Hasher.swift
  Hashing.swift
  HashTable.swift
  Identifiable.swift
  Indices.swift
  InputStream.swift
  IntegerParsing.swift
  Integers.swift
  Join.swift
  KeyPath.swift
  KeyValuePairs.swift
  LazyCollection.swift
  LazySequence.swift
  LegacyABI.swift
  LifetimeManager.swift
  ManagedBuffer.swift
  Map.swift
  MemoryLayout.swift
  Mirrors.swift
  Misc.swift
  MutableCollection.swift
  NativeDictionary.swift
  NativeSet.swift
  NewtypeWrapper.swift
  NFC.swift
  NFD.swift
  ObjectIdentifier.swift
  Optional.swift
  OptionSet.swift
  OutputStream.swift
  Pointer.swift
  Policy.swift
  PrefixWhile.swift
  Prespecialize.swift
  Print.swift
  PtrAuth.swift
  Random.swift
  RandomAccessCollection.swift
  Range.swift
  RangeReplaceableCollection.swift
  ReflectionMirror.swift
  Repeat.swift
  REPL.swift
  Result.swift
  Reverse.swift
  Runtime.swift
  RuntimeFunctionCounters.swift
  Sendable.swift
  Sequence.swift
  SequenceAlgorithms.swift
  Set.swift
  SetAlgebra.swift
  SetAnyHashableExtensions.swift
  SetBridging.swift
  SetBuilder.swift
  SetCasting.swift
  SetStorage.swift
  SetVariant.swift
  ShadowProtocols.swift
  Shims.swift
  SipHash.swift
  Slice.swift
  SmallString.swift
  Sort.swift
  StaticPrint.swift
  StaticString.swift
  Stride.swift
  String.swift
  StringHashable.swift
  StringBreadcrumbs.swift
  StringBridge.swift
  StringCharacterView.swift
  StringComparable.swift
  StringComparison.swift
  StringCreate.swift
  StringGraphemeBreaking.swift
  StringGuts.swift
  StringGutsRangeReplaceable.swift
  StringGutsSlice.swift
  StringIndex.swift
  StringIndexConversions.swift
  StringInterpolation.swift
  StringLegacy.swift
  StringNormalization.swift
  StringObject.swift
  StringProtocol.swift
  StringRangeReplaceableCollection.swift
  StringStorage.swift
  StringStorageBridge.swift
  StringSwitch.swift
  StringTesting.swift
  StringUnicodeScalarView.swift
  StringUTF16View.swift
  StringUTF8Validation.swift
  StringUTF8View.swift
  Substring.swift
  SwiftNativeNSArray.swift
  TemporaryAllocation.swift
  ThreadLocalStorage.swift
  UIntBuffer.swift
  UnavailableStringAPIs.swift
  Unicode.swift
  UnicodeData.swift
  UnicodeEncoding.swift
  UnicodeGraphemeBreakProperty.swift
  UnicodeHelpers.swift
  UnicodeParser.swift
  UnicodeScalar.swift
  UnicodeScalarProperties.swift
  Unmanaged.swift
  UnmanagedOpaqueString.swift
  UnmanagedString.swift
  UnsafePointer.swift
  UnsafeRawPointer.swift
  UTF8.swift
  UTF16.swift
  UTF32.swift
  UTFEncoding.swift
  ValidUTF8Buffer.swift
  WriteBackMutableSlice.swift
  MigrationSupport.swift)
swift_gyb_target_sources(swiftCore PRIVATE
  AtomicInt.swift.gyb
  FloatingPointParsing.swift.gyb
  FloatingPointTypes.swift.gyb
  IntegerTypes.swift.gyb
  UnsafeBufferPointer.swift.gyb
  UnsafeRawBufferPointer.swift.gyb)
if(NOT SWIFT_CHECK_ESSENTIAL_STDLIB)
  target_sources(swiftCore PRIVATE
    Availability.swift
    CollectionDifference.swift
    CollectionOfOne.swift
    CommandLine.swift
    Diffing.swift
    FloatingPointRandom.swift
    Mirror.swift
    PlaygroundDisplay.swift
    SIMDVector.swift
    SliceBuffer.swift
    UnfoldSequence.swift
    VarArgs.swift
    Zip.swift)
  swift_gyb_target_sources(swiftCore PRIVATE
    SIMDConcreteOperations.swift.gyb
    SIMDVectorTypes.swift.gyb
    Tuple.swift.gyb)
endif()
set_target_properties(swiftCore PROPERTIES
  Swift_MODULE_NAME Swift)
target_compile_options(swiftCore PRIVATE
  -parse-stdlib
  # NOTE(compnerd) this is require for the proper resolution of symbols, so pass
  # this in even debug builds.
  -whole-module-optimization
  "SHELL:-Xfrontend -group-info-path -Xfrontend ${CMAKE_CURRENT_SOURCE_DIR}/GroupInfo.json"
  "SHELL:-Xcc -DswiftCore_EXPORTS"
  "SHELL:$<$<NOT:$<CONFIG:MinSizeRel>>:-Xllvm -sil-inline-generics>"
  "SHELL:$<$<NOT:$<CONFIG:MinSizeRel>>:-Xllvm -sil-partial-specialization>"
  "SHELL:-Xfrontend -enable-experimental-concise-pound-file"
  $<$<BOOL:${SWIFT_STDLIB_ENABLE_STDLIBCORE_EXCLUSIVITY_CHECKING}>:-enforce-exclusivity=checked>)
target_link_libraries(swiftCore PRIVATE
  swiftCommandLineSupport
  swiftDemangling
  swiftLLVMSupport
  $<TARGET_OBJECTS:swiftRuntime>
  $<TARGET_OBJECTS:swiftStubs>
  $<TARGET_OBJECTS:swiftCore-install_name>)

## set(GROUP_INFO_JSON_FILE ${CMAKE_CURRENT_SOURCE_DIR}/GroupInfo.json)
## set(swift_core_link_flags "${SWIFT_RUNTIME_SWIFT_LINK_FLAGS}")
## set(swift_core_framework_depends)
## set(swift_core_private_link_libraries)
## set(swift_stdlib_compile_flags "${SWIFT_RUNTIME_SWIFT_COMPILE_FLAGS}")
## 
## if(SWIFT_PRIMARY_VARIANT_SDK STREQUAL CYGWIN)
##   # TODO(compnerd) cache this variable to permit re-configuration
##   execute_process(COMMAND "cygpath" "-u" "$ENV{SYSTEMROOT}" OUTPUT_VARIABLE ENV_SYSTEMROOT)
##   list(APPEND swift_core_private_link_libraries "${ENV_SYSTEMROOT}/system32/psapi.dll")
## elseif(SWIFT_PRIMARY_VARIANT_SDK STREQUAL FREEBSD)
##   find_library(EXECINFO_LIBRARY execinfo)
##   list(APPEND swift_core_private_link_libraries ${EXECINFO_LIBRARY})
## elseif(SWIFT_PRIMARY_VARIANT_SDK STREQUAL LINUX)
##   if(SWIFT_BUILD_STATIC_STDLIB)
##     list(APPEND swift_core_private_link_libraries)
##   endif()
## elseif(SWIFT_PRIMARY_VARIANT_SDK STREQUAL WINDOWS)
##   list(APPEND swift_core_private_link_libraries shell32;DbgHelp)
## endif()
## 
## option(SWIFT_CHECK_ESSENTIAL_STDLIB
##     "Check core standard library layering by linking its essential subset"
##     FALSE)
## 
## set(compile_flags_for_final_build)
## if(SWIFT_ENABLE_ARRAY_COW_CHECKS)
##   list(APPEND compile_flags_for_final_build "-DCOW_CHECKS_ENABLED")
## endif()
## 
## if(SWIFT_CHECK_ESSENTIAL_STDLIB)
##   add_swift_target_library(swift_stdlib_essential ${SWIFT_STDLIB_LIBRARY_BUILD_TYPES} IS_STDLIB IS_STDLIB_CORE
##       INSTALL_IN_COMPONENT never_install
##       ${SWIFTLIB_ESSENTIAL}
##       GYB_SOURCES
##         ${SWIFTLIB_ESSENTIAL_GYB_SOURCES})
##   target_link_libraries(swift_stdlib_essential ${RUNTIME_DEPENDENCY})
## endif()
## 
## set(swift_core_incorporate_object_libraries)
## list(APPEND swift_core_incorporate_object_libraries swiftRuntime)
## list(APPEND swift_core_incorporate_object_libraries swiftLLVMSupport)
## list(APPEND swift_core_incorporate_object_libraries swiftDemangling)
## list(APPEND swift_core_incorporate_object_libraries swiftStdlibStubs)
## if(SWIFT_STDLIB_HAS_COMMANDLINE)
##   list(APPEND swift_core_incorporate_object_libraries swiftCommandLineSupport)
## endif()
