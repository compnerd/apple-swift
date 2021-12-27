
add_library(swiftReflection STATIC
  MetadataSource.cpp
  TypeLowering.cpp
  TypeRef.cpp
  TypeRefBuilder.cpp)
set_source_files_properties(TypeRef.cpp PROPERTIES
  COMPILE_OPTIONS -Wno-error=global-constructors)
set_source_files_properties(TypeLowering.cpp PROPERTIES
  COMPILE_OPTIONS -Wno-error=exit-time-destructors)
target_compile_definitions(swiftReflection PRIVATE
  swiftCore_EXPORTS
  SWIFT_INLINE_NAMESPACE=__runtime
  $<$<BOOL:${SWIFT_STDLIB_ENABLE_REFLECTION}>:SWIFT_ENABLE_REFLECTION>)
target_link_libraries(swiftReflection PRIVATE
  swiftLLVMSupport
  swiftDemangling)
