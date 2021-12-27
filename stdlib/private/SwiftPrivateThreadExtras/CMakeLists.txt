
add_library(SwiftPrivateThreadExtras-install_name OBJECT
  ${PROJECT_SOURCE_DIR}/linker-support/magic-symbols-for-install-name.c)
target_compile_definitions(SwiftPrivateThreadExtras-install_name PRIVATE
  SwiftPrivateThreadExtras_EXPORTS
  SWIFT_TARGET_LIBRARY_NAME=SwiftPrivateThreadExtras)

add_library(SwiftPrivateThreadExtras
  SwiftPrivateThreadExtras.swift
  ThreadBarriers.swift)
target_link_libraries(SwiftPrivateThreadExtras PRIVATE
  $<TARGET_OBJECTS:SwiftPrivateThreadExtras-install_name>)
