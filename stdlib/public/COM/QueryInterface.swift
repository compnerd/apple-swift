//===--- QueryInterface.swift - COM QueryInterface implementations --------===//
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

public func QueryInterface(_ pUnk: UnsafeMutableRawPointer,
                           _ riid: borrowing IID,
                           _ ppvObject: UnsafeMutablePointer<UnsafeMutableRawPointer?>,
                           implements interfaces: borrowing Span<IID>) -> HRESULT {
    return E_NOINTERFACE
}
