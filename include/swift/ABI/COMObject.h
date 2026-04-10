//===--- COMObject.h - ABI constants for COM objects -----------*- C++ -*-===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2026 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//
//
//  Constants and structures used in the layout of COM interop objects.
//
//===----------------------------------------------------------------------===//

#ifndef SWIFT_ABI_COMOBJECT_H
#define SWIFT_ABI_COMOBJECT_H

#include "swift/shims/HeapObject.h"

// COM interop object layout.
//
// When a Swift class bears @COM, its heap allocation is prefixed with a COM
// header so that the same allocation can be addressed as either an IUnknown *
// or a HeapObject * without any wrapper allocation — analogous to ObjC
// toll-free bridging.
//
// Each COM vtable pointer (lpVtbl) in the object is a single pointer,
// identical to the standard COM binary layout.  An IUnknown * for a given
// interface points directly to this entry.
//
// The adjustment offset (signed byte displacement from the entry back to the
// HeapObject *) is stored in the vtable itself at index [-1], i.e. the word
// immediately before the first function pointer:
//
//   vtable layout (static data, emitted once per class per conformance):
//     [-1]  intptr_t   adjustment        // → HeapObject *
//     [ 0]  QueryInterface
//     [ 1]  AddRef
//     [ 2]  Release
//     [ 3]  … interface-specific methods …
//
// Any COM method recovers the Swift object in two loads:
//
//   void **vtable   = *(void ***)thisPtr;                       // load 1
//   intptr_t adj    = ((intptr_t *)vtable)[-1];                 // load 2
//   HeapObject *obj = (HeapObject *)((char *)thisPtr + adj);
//
// Memory layout (64-bit, class with N @COM conformances):
//
//   offset 0                       (N-1)*8        N*8        N*8+8
//   ┌──────────┬── ··· ┬───────────┬─────────────┬──────────┬─── ···
//   │ vtable₀  │       │ vtableₙ₋₂ │ vtableₙ₋₁   │ metadata │ rc  …
//   └──────────┴── ··· ┴───────────┴─────────────┴──────────┴─── ···
//   ▲                               ▲             ▲
//   IInterface *              ISwiftObject *       HeapObject *
//
// Vtable pointers are in declaration order; ISwiftObject is always the final
// entry (index N-1), immediately before the HeapObject header.  Its vtable's
// adjustment is the constant +sizeof(void *), independent of the total
// conformance count.
//
// QueryInterface for the i-th conformance (0-based, ISwiftObject = N-1) returns:
//   (char *)allocationBase + i * sizeof(void *)
//
// For the initial model a class has exactly one conformance (ISwiftObject), so
// the COM header is a single pointer wide.  IRGen computes the actual per-class
// header size from the conformance count.

#ifndef __swift__
/// One COM vtable pointer (lpVtbl) in the per-object COM block.
/// Per the COM ABI the first word of any interface implementation IS its
/// vtable pointer, so a pointer to COMVTablePointer is a valid IUnknown *.
///
/// The adjustment offset (byte displacement from this entry back to the
/// HeapObject *) is stored in the vtable's static data at index [-1];
/// it is not in the per-object entry.
struct COMVTablePointer {
  const void * const *vtable;
};

/// The minimal COM header prepended to a @COM class allocation.
/// Extends to N entries for N @COM conformances; IRGen emits the right width
/// per class.  The final entry is always ISwiftObject.
struct COMHeader {
  // Always the final entry, immediately before the HeapObject.
  COMVTablePointer pISwiftObject;
};

/// Full layout of a heap allocation for a @COM Swift class.
/// Only valid when COM interop is enabled and the class bears @COM.
struct COMHeapObject {
  COMHeader   com;      // ISwiftObject * / IUnknown * points here
  HeapObject  object;   // HeapObject * points here (offset = sizeof COMHeader)
};

static_assert(sizeof(COMVTablePointer) == sizeof(void *),
              "COM vtable pointer entry must be exactly one pointer");
static_assert(sizeof(COMHeader) == sizeof(COMVTablePointer),
              "single-conformance COM header must be one vtable pointer wide");
static_assert(offsetof(COMHeapObject, object) == sizeof(COMHeader),
              "HeapObject must immediately follow COMHeader with no padding");
#endif // !__swift__
