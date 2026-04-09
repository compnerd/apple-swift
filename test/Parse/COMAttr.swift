// RUN: %empty-directory(%t)
// RUN: %target-swift-frontend -emit-module-path %t/COM.swiftmodule -module-name COM -enable-experimental-com-interop %S/Inputs/COM.swift
// RUN: %target-swift-frontend -enable-experimental-com-interop -I %t -dump-ast %s 2>&1 | %FileCheck %s

import COM

@COM(IID: "00000000-0000-0000-0000-000000000000")
protocol IInterface: IUnknown {
}

@COM
class CClass1 {
}

// CHECK:  (class_decl {{.*}} "CClass1" interface_type="CClass1.Type" access=internal non_resilient
// CHECK:    (com_attr {{.*}} ThreadingModel=apartment)

@COM(CLSID: "00000000-0000-0000-0000-000000000000")
class CClass2: IUnknown {
}

// CHECK:  (class_decl {{.*}} "CClass2" interface_type="CClass2.Type" access=internal non_resilient inherits="IUnknown"
// CHECK:    (com_attr {{.*}} CLSID="00000000-0000-0000-0000-000000000000" ThreadingModel=apartment)

@COM(CLSID: "00000000-0000-0000-0000-000000000000", ThreadingModel: .free)
class CClass3: IUnknown {
}

// CHECK:  (class_decl {{.*}} "CClass3" interface_type="CClass3.Type" access=internal non_resilient inherits="IUnknown"
// CHECK:    (com_attr {{.*}} CLSID="00000000-0000-0000-0000-000000000000" ThreadingModel=free)

@COM(CLSID: "00000000-0000-0000-0000-000000000000", ThreadingModel: .apartment)
class CClass4: IUnknown {
}

// CHECK:  (class_decl {{.*}} "CClass4" interface_type="CClass4.Type" access=internal non_resilient inherits="IUnknown"
// CHECK:    (com_attr {{.*}} CLSID="00000000-0000-0000-0000-000000000000" ThreadingModel=apartment)

@COM(CLSID: "00000000-0000-0000-0000-000000000000", ThreadingModel: .single)
class CClass5: IUnknown {
}

// CHECK:  (class_decl {{.*}} "CClass5" interface_type="CClass5.Type" access=internal non_resilient inherits="IUnknown"
// CHECK:    (com_attr {{.*}} CLSID="00000000-0000-0000-0000-000000000000" ThreadingModel=single)

@COM(CLSID: "00000000-0000-0000-0000-000000000000", ThreadingModel: .both)
class CClass6: IUnknown {
}

// CHECK:  (class_decl {{.*}} "CClass6" interface_type="CClass6.Type" access=internal non_resilient inherits="IUnknown"
// CHECK:    (com_attr {{.*}} CLSID="00000000-0000-0000-0000-000000000000" ThreadingModel=both)

@COM(CLSID: "00000000-0000-0000-0000-000000000000", ThreadingModel: .neutral)
class CClass7: IUnknown {
}

// CHECK:  (class_decl {{.*}} "CClass7" interface_type="CClass7.Type" access=internal non_resilient inherits="IUnknown"
// CHECK:    (com_attr {{.*}} CLSID="00000000-0000-0000-0000-000000000000" ThreadingModel=neutral)

