
add_library(OSLogTestHelper SHARED
  OSLogTestHelper.swift
  OSLogMessage.swift
  OSLogIntegerFormatting.swift
  OSLogStringAlignment.swift
  OSLogIntegerTypes.swift
  OSLogStringTypes.swift
  OSLogNSObjectType.swift
  OSLogFloatingPointTypes.swift
  OSLogSwiftProtocols.swift
  OSLogPrivacy.swift
  OSLogFloatFormatting.swift)
target_compile_options(OSLogTestHelper PRIVATE
  -whole-module-optimization)
target_link_libraries(OSLogTestHelper PUBLIC
  swift_Concurrency)
