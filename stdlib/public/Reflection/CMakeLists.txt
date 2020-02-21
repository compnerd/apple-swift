add_library(swiftReflection STATIC
  MetadataSource.cpp
  TypeLowering.cpp
  TypeRef.cpp
  TypeRefBuilder.cpp)
target_compile_definitions(reflection PRIVATE
  swiftCore_EXPORTS)
target_link_libraries(swiftReflection PRIVATE
  demangling)
