// RUN: %empty-directory(%t)
// RUN: %target-swift-frontend -enable-experimental-com-interop -module-name serialization -emit-module-path %t/serialization.swiftmodule %s
// RUN: %llvm-bcanalyzer -dump %t/serialization.swiftmodule | %FileCheck -check-prefix CHECK -implicit-check-not UnknownCode %s

@COM(IID: "00000000-0000-0000-C000-000000000046")
@_marker public protocol IUnknown: AnyObject { }
// CHECK-DAG: <COM_DECL_ATTR abbrevid=289 op0=0 op1=1 op2=0/> blob data = '00000000-0000-0000-C000-000000000046'

@COM(CLSID: "00000000-0000-0000-0000-000000000001")
public class CClass1 { }
// CHECK-DAG: <COM_DECL_ATTR abbrevid=289 op0=0 op1=0 op2=2/> blob data = '00000000-0000-0000-0000-000000000001'

@COM(CLSID: "00000000-0000-0000-0000-000000000002", ThreadingModel: .free)
public class CClass2 { }
// CHECK-DAG: <COM_DECL_ATTR abbrevid=289 op0=0 op1=0 op2=3/> blob data = '00000000-0000-0000-0000-000000000002'

@COM
public class CClass3 { }
// CHECK-DAG: <COM_DECL_ATTR abbrevid=289 op0=0 op1=0 op2=2/> blob data = ''
