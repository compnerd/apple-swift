// RUN: %target-swift-frontend -parse -verify -enable-experimental-com-interop %s

@COM(IID: "00000000-0000-0000-C000-000000000046")
@_marker protocol IUnknown: AnyObject { }

@COM
class C0 { }

@COM(CLSID: "00000000-0000-0000-0000-000000000001")
class C1 { }

@COM(CLSID: "00000000-0000-0000-0000-000000000002", ThreadingModel: .free)
class C2 { }

@COM(CLSID: "00000000-0000-0000-0000-000000000003", ThreadingModel: COMThreadingModel.apartment)
class C3 { }

@COM(CLSID: "00000000-0000-0000-0000-000000000004", ThreadingModel: COM::COMThreadingModel.neutral)
class C4 { }

@COM(CLSID: "00000000-0000-0000-0000-000000000005", ThreadingModel: .single)
class C5 { }

@COM(CLSID: "00000000-0000-0000-0000-000000000006", ThreadingModel: .both)
class C6 { }

@COM(CLSID: "00000000-0000-0000-0000-000000000007", ThreadingModel: .sta)
class C7 { }

@COM(CLSID: "00000000-0000-0000-0000-000000000008", ThreadingModel: .mta)
class C8 { }


@COM()
protocol B1 { }
// expected-error@-2 {{expected 'IID:', 'CLSID:', or 'ThreadingModel:' in '@COM' attribute}}

@COM(IID "")
protocol B2 { }
// expected-error@-2 {{expected ':' after label 'IID'}}

@COM(IID: 42)
protocol B3 { }
// expected-error@-2 {{expected string literal in 'COM' attribute}}

@COM(Label: "bar")
protocol B4 { }
// expected-error@-2 {{unknown label 'Label' in '@COM' attribute; expected 'IID:', 'CLSID:', or 'ThreadingModel:'}}

@COM(CLSID: 42)
class B5 { }
// expected-error@-2 {{expected string literal in 'COM' attribute}}

@COM(CLSID: "00000000-0000-0000-0000-000000000009", ThreadingModel: apartment)
class B6 { }
// expected-error@-2 {{expected threading model (.single, .apartment, .free, .both, or .neutral)}}

@COM(CLSID: "10000000-0000-0000-0000-000000000010", ThreadingModel: .unknown)
class B7 { }
// expected-error@-2 {{unknown threading model 'unknown'; expected 'single', 'apartment', 'free', 'both', or 'neutral'}}
