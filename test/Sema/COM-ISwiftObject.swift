// RUN: %empty-directory(%t)
// RUN: %target-swift-frontend -emit-module-path %t/COM.swiftmodule -module-name COM -enable-experimental-com-interop %S/Inputs/COM.swift
// RUN: %target-typecheck-verify-swift -enable-experimental-com-interop -I %t

import COM

// expected-note@+1 {{'@COM' automatically provides 'ISwiftObject' conformance}}
@COM
class CClass1: ISwiftObject {
}
// expected-error@-2 {{'ISwiftObject' conformance is compiler-managed and cannot be declared explicitly}}

// expected-note@+1 {{'@COM' automatically provides 'ISwiftObject' conformance}}
@COM(CLSID: "00000000-0000-0000-0000-000000000000")
class CClass2: ISwiftObject {
}
// expected-error@-2 {{'ISwiftObject' conformance is compiler-managed and cannot be declared explicitly}}

@COM
class CClass3 {
}

@COM
class CClass4: IUnknown {
}

class CClass5: ISwiftObject {
}
