
add_library(SwiftPrivate-install_name OBJECT
  ${PROJECT_SOURCE_DIR}/linker-support/magic-symbols-for-install-name.c)
target_compile_definitions(SwiftPrivate-install_name PRIVATE
  SwiftPrivate_EXPORTS
  SWIFT_TARGET_LIBRARY_NAME=SwiftPrivate)

add_library(SwiftPrivate
  SwiftPrivate.swift
  IO.swift
  ShardedAtomicCounter.swift)
swift_gyb_target_sources(SwiftPrivate PRIVATE
  AtomicInt.swift.gyb)
target_compile_options(SwiftPrivate PRIVATE
  -parse-stdlib
  "SHELL:-Xfrontend -disable-access-control")
target_link_libraries(SwiftPrivate PRIVATE
  $<TARGET_OBJECTS:SwiftPrivate-install_name>)
