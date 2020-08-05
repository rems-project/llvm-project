; RUN: llc -march=arm64 -relocation-model=pic -mattr=+morello,+c64 -target-abi purecap %s -o - | FileCheck %s

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none-unknown-elf"

%class.a = type { i8 }

@_ZTIi = external addrspace(200) constant i8 addrspace(200)*
define void @_Z1bv() local_unnamed_addr addrspace(200) personality i8 addrspace(200)* bitcast (i32 (...) addrspace(200)* @__gxx_personality_v0 to i8 addrspace(200)*) {
entry:
  %c = alloca %class.a, align 1, addrspace(200)
  %0 = getelementptr inbounds %class.a, %class.a addrspace(200)* %c, i64 0, i32 0
  call void @llvm.lifetime.start.p200i8(i64 1, i8 addrspace(200)* nonnull %0)
  invoke void @_ZN1aC1Ev(%class.a addrspace(200)* nonnull %c)
          to label %invoke.cont unwind label %lpad

invoke.cont:
  call void @llvm.lifetime.end.p200i8(i64 1, i8 addrspace(200)* nonnull %0)
  br label %try.cont

lpad:
  %1 = landingpad { i8 addrspace(200)*, i32 }
          cleanup
          catch i8 addrspace(200)* bitcast (i8 addrspace(200)* addrspace(200)* @_ZTIi to i8 addrspace(200)*)
  %2 = extractvalue { i8 addrspace(200)*, i32 } %1, 1
  call void @llvm.lifetime.end.p200i8(i64 1, i8 addrspace(200)* nonnull %0)
  %3 = call i32 @llvm.eh.typeid.for(i8* addrspacecast (i8 addrspace(200)* bitcast (i8 addrspace(200)* addrspace(200)* @_ZTIi to i8 addrspace(200)*) to i8*))
  %matches = icmp eq i32 %2, %3
  br i1 %matches, label %catch, label %eh.resume

catch:
  %4 = extractvalue { i8 addrspace(200)*, i32 } %1, 0
  %5 = call i8 addrspace(200)* @__cxa_begin_catch(i8 addrspace(200)* %4)
  call void @__cxa_end_catch()
  br label %try.cont

try.cont:
  ret void

eh.resume:
  resume { i8 addrspace(200)*, i32 } %1
}

; CHECK: .L_ZTIi.DW.stub:
; CHECK-NEXT: .capinit _ZTIi
; CHECK-NEXT: .xword  0
; CHECK-NEXT: .xword  0
; CHECK: DW.ref.__gxx_personality_v0:
; CHECK-NEXT: .capinit __gxx_personality_v0
; CHECK-NEXT: .xword 0
; CHECK-NEXT: .xword 0

declare void @llvm.lifetime.start.p200i8(i64 immarg, i8 addrspace(200)* nocapture) addrspace(200)
declare void @_ZN1aC1Ev(%class.a addrspace(200)*) unnamed_addr addrspace(200)
declare i32 @__gxx_personality_v0(...) addrspace(200)
declare void @llvm.lifetime.end.p200i8(i64 immarg, i8 addrspace(200)* nocapture) addrspace(200)
declare i32 @llvm.eh.typeid.for(i8*) addrspace(200)
declare i8 addrspace(200)* @__cxa_begin_catch(i8 addrspace(200)*) local_unnamed_addr addrspace(200)
declare void @__cxa_end_catch() local_unnamed_addr addrspace(200)
