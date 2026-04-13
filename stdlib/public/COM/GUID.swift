//===--- GUID.swift - COM GUID type ---------------------------------------===//
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

/// A globally unique identifier, compatible with the COM `GUID` binary layout.
///
/// The layout matches the Microsoft `GUID` structure:
/// ```c
/// typedef struct {
///     unsigned long  Data1;
///     unsigned short Data2;
///     unsigned short Data3;
///     unsigned char  Data4[8];
/// } GUID;
/// ```

@frozen
public struct GUID {
  public var data1: UInt32
  public var data2: UInt16
  public var data3: UInt16
  public var data4: InlineArray<8, UInt8>

  @inlinable
  public init(data1: UInt32, data2: UInt16, data3: UInt16,
              data4: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)) {
    self.data1 = data1
    self.data2 = data2
    self.data3 = data3
    self.data4 = unsafeBitCast(data4, to: InlineArray<8, UInt8>.self)
  }
}

extension GUID: Equatable {
  public static func == (_ lhs: borrowing GUID, _ rhs: borrowing GUID) -> Bool {
    unsafeBitCast(lhs, to: UInt128.self) == unsafeBitCast(rhs, to: UInt128.self)
  }
}

extension GUID: Sendable {
}

extension GUID: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(data1)
    hasher.combine(data2)
    hasher.combine(data3)
    for index in 0 ..< data4.count {
      hasher.combine(data4[index])
    }
  }
}

extension String {
  fileprivate init<T: FixedWidthInteger>(hex value: T) {
    let representation = String(value, radix: 16, uppercase: false)
    let width = MemoryLayout<T>.size * 2
    self = String(repeating: "0", count: Swift.max(0, width - representation.count))
         + representation
  }
}

extension GUID: CustomStringConvertible {
  @inline(never)
  public var description: String {
    String(hex: data1) + "-" +
    String(hex: data2) + "-" +
    String(hex: data3) + "-" +
    String(hex: data4[0]) + String(hex: data4[1]) + "-" +
    String(hex: data4[2]) + String(hex: data4[3]) +
    String(hex: data4[4]) + String(hex: data4[5]) +
    String(hex: data4[6]) + String(hex: data4[7])
  }
}
