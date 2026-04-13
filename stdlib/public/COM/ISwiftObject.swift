//===--- ISwiftObject.swift - COM ISwiftObject protocol -------------------===//
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

/// A COM interface for recovering the underlying Swift heap object from a COM
/// interface pointer.
///
/// `ISwiftObject` is automatically provided by `@COM` on a class.  Explicitly
/// conforming a `@COM` class to `ISwiftObject` is a compile-time error.
///
/// The `object` getter recovers the Swift heap object via the `vtable[-1]`
/// adjustment offset.  It is only accessed after `QueryInterface` for
/// `ISwiftObject` has confirmed the object is Swift-originated.
@COM(IID: "8E369447-5188-5ADA-B9EC-8FCB732D226B")
public protocol ISwiftObject: IUnknown {
  var object: Unmanaged<Self> { get }
}

extension ISwiftObject {
  public var object: Unmanaged<Self> {
    get {
      fatalError()
    }
  }
}
