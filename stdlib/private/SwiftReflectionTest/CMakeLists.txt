
add_library(SwiftReflectionTest
  SwiftReflectionTest.swift)
target_compile_options(SwiftReflectionTest PRIVATE
  "SHELL:-Xcc -D_GNU_SOURCE")
