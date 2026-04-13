//===--- CLSID.swift - COM Class ID (CLSID) type ----------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2025 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

@frozen
public struct CLSID {
  private let guid: GUID

  public init(_ guid: GUID) {
    self.guid = guid
  }
}

extension CLSID: Equatable {
  public static func == (_ lhs: borrowing CLSID, _ rhs: borrowing CLSID) -> Bool {
    lhs.guid == rhs.guid
  }
}

extension CLSID: Sendable {
}

extension CLSID: Hashable {
}

extension CLSID: CustomStringConvertible {
  public var description: String {
    guid.description
  }
}
