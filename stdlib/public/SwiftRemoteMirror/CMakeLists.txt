add_library(swiftRemoteMirror SHARED
  SwiftRemoteMirror.cpp)
target_link_libraries(swiftRemoteMirror PRIVATE
  swiftReflection)
