
add_library(UnicodeUnittest
  StdlibUnicodeUnittest.swift
  Collation.swift
  UnicodeScalarProperties.swift)
target_link_libraries(UnicodeUnittest PUBLIC
  StdlibUnittest)
