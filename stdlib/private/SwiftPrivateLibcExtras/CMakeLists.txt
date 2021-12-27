
add_library(SwiftPrivateLibcExtras-install_name OBJECT
  ${PROJECT_SOURCE_DIR}/linker-support/magic-symbols-for-install-name.c)
target_compile_definitions(SwiftPrivateLibcExtras-install_name PRIVATE
  SwiftPrivateLibcExtras_EXPORTS
  SWIFT_TARGET_LIBRARY_NAME=SwiftPrivateLibcExtras)

add_library(SwiftPrivateLibcExtrasCXX OBJECT
  Subprocess.c)
# TODO(compnerd) wire in Swift build
target_include_directories(SwiftPrivateLibcExtrasCXX PRIVATE
  ${SWIFT_SOURCE_DIR}/include
  ${SWIFT_BUILD_DIR}/include)

add_library(SwiftPrivateLibcExtras
  SwiftPrivateLibcExtras.swift
  Subprocess.swift)
target_compile_definitions(SwiftPrivateLibcExtras PRIVATE
  $<$<BOOL:${SWIFT_STDLIB_HAS_ENVIRON}>:SWIFT_STDLIB_HAS_ENVIRON>
  $<$<BOOL:${SWIFT_STDLIB_HAS_COMMANDLINE}>:SWIFT_STDLIB_HAS_COMMANDLINE>)
target_link_libraries(SwiftPrivateLibcExtras PRIVATE
  $<$<BOOL:${SWIFT_STDLIB_HAS_COMMANDLINE}>:CommandLineSupport>
  $<TARGET_OBJECTS:SwiftPrivateLibcExtrasCXX>
  $<TARGET_OBJECTS:SwiftPrivateLibcExtras-install_name>)
target_link_libraries(SwiftPrivateLibcExtras PUBLIC
  swiftCore
  SwiftPrivate)
