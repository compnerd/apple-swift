add_library(CommandLineSupport STATIC
  CommandLine.cpp)
target_include_directories(CommandLineSupport PRIVATE
  ${SWIFT_SOURCE_DIR}/include
  ${SWIFT_BUILD_DIR}/include)
