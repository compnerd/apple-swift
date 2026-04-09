// RUN: %target-typecheck-verify-swift -enable-experimental-com-interop

@COM(IID: "00000000-0000-0000-C000-000000000046")
@_marker protocol IUnknown: AnyObject { }

@COM(IID: "00000000-0000-0000-0000-000000000000")
protocol IInterface1: IUnknown { }

@COM(IID: "00000000-0000-0000-0000-000000000000")
protocol IInterface2: IInterface1 { }

@COM(IID: "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA")
protocol IUpperCase: IUnknown { }

@COM(IID: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa")
protocol ILowerCase: IUnknown { }

@COM
class CClass1 { }

@COM
class CClass2: IUnknown { }

@COM(CLSID: "00000000-0000-0000-0000-000000000000")
class CClass3 { }

@COM(CLSID: "00000000-0000-0000-0000-000000000000")
class CClass4: IUnknown { }

@COM(CLSID: "00000000-0000-0000-0000-000000000000", ThreadingModel: .apartment)
class CClass5: IUnknown { }

@COM(CLSID: "00000000-0000-0000-0000-000000000000")
class CClass6: IInterface1, IInterface2 { }

@COM(CLSID: "00000000-0000-0000-0000-000000000000")
final class CClass7 { }

@COM(CLSID: "00000000-0000-0000-0000-000000000000")
final class CClass8: IUnknown { }

@COM(CLSID: "00000000-0000-0000-0000-000000000000")
final class CClass9: IUnknown, IInterface1 { }


@COM
protocol IInterface3: IUnknown { }
// expected-error@-2 {{'@COM' on a protocol requires 'IID:' argument}}

@COM(IID: "guid")
protocol IInterface4: IUnknown { }
// expected-error@-2 {{'guid' is not a valid GUID}}

@COM(IID: "00000000-0000-0000-0000-000000000")
protocol IInterface5: IUnknown { }
// expected-error@-2 {{'00000000-0000-0000-0000-000000000' is not a valid GUID}}

@COM(IID: "{00000000-0000-0000-0000-0000000000}")
protocol IInterface6: IUnknown { }
// expected-error@-2 {{'{00000000-0000-0000-0000-0000000000}' is not a valid GUID}}

@COM(CLSID: "00000000-0000-0000-0000-0000000000")
protocol IInterface7: IUnknown { }
// expected-error@-2 {{'@COM' on a protocol requires 'IID:' argument}}

@COM(IID: "{00000000-0000-0000-0000-0000000000}")
class CClass10 { }
// expected-error@-2 {{'@COM' on a class must not have 'IID:'; use 'CLSID:' instead}}

@COM(CLSID: "guid")
class CClass11 { }
// expected-error@-2 {{'guid' is not a valid GUID}}

@COM(CLSID: "")
class CClass12 { }
// expected-error@-2 {{'' is not a valid GUID}}
