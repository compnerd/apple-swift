//===--- IUnknown.swift - COM IUnknown protocol ---------------------------===//
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

/// The root interface for all COM objects.
///
/// Every COM interface derives (transitively) from `IUnknown`, which provides
/// `QueryInterface`, `AddRef`, and `Release`.  These three methods are
/// compiler-managed and sealed: the user does not implement them.
///
/// `IUnknown` conformance is implied by `@COM` on a class and need not be
/// written explicitly.
@COM(IID: "00000000-0000-0000-C000-000000000046")
public protocol IUnknown: AnyObject { }
