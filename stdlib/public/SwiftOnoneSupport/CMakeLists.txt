
add_library(SwiftOnoneSupport-install_name OBJECT
  ${PROJECT_SOURCE_DIR}/linker-support/magic-symbols-for-install-name.c)

add_library(swiftSwiftOnoneSupport
  SwiftOnoneSupport.swift)
set_target_properties(swiftSwiftOnoneSupport PROPERTIES
  Swift_MODULE_NAME SwiftOnoneSupport)
target_compile_options(swiftSwiftOnoneSupport PRIVATE
  -parse-stdlib
  "SHELL:-Xllvm -sil-inline-generics=false"
  "SHELL:-Xfrontend -validate-tbd-against-ir=none"
  "SHELL:-Xfrontend -check-onone-completeness"
  "SHELL:-Xfrontend -disable-access-control")
target_link_libraries(swiftSwiftOnoneSupport PRIVATE
  $<TARGET_OBJECTS:SwiftOnoneSupport-install_name>)

if(CMAKE_SYSTEM_NAME STREQUAL Windows)
  # When building in Debug mode, the standard library provides the symbols that
  # we need and as such SwiftOnoneSupport does not need to provide any exported
  # interfaces.  This results in the import library beinging elided.  However,
  # we explicitly link against the SwiftOnoneSupport library when building
  # programs in Debug mode, and need the import library to be generated even if
  # nothing is exported.  Because we will still generate the DLL, create an
  # empty import library.
  file(GENERATE OUTPUT swiftSwiftOnoneSupport.def
    CONTENT [=[
LIBRARY SwiftOnoneSupport
EXPORTS
]=] TARGET swiftSwiftOnoneSupport)
  target_sources(swiftSwiftOnoneSupport PRIVATE
    swiftSwiftOnoneSupport.def)
  set_source_files_properties(swiftSwiftOnoneSupport.def PROPERTIES
    HEADER_FILE_ONLY TRUE)
endif()
