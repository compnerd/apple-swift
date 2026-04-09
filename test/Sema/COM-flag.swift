// RUN: %target-typecheck-verify-swift

@COM(IID: "00000000-0000-0000-C000-000000000046")
protocol IUnknown: AnyObject { }
// expected-error@-2 {{'@COM' requires '-enable-experimental-com-interop'}}

@COM
class CClass3 { }
// expected-error@-2 {{'@COM' requires '-enable-experimental-com-interop'}}

@COM(CLSID: "00000000-0000-0000-0000-000000000000")
class CClass1 { }
// expected-error@-2 {{'@COM' requires '-enable-experimental-com-interop'}}

@COM(CLSID: "00000000-0000-0000-0000-000000000000", ThreadingModel: .free)
class CClass2 { }
// expected-error@-2 {{'@COM' requires '-enable-experimental-com-interop'}}

