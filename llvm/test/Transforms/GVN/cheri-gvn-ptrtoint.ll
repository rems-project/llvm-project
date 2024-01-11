; RUN: opt -S -gvn -mtriple=cheri-none-freebsd -target-abi purecap < %s | FileCheck %s

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200"

@.str = private unnamed_addr addrspace(200) constant [8 x i8] c"somedata", align 1

; CHECK-LABEL: testFun
; CHECK-NOT: ptrtoint
define i32 @testFun([2 x i8 addrspace(200)*] inreg %A.coerce) local_unnamed_addr {
entry:
  %A.sroa.1 = alloca i8 addrspace(200)*, align 16, addrspace(200)
  %A.coerce.fca.1.extract = extractvalue [2 x i8 addrspace(200)*] %A.coerce, 1
  store i8 addrspace(200)* %A.coerce.fca.1.extract, i8 addrspace(200)* addrspace(200)* %A.sroa.1, align 16
  %A.sroa.1.0.m.sroa_cast1 = bitcast i8 addrspace(200)* addrspace(200)* %A.sroa.1 to i32 addrspace(200)*
  %A.sroa.1.0.A.sroa.1.0.A.sroa.1.16. = load i32, i32 addrspace(200)* %A.sroa.1.0.m.sroa_cast1, align 16
  %A.sroa.1.4.n.sroa_raw_cast2 = bitcast i8 addrspace(200)* addrspace(200)* %A.sroa.1 to i8 addrspace(200)*
  %A.sroa.1.4.n.sroa_raw_idx3 = getelementptr inbounds i8, i8 addrspace(200)* %A.sroa.1.4.n.sroa_raw_cast2, i64 4
  %A.sroa.1.4.n.sroa_cast4 = bitcast i8 addrspace(200)* %A.sroa.1.4.n.sroa_raw_idx3 to i32 addrspace(200)*
  %A.sroa.1.4.A.sroa.1.4.A.sroa.1.20. = load i32, i32 addrspace(200)* %A.sroa.1.4.n.sroa_cast4, align 4
  %cmp = icmp eq i32 %A.sroa.1.0.A.sroa.1.0.A.sroa.1.16., %A.sroa.1.4.A.sroa.1.4.A.sroa.1.20.
  br i1 %cmp, label %return, label %if.then

if.then:
  %call = tail call i32 @g(i8 addrspace(200)* getelementptr inbounds ([8 x i8], [8 x i8] addrspace(200)* @.str, i64 0, i64 0))
  br label %return

return:
  %retval.0 = phi i32 [ -1, %if.then ], [ 0, %entry ]
  ret i32 %retval.0
}

declare i32 @g(i8 addrspace(200)*)
