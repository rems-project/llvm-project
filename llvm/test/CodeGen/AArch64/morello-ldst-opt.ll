; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+c64,+morello -aarch64-enable-atomic-cfg-tidy=0 -target-abi=purecap -disable-lsr -verify-machineinstrs -mcpu=rainier -o - %s | FileCheck --check-prefix=CHECK --check-prefix=NOSTRICTALIGN %s
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+strict-align,+c64,+morello -aarch64-enable-atomic-cfg-tidy=0 -target-abi=purecap -disable-lsr -verify-machineinstrs -mcpu=rainier -o - %s | FileCheck --check-prefix=CHECK --check-prefix=STRICTALIGN %s

; This file contains tests for the AArch64 load/store optimizer, based on ldst-opt.ll.
target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"

%padding = type { i8*, i8*, i8*, i8* }
%s.byte = type { i8, i8 }
%s.halfword = type { i16, i16 }
%s.word = type { i32, i32 }
%s.doubleword = type { i64, i32 }
%s.quadword = type { fp128, i32 }
%s.float = type { float, i32 }
%s.double = type { double, i32 }
%s.capability = type { i8 addrspace(200)*, i32 }
%struct.byte = type { %padding, %s.byte }
%struct.halfword = type { %padding, %s.halfword }
%struct.word = type { %padding, %s.word }
%struct.doubleword = type { %padding, %s.doubleword }
%struct.quadword = type { %padding, %s.quadword }
%struct.float = type { %padding, %s.float }
%struct.double = type { %padding, %s.double }
%struct.capability = type { %padding, %s.capability }

; Check the following transform:
;
; (ldr|str) X, [c0, #32]
;  ...
; add x0, x0, #32
;  ->
; (ldr|str) X, [c0, #32]!
;
; with X being either w1, x1, s0, d0 or q0.

declare void @bar_byte(%s.byte addrspace(200)*, i8) addrspace(200)

define void @load-pre-indexed-byte(%struct.byte addrspace(200)* %ptr) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-byte
; CHECK: ldrb w{{[0-9]+}}, [c{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.byte, %struct.byte addrspace(200)* %ptr, i64 0, i32 1, i32 0
  %add = load i8, i8 addrspace(200)* %a, align 4
  br label %bar
bar:
  %c = getelementptr inbounds %struct.byte, %struct.byte addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_byte(%s.byte addrspace(200)* %c, i8 %add)
  ret void
}

define void @store-pre-indexed-byte(%struct.byte addrspace(200)* %ptr, i8 %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-byte
; CHECK: strb w{{[0-9]+}}, [c{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.byte, %struct.byte addrspace(200)* %ptr, i64 0, i32 1, i32 0
  store i8 %val, i8 addrspace(200)* %a, align 4
  br label %bar
bar:
  %c = getelementptr inbounds %struct.byte, %struct.byte addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_byte(%s.byte addrspace(200)* %c, i8 %val)
  ret void
}

declare void @bar_halfword(%s.halfword addrspace(200)*, i16) addrspace(200)

define void @load-pre-indexed-halfword(%struct.halfword addrspace(200)* %ptr) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-halfword
; CHECK: ldrh w{{[0-9]+}}, [c{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.halfword, %struct.halfword addrspace(200)* %ptr, i64 0, i32 1, i32 0
  %add = load i16, i16 addrspace(200)* %a, align 4
  br label %bar
bar:
  %c = getelementptr inbounds %struct.halfword, %struct.halfword addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_halfword(%s.halfword addrspace(200)* %c, i16 %add)
  ret void
}

define void @store-pre-indexed-halfword(%struct.halfword addrspace(200)* %ptr, i16 %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-halfword
; CHECK: strh w{{[0-9]+}}, [c{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.halfword, %struct.halfword addrspace(200)* %ptr, i64 0, i32 1, i32 0
  store i16 %val, i16 addrspace(200)* %a, align 4
  br label %bar
bar:
  %c = getelementptr inbounds %struct.halfword, %struct.halfword addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_halfword(%s.halfword addrspace(200)* %c, i16 %val)
  ret void
}

declare void @bar_word(%s.word addrspace(200)*, i32) addrspace(200)

define void @load-pre-indexed-word(%struct.word addrspace(200)* %ptr) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-word
; CHECK: ldr w{{[0-9]+}}, [c{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.word, %struct.word addrspace(200)* %ptr, i64 0, i32 1, i32 0
  %add = load i32, i32 addrspace(200)* %a, align 4
  br label %bar
bar:
  %c = getelementptr inbounds %struct.word, %struct.word addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_word(%s.word addrspace(200)* %c, i32 %add)
  ret void
}

define void @store-pre-indexed-word(%struct.word addrspace(200)* %ptr, i32 %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-word
; CHECK: str w{{[0-9]+}}, [c{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.word, %struct.word addrspace(200)* %ptr, i64 0, i32 1, i32 0
  store i32 %val, i32 addrspace(200)* %a, align 4
  br label %bar
bar:
  %c = getelementptr inbounds %struct.word, %struct.word addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_word(%s.word addrspace(200)* %c, i32 %val)
  ret void
}

declare void @bar_doubleword(%s.doubleword addrspace(200)*, i64)

define void @load-pre-indexed-doubleword(%struct.doubleword addrspace(200)* %ptr) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-doubleword
; CHECK: ldr x{{[0-9]+}}, [c{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.doubleword, %struct.doubleword addrspace(200)* %ptr, i64 0, i32 1, i32 0
  %add = load i64, i64 addrspace(200)* %a, align 8
  br label %bar
bar:
  %c = getelementptr inbounds %struct.doubleword, %struct.doubleword addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_doubleword(%s.doubleword addrspace(200)* %c, i64 %add)
  ret void
}

define void @store-pre-indexed-doubleword(%struct.doubleword addrspace(200)* %ptr, i64 %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-doubleword
; CHECK: str x{{[0-9]+}}, [c{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.doubleword, %struct.doubleword addrspace(200)* %ptr, i64 0, i32 1, i32 0
  store i64 %val, i64 addrspace(200)* %a, align 8
  br label %bar
bar:
  %c = getelementptr inbounds %struct.doubleword, %struct.doubleword addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_doubleword(%s.doubleword addrspace(200)* %c, i64 %val)
  ret void
}

declare void @bar_quadword(%s.quadword addrspace(200)*, fp128) addrspace(200)

define void @load-pre-indexed-quadword(%struct.quadword addrspace(200)* %ptr) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-quadword
; CHECK: ldr q{{[0-9]+}}, [c{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.quadword, %struct.quadword addrspace(200)* %ptr, i64 0, i32 1, i32 0
  %add = load fp128, fp128 addrspace(200)* %a, align 16
  br label %bar
bar:
  %c = getelementptr inbounds %struct.quadword, %struct.quadword addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_quadword(%s.quadword addrspace(200)* %c, fp128 %add)
  ret void
}

define void @store-pre-indexed-quadword(%struct.quadword addrspace(200)* %ptr, fp128 %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-quadword
; CHECK: str q{{[0-9]+}}, [c{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.quadword, %struct.quadword addrspace(200)* %ptr, i64 0, i32 1, i32 0
  store fp128 %val, fp128 addrspace(200)* %a, align 16
  br label %bar
bar:
  %c = getelementptr inbounds %struct.quadword, %struct.quadword addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_quadword(%s.quadword addrspace(200)* %c, fp128 %val)
  ret void
}

declare void @bar_float(%s.float addrspace(200)*, float) addrspace(200)

define void @load-pre-indexed-float(%struct.float addrspace(200)* %ptr) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-float
; CHECK: ldr s{{[0-9]+}}, [c{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.float, %struct.float addrspace(200)* %ptr, i64 0, i32 1, i32 0
  %add = load float, float addrspace(200)* %a, align 4
  br label %bar
bar:
  %c = getelementptr inbounds %struct.float, %struct.float addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_float(%s.float addrspace(200)* %c, float %add)
  ret void
}

define void @store-pre-indexed-float(%struct.float addrspace(200)* %ptr, float %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-float
; CHECK: str s{{[0-9]+}}, [c{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.float, %struct.float addrspace(200)* %ptr, i64 0, i32 1, i32 0
  store float %val, float addrspace(200)* %a, align 4
  br label %bar
bar:
  %c = getelementptr inbounds %struct.float, %struct.float addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_float(%s.float addrspace(200)* %c, float %val)
  ret void
}

declare void @bar_double(%s.double addrspace(200)*, double) addrspace(200)

define void @load-pre-indexed-double(%struct.double addrspace(200)* %ptr) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-double
; CHECK: ldr d{{[0-9]+}}, [c{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.double, %struct.double addrspace(200)* %ptr, i64 0, i32 1, i32 0
  %add = load double, double addrspace(200)* %a, align 8
  br label %bar
bar:
  %c = getelementptr inbounds %struct.double, %struct.double addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_double(%s.double addrspace(200)* %c, double %add)
  ret void
}

define void @store-pre-indexed-double(%struct.double addrspace(200)* %ptr, double %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-double
; CHECK: str d{{[0-9]+}}, [c{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.double, %struct.double addrspace(200)* %ptr, i64 0, i32 1, i32 0
  store double %val, double addrspace(200)* %a, align 8
  br label %bar
bar:
  %c = getelementptr inbounds %struct.double, %struct.double addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_double(%s.double addrspace(200)* %c, double %val)
  ret void
}

declare void @bar_capability(%s.capability addrspace(200)*, i8 addrspace(200)*) addrspace(200)

define void @load-pre-indexed-capability(%struct.capability addrspace(200)* %ptr) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-capability
; CHECK: ldr c{{[0-9]+}}, [c{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.capability, %struct.capability addrspace(200)* %ptr, i64 0, i32 1, i32 0
  %add = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, align 16
  br label %bar
bar:
  %c = getelementptr inbounds %struct.capability, %struct.capability addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_capability(%s.capability addrspace(200)* %c, i8 addrspace(200)* %add)
  ret void
}

define void @store-pre-indexed-capability(%struct.capability addrspace(200)* %ptr, i8 addrspace(200)* %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-capability
; CHECK: str c{{[0-9]+}}, [c{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.capability, %struct.capability addrspace(200)* %ptr, i64 0, i32 1, i32 0
  store i8 addrspace(200)* %val, i8 addrspace(200)* addrspace(200)* %a, align 16
  br label %bar
bar:
  %c = getelementptr inbounds %struct.capability, %struct.capability addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_capability(%s.capability addrspace(200)* %c, i8 addrspace(200)* %val)
  ret void
}

; Check the following transform:
;
; (ldp|stp) w1, w2 [c0, #32]
;  ...
; add x0, x0, #32
;  ->
; (ldp|stp) w1, w2, [c0, #32]!
;

define void @load-pair-pre-indexed-word(%struct.word addrspace(200)* %ptr) addrspace(200) nounwind {
; CHECK-LABEL: load-pair-pre-indexed-word
; CHECK: ldp w{{[0-9]+}}, w{{[0-9]+}}, [c0, #32]!
; CHECK-NOT: add x0, x0, #32
entry:
  %a = getelementptr inbounds %struct.word, %struct.word addrspace(200)* %ptr, i64 0, i32 1, i32 0
  %a1 = load i32, i32 addrspace(200)* %a, align 4
  %b = getelementptr inbounds %struct.word, %struct.word addrspace(200)* %ptr, i64 0, i32 1, i32 1
  %b1 = load i32, i32 addrspace(200)* %b, align 4
  %add = add i32 %a1, %b1
  br label %bar
bar:
  %c = getelementptr inbounds %struct.word, %struct.word addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_word(%s.word addrspace(200)* %c, i32 %add)
  ret void
}

define void @store-pair-pre-indexed-word(%struct.word addrspace(200)* %ptr, i32 %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pair-pre-indexed-word
; CHECK: stp w{{[0-9]+}}, w{{[0-9]+}}, [c0, #32]!
; CHECK-NOT: add x0, x0, #32
entry:
  %a = getelementptr inbounds %struct.word, %struct.word addrspace(200)* %ptr, i64 0, i32 1, i32 0
  store i32 %val, i32 addrspace(200)* %a, align 4
  %b = getelementptr inbounds %struct.word, %struct.word addrspace(200)* %ptr, i64 0, i32 1, i32 1
  store i32 %val, i32 addrspace(200)* %b, align 4
  br label %bar
bar:
  %c = getelementptr inbounds %struct.word, %struct.word addrspace(200)* %ptr, i64 0, i32 1
  tail call void @bar_word(%s.word addrspace(200)* %c, i32 %val)
  ret void
}

; Check the following transform:
;
; add x8, x8, #16
;  ...
; ldr X, [c8]
;  ->
; ldr X, [c8, #16]
;
; with X being either w0, x0, s0, d0 or q0.

%pre.struct.i32 = type { i32, i32, i32, i32, i32}
%pre.struct.i64 = type { i32, i64, i64, i64, i64}
%pre.struct.i128 = type { i32, <2 x i64>, <2 x i64>, <2 x i64>}
%pre.struct.float = type { i32, float, float, float}
%pre.struct.double = type { i32, double, double, double}
%pre.struct.capability = type { i32, i8 addrspace(200)*, i8 addrspace(200)*, i8 addrspace(200)*}

define i32 @load-pre-indexed-word2(%pre.struct.i32 addrspace(200)* addrspace(200)* %this, i1 %cond,
                                   %pre.struct.i32 addrspace(200)* %load2) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-word2
; CHECK: ldur w{{[0-9]+}}, [c{{[0-9]+}}, #4]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.i32 addrspace(200)*, %pre.struct.i32 addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.i32, %pre.struct.i32 addrspace(200)* %load1, i64 0, i32 1
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.i32, %pre.struct.i32 addrspace(200)* %load2, i64 0, i32 2
  br label %return
return:
  %retptr = phi i32 addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  %ret = load i32, i32 addrspace(200)* %retptr
  ret i32 %ret
}

define i64 @load-pre-indexed-doubleword2(%pre.struct.i64 addrspace(200)* addrspace(200)* %this, i1 %cond,
                                         %pre.struct.i64 addrspace(200)* %load2) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-doubleword2
; CHECK: ldur x{{[0-9]+}}, [c{{[0-9]+}}, #8]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.i64 addrspace(200)*, %pre.struct.i64 addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.i64, %pre.struct.i64 addrspace(200)* %load1, i64 0, i32 1
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.i64, %pre.struct.i64 addrspace(200)* %load2, i64 0, i32 2
  br label %return
return:
  %retptr = phi i64 addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  %ret = load i64, i64 addrspace(200)* %retptr
  ret i64 %ret
}

define <2 x i64> @load-pre-indexed-quadword2(%pre.struct.i128 addrspace(200)* addrspace(200)* %this, i1 %cond,
                                             %pre.struct.i128 addrspace(200)* %load2) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-quadword2
; CHECK: ldur q{{[0-9]+}}, [c{{[0-9]+}}, #16]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.i128 addrspace(200)*, %pre.struct.i128 addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.i128, %pre.struct.i128 addrspace(200)* %load1, i64 0, i32 1
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.i128, %pre.struct.i128 addrspace(200)* %load2, i64 0, i32 2
  br label %return
return:
  %retptr = phi <2 x i64> addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  %ret = load <2 x i64>, <2 x i64> addrspace(200)* %retptr
  ret <2 x i64> %ret
}

define float @load-pre-indexed-float2(%pre.struct.float addrspace(200)* addrspace(200)* %this, i1 %cond,
                                      %pre.struct.float addrspace(200)* %load2) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-float2
; CHECK: ldur s{{[0-9]+}}, [c{{[0-9]+}}, #4]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.float addrspace(200)*, %pre.struct.float addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.float, %pre.struct.float addrspace(200)* %load1, i64 0, i32 1
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.float, %pre.struct.float addrspace(200)* %load2, i64 0, i32 2
  br label %return
return:
  %retptr = phi float addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  %ret = load float, float addrspace(200)* %retptr
  ret float %ret
}

define double @load-pre-indexed-double2(%pre.struct.double addrspace(200)* addrspace(200)* %this, i1 %cond,
                                        %pre.struct.double addrspace(200)* %load2) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-double2
; CHECK: ldur d{{[0-9]+}}, [c{{[0-9]+}}, #8]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.double addrspace(200)*, %pre.struct.double addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.double, %pre.struct.double addrspace(200)* %load1, i64 0, i32 1
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.double, %pre.struct.double addrspace(200)* %load2, i64 0, i32 2
  br label %return
return:
  %retptr = phi double addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  %ret = load double, double addrspace(200)* %retptr
  ret double %ret
}

; FIXME: the load-store optimizer cannot currently handle this case.
; We should be able to emit ldr c0, [c0, #16], but this is currently
; disabled to avoid cases where the immediate is negative and less
; then what the unscaled immediate instruction can handle.
define i8 addrspace(200)* @load-pre-indexed-capability2(%pre.struct.capability addrspace(200)* addrspace(200)* %this, i1 %cond,
                                                %pre.struct.capability addrspace(200)* %load2) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-capability2
; CHECK-NOT: ldr c{{[0-9]+}}, [c{{[0-9]+}}, #16]
; CHECK: ldr {{c[0-9]+}}, [c{{[0-9]+}}, #0]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.capability addrspace(200)*, %pre.struct.capability addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.capability, %pre.struct.capability addrspace(200)* %load1, i64 0, i32 1
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.capability, %pre.struct.capability addrspace(200)* %load2, i64 0, i32 2
  br label %return
return:
  %retptr = phi i8 addrspace(200)* addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  %ret = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %retptr
  ret i8 addrspace(200)* %ret
}

define i32 @load-pre-indexed-word3(%pre.struct.i32 addrspace(200)* addrspace(200)* %this, i1 %cond,
                                   %pre.struct.i32 addrspace(200)* %load2) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-word3
; CHECK: ldur w{{[0-9]+}}, [c{{[0-9]+}}, #12]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.i32 addrspace(200)*, %pre.struct.i32 addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.i32, %pre.struct.i32 addrspace(200)* %load1, i64 0, i32 3
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.i32, %pre.struct.i32 addrspace(200)* %load2, i64 0, i32 4
  br label %return
return:
  %retptr = phi i32 addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  %ret = load i32, i32 addrspace(200)* %retptr
  ret i32 %ret
}

define i64 @load-pre-indexed-doubleword3(%pre.struct.i64 addrspace(200)* addrspace(200)* %this, i1 %cond,
                                         %pre.struct.i64 addrspace(200)* %load2) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-doubleword3
; CHECK: ldur x{{[0-9]+}}, [c{{[0-9]+}}, #16]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.i64 addrspace(200)*, %pre.struct.i64 addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.i64, %pre.struct.i64 addrspace(200)* %load1, i64 0, i32 2
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.i64, %pre.struct.i64 addrspace(200)* %load2, i64 0, i32 3
  br label %return
return:
  %retptr = phi i64 addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  %ret = load i64, i64 addrspace(200)* %retptr
  ret i64 %ret
}

define <2 x i64> @load-pre-indexed-quadword3(%pre.struct.i128 addrspace(200)* addrspace(200)* %this, i1 %cond,
                                             %pre.struct.i128 addrspace(200)* %load2) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-quadword3
; CHECK: ldur q{{[0-9]+}}, [c{{[0-9]+}}, #32]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.i128 addrspace(200)*, %pre.struct.i128 addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.i128, %pre.struct.i128 addrspace(200)* %load1, i64 0, i32 2
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.i128, %pre.struct.i128 addrspace(200)* %load2, i64 0, i32 3
  br label %return
return:
  %retptr = phi <2 x i64> addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  %ret = load <2 x i64>, <2 x i64> addrspace(200)* %retptr
  ret <2 x i64> %ret
}

define float @load-pre-indexed-float3(%pre.struct.float addrspace(200)* addrspace(200)* %this, i1 %cond,
                                      %pre.struct.float addrspace(200)* %load2) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-float3
; CHECK: ldur s{{[0-9]+}}, [c{{[0-9]+}}, #8]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.float addrspace(200)*, %pre.struct.float addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.float, %pre.struct.float addrspace(200)* %load1, i64 0, i32 2
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.float, %pre.struct.float addrspace(200)* %load2, i64 0, i32 3
  br label %return
return:
  %retptr = phi float addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  %ret = load float, float addrspace(200)* %retptr
  ret float %ret
}

define double @load-pre-indexed-double3(%pre.struct.double addrspace(200)* addrspace(200)* %this, i1 %cond,
                                        %pre.struct.double addrspace(200)* %load2) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-double3
; CHECK: ldur d{{[0-9]+}}, [c{{[0-9]+}}, #16]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.double addrspace(200)*, %pre.struct.double addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.double, %pre.struct.double addrspace(200)* %load1, i64 0, i32 2
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.double, %pre.struct.double addrspace(200)* %load2, i64 0, i32 3
  br label %return
return:
  %retptr = phi double addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  %ret = load double, double addrspace(200)* %retptr
  ret double %ret
}

; FIXME: the load-store optimizer cannot currently handle this case.
; We should be able to emit ldr c0, [c0, #16], but this is currently
; disabled to avoid cases where the immediate is negative and less
; then what the unscaled immediate instruction can handle.
define i8 addrspace(200)* @load-pre-indexed-capability3(%pre.struct.capability addrspace(200)* addrspace(200)* %this, i1 %cond,
                                                        %pre.struct.capability addrspace(200)* %load2) addrspace(200) nounwind {
; CHECK-LABEL: load-pre-indexed-capability3
; CHECK-NOT: ldr c{{[0-9]+}}, [c{{[0-9]+}}, #32]
; CHECK: ldr c{{[0-9]+}}, [c{{[0-9]+}}, #0]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.capability addrspace(200)*, %pre.struct.capability addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.capability, %pre.struct.capability addrspace(200)* %load1, i64 0, i32 2
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.capability, %pre.struct.capability addrspace(200)* %load2, i64 0, i32 3
  br label %return
return:
  %retptr = phi i8 addrspace(200)* addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  %ret = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %retptr
  ret i8 addrspace(200)* %ret
}

; Check the following transform:
;
; add x8, x8, #16
;  ...
; str X, [c8]
;  ->
; str X, [c8, #16]
;
; with X being either w0, x0, s0, d0 or q0.

define void @store-pre-indexed-word2(%pre.struct.i32 addrspace(200)* addrspace(200)* %this, i1 %cond,
                                     %pre.struct.i32 addrspace(200)* %load2,
                                     i32 %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-word2
; CHECK: stur w{{[0-9]+}}, [c{{[0-9]+}}, #4]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.i32 addrspace(200)*, %pre.struct.i32 addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.i32, %pre.struct.i32 addrspace(200)* %load1, i64 0, i32 1
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.i32, %pre.struct.i32 addrspace(200)* %load2, i64 0, i32 2
  br label %return
return:
  %retptr = phi i32 addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  store i32 %val, i32 addrspace(200)* %retptr
  ret void
}

define void @store-pre-indexed-doubleword2(%pre.struct.i64 addrspace(200)* addrspace(200)* %this, i1 %cond,
                                           %pre.struct.i64 addrspace(200)* %load2,
                                           i64 %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-doubleword2
; CHECK: stur x{{[0-9]+}}, [c{{[0-9]+}}, #8]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.i64 addrspace(200)*, %pre.struct.i64 addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.i64, %pre.struct.i64 addrspace(200)* %load1, i64 0, i32 1
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.i64, %pre.struct.i64 addrspace(200)* %load2, i64 0, i32 2
  br label %return
return:
  %retptr = phi i64 addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  store i64 %val, i64 addrspace(200)* %retptr
  ret void
}

define void @store-pre-indexed-quadword2(%pre.struct.i128 addrspace(200)* addrspace(200)* %this, i1 %cond,
                                         %pre.struct.i128 addrspace(200)* %load2,
                                         <2 x i64> %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-quadword2
; CHECK: stur q{{[0-9]+}}, [c{{[0-9]+}}, #16]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.i128 addrspace(200)*, %pre.struct.i128 addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.i128, %pre.struct.i128 addrspace(200)* %load1, i64 0, i32 1
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.i128, %pre.struct.i128 addrspace(200)* %load2, i64 0, i32 2
  br label %return
return:
  %retptr = phi <2 x i64> addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  store <2 x i64> %val, <2 x i64> addrspace(200)* %retptr
  ret void
}

define void @store-pre-indexed-float2(%pre.struct.float addrspace(200)* addrspace(200)* %this, i1 %cond,
                                      %pre.struct.float addrspace(200)* %load2,
                                      float %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-float2
; CHECK: stur s{{[0-9]+}}, [c{{[0-9]+}}, #4]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.float addrspace(200)*, %pre.struct.float addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.float, %pre.struct.float addrspace(200)* %load1, i64 0, i32 1
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.float, %pre.struct.float addrspace(200)* %load2, i64 0, i32 2
  br label %return
return:
  %retptr = phi float addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  store float %val, float addrspace(200)* %retptr
  ret void
}

define void @store-pre-indexed-double2(%pre.struct.double addrspace(200)* addrspace(200)* %this, i1 %cond,
                                      %pre.struct.double addrspace(200)* %load2,
                                      double %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-double2
; CHECK: stur d{{[0-9]+}}, [c{{[0-9]+}}, #8]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.double addrspace(200)*, %pre.struct.double addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.double, %pre.struct.double addrspace(200)* %load1, i64 0, i32 1
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.double, %pre.struct.double addrspace(200)* %load2, i64 0, i32 2
  br label %return
return:
  %retptr = phi double addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  store double %val, double addrspace(200)* %retptr
  ret void
}

define void @store-pre-indexed-capability2(%pre.struct.capability addrspace(200)* addrspace(200)* %this, i1 %cond,
                                           %pre.struct.capability addrspace(200)* %load2,
                                           i8 addrspace(200)* %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-capability2
; CHECK: str c{{[0-9]+}}, [c{{[0-9]+}}, #16]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.capability addrspace(200)*, %pre.struct.capability addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.capability, %pre.struct.capability addrspace(200)* %load1, i64 0, i32 1
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.capability, %pre.struct.capability addrspace(200)* %load2, i64 0, i32 2
  br label %return
return:
  %retptr = phi i8 addrspace(200)* addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  store i8 addrspace(200)* %val, i8 addrspace(200)* addrspace(200)* %retptr
  ret void
}

define void @store-pre-indexed-word3(%pre.struct.i32 addrspace(200)* addrspace(200)* %this, i1 %cond,
                                     %pre.struct.i32 addrspace(200)* %load2,
                                     i32 %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-word3
; CHECK: stur w{{[0-9]+}}, [c{{[0-9]+}}, #12]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.i32 addrspace(200)*, %pre.struct.i32 addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.i32, %pre.struct.i32 addrspace(200)* %load1, i64 0, i32 3
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.i32, %pre.struct.i32 addrspace(200)* %load2, i64 0, i32 4
  br label %return
return:
  %retptr = phi i32 addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  store i32 %val, i32 addrspace(200)* %retptr
  ret void
}

define void @store-pre-indexed-doubleword3(%pre.struct.i64 addrspace(200)* addrspace(200)* %this, i1 %cond,
                                           %pre.struct.i64 addrspace(200)* %load2,
                                           i64 %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-doubleword3
; CHECK: stur x{{[0-9]+}}, [c{{[0-9]+}}, #24]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.i64 addrspace(200)*, %pre.struct.i64 addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.i64, %pre.struct.i64 addrspace(200)* %load1, i64 0, i32 3
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.i64, %pre.struct.i64 addrspace(200)* %load2, i64 0, i32 4
  br label %return
return:
  %retptr = phi i64 addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  store i64 %val, i64 addrspace(200)* %retptr
  ret void
}

define void @store-pre-indexed-quadword3(%pre.struct.i128 addrspace(200)* addrspace(200)* %this, i1 %cond,
                                         %pre.struct.i128 addrspace(200)* %load2,
                                         <2 x i64> %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-quadword3
; CHECK: stur q{{[0-9]+}}, [c{{[0-9]+}}, #32]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.i128 addrspace(200)*, %pre.struct.i128 addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.i128, %pre.struct.i128 addrspace(200)* %load1, i64 0, i32 2
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.i128, %pre.struct.i128 addrspace(200)* %load2, i64 0, i32 3
  br label %return
return:
  %retptr = phi <2 x i64> addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  store <2 x i64> %val, <2 x i64> addrspace(200)* %retptr
  ret void
}

define void @store-pre-indexed-float3(%pre.struct.float addrspace(200)* addrspace(200)* %this, i1 %cond,
                                      %pre.struct.float addrspace(200)* %load2,
                                      float %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-float3
; CHECK: stur s{{[0-9]+}}, [c{{[0-9]+}}, #8]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.float addrspace(200)*, %pre.struct.float addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.float, %pre.struct.float addrspace(200)* %load1, i64 0, i32 2
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.float, %pre.struct.float addrspace(200)* %load2, i64 0, i32 3
  br label %return
return:
  %retptr = phi float addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  store float %val, float addrspace(200)* %retptr
  ret void
}

define void @store-pre-indexed-double3(%pre.struct.double addrspace(200)* addrspace(200)* %this, i1 %cond,
                                      %pre.struct.double addrspace(200)* %load2,
                                      double %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-double3
; CHECK: stur d{{[0-9]+}}, [c{{[0-9]+}}, #16]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.double addrspace(200)*, %pre.struct.double addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.double, %pre.struct.double addrspace(200)* %load1, i64 0, i32 2
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.double, %pre.struct.double addrspace(200)* %load2, i64 0, i32 3
  br label %return
return:
  %retptr = phi double addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  store double %val, double addrspace(200)* %retptr
  ret void
}

define void @store-pre-indexed-capability3(%pre.struct.capability addrspace(200)* addrspace(200)* %this, i1 %cond,
                                           %pre.struct.capability addrspace(200)* %load2,
                                           i8 addrspace(200)* %val) addrspace(200) nounwind {
; CHECK-LABEL: store-pre-indexed-capability3
; CHECK: str c{{[0-9]+}}, [c{{[0-9]+}}, #32]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.capability addrspace(200)*, %pre.struct.capability addrspace(200)* addrspace(200)* %this
  %gep1 = getelementptr inbounds %pre.struct.capability, %pre.struct.capability addrspace(200)* %load1, i64 0, i32 2
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.capability, %pre.struct.capability addrspace(200)* %load2, i64 0, i32 3
  br label %return
return:
  %retptr = phi i8 addrspace(200)* addrspace(200)* [ %gep1, %if.then ], [ %gep2, %if.end ]
  store i8 addrspace(200)* %val, i8 addrspace(200)* addrspace(200)* %retptr
  ret void
}

; Check the following transform:
;
; ldr X, [c20]
;  ...
; add x20, x20, #32
;  ->
; ldr X, [c20], #32
;
; with X being either w0, x0, s0, d0 or q0.

define void @load-post-indexed-byte(i8 addrspace(200)* %array, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: load-post-indexed-byte
; CHECK: ldrb w{{[0-9]+}}, [c{{[0-9]+}}], #4
entry:
  %gep1 = getelementptr i8, i8 addrspace(200)* %array, i64 2
  br label %body

body:
  %iv2 = phi i8 addrspace(200)* [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr i8, i8 addrspace(200)* %iv2, i64 -1
  %load = load i8, i8 addrspace(200)* %gep2
  call void @use-byte(i8 %load)
  %load2 = load i8, i8 addrspace(200)* %iv2
  call void @use-byte(i8 %load2)
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr i8, i8 addrspace(200)* %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

define void @load-post-indexed-halfword(i16 addrspace(200)* %array, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: load-post-indexed-halfword
; CHECK: ldrh w{{[0-9]+}}, [c{{[0-9]+}}], #8
entry:
  %gep1 = getelementptr i16, i16 addrspace(200)* %array, i64 2
  br label %body

body:
  %iv2 = phi i16 addrspace(200)* [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr i16, i16 addrspace(200)* %iv2, i64 -1
  %load = load i16, i16 addrspace(200)* %gep2
  call void @use-halfword(i16 %load)
  %load2 = load i16, i16 addrspace(200)* %iv2
  call void @use-halfword(i16 %load2)
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr i16, i16 addrspace(200)* %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

define void @load-post-indexed-word(i32 addrspace(200)* %array, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: load-post-indexed-word
; CHECK: ldr w{{[0-9]+}}, [c{{[0-9]+}}], #16
entry:
  %gep1 = getelementptr i32, i32 addrspace(200)* %array, i64 2
  br label %body

body:
  %iv2 = phi i32 addrspace(200)* [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr i32, i32 addrspace(200)* %iv2, i64 -1
  %load = load i32, i32 addrspace(200)* %gep2
  call void @use-word(i32 %load)
  %load2 = load i32, i32 addrspace(200)* %iv2
  call void @use-word(i32 %load2)
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr i32, i32 addrspace(200)* %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

define void @load-post-indexed-doubleword(i64 addrspace(200)* %array, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: load-post-indexed-doubleword
; CHECK: ldr x{{[0-9]+}}, [c{{[0-9]+}}], #32
entry:
  %gep1 = getelementptr i64, i64 addrspace(200)* %array, i64 2
  br label %body

body:
  %iv2 = phi i64 addrspace(200)* [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr i64, i64 addrspace(200)* %iv2, i64 -1
  %load = load i64, i64 addrspace(200)* %gep2
  call void @use-doubleword(i64 %load)
  %load2 = load i64, i64 addrspace(200)* %iv2
  call void @use-doubleword(i64 %load2)
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr i64, i64 addrspace(200)* %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

define void @load-post-indexed-quadword(<2 x i64> addrspace(200)* %array, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: load-post-indexed-quadword
; CHECK: ldr q{{[0-9]+}}, [c{{[0-9]+}}], #64
entry:
  %gep1 = getelementptr <2 x i64>, <2 x i64> addrspace(200)* %array, i64 2
  br label %body

body:
  %iv2 = phi <2 x i64> addrspace(200)* [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr <2 x i64>, <2 x i64> addrspace(200)* %iv2, i64 -1
  %load = load <2 x i64>, <2 x i64> addrspace(200)* %gep2
  call void @use-quadword(<2 x i64> %load)
  %load2 = load <2 x i64>, <2 x i64> addrspace(200)* %iv2
  call void @use-quadword(<2 x i64> %load2)
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr <2 x i64>, <2 x i64> addrspace(200)* %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

define void @load-post-indexed-float(float addrspace(200)* %array, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: load-post-indexed-float
; CHECK: ldr s{{[0-9]+}}, [c{{[0-9]+}}], #16
entry:
  %gep1 = getelementptr float, float addrspace(200)* %array, i64 2
  br label %body

body:
  %iv2 = phi float addrspace(200)* [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr float, float addrspace(200)* %iv2, i64 -1
  %load = load float, float addrspace(200)* %gep2
  call void @use-float(float %load)
  %load2 = load float, float addrspace(200)* %iv2
  call void @use-float(float %load2)
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr float, float addrspace(200)* %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

define void @load-post-indexed-double(double addrspace(200)* %array, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: load-post-indexed-double
; CHECK: ldr d{{[0-9]+}}, [c{{[0-9]+}}], #32
entry:
  %gep1 = getelementptr double, double addrspace(200)* %array, i64 2
  br label %body

body:
  %iv2 = phi double addrspace(200)* [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr double, double addrspace(200)* %iv2, i64 -1
  %load = load double, double addrspace(200)* %gep2
  call void @use-double(double %load)
  %load2 = load double, double addrspace(200)* %iv2
  call void @use-double(double %load2)
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr double, double addrspace(200)* %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

define void @load-post-indexed-capability(i8 addrspace(200)* addrspace(200)* %array, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: load-post-indexed-capability
; CHECK: ldr c{{[0-9]+}}, [c{{[0-9]+}}], #64
entry:
  %gep1 = getelementptr i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %array, i64 2
  br label %body

body:
  %iv2 = phi i8 addrspace(200)* addrspace(200)* [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %iv2, i64 -1
  %load = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %gep2
  call void @use-capability(i8 addrspace(200)* %load)
  %load2 = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %iv2
  call void @use-capability(i8 addrspace(200)* %load2)
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

; Check the following transform:
;
; str X, [c20]
;  ...
; add x20, x20, #32
;  ->
; str X, [c20], #32
;
; with X being either w0, x0, s0, d0 or q0.

define void @store-post-indexed-byte(i8 addrspace(200)* %array, i64 %count, i8 %val) addrspace(200) nounwind {
; CHECK-LABEL: store-post-indexed-byte
; CHECK: strb w{{[0-9]+}}, [c{{[0-9]+}}], #4
entry:
  %gep1 = getelementptr i8, i8 addrspace(200)* %array, i64 2
  br label %body

body:
  %iv2 = phi i8 addrspace(200)* [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr i8, i8 addrspace(200)* %iv2, i64 -1
  %load = load i8, i8 addrspace(200)* %gep2
  call void @use-byte(i8 %load)
  store i8 %val, i8 addrspace(200)* %iv2
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr i8, i8 addrspace(200)* %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

define void @store-post-indexed-halfword(i16 addrspace(200)* %array, i64 %count, i16 %val) addrspace(200) nounwind {
; CHECK-LABEL: store-post-indexed-halfword
; CHECK: strh w{{[0-9]+}}, [c{{[0-9]+}}], #8
entry:
  %gep1 = getelementptr i16, i16 addrspace(200)* %array, i64 2
  br label %body

body:
  %iv2 = phi i16 addrspace(200)* [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr i16, i16 addrspace(200)* %iv2, i64 -1
  %load = load i16, i16 addrspace(200)* %gep2
  call void @use-halfword(i16 %load)
  store i16 %val, i16 addrspace(200)* %iv2
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr i16, i16 addrspace(200)* %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

define void @store-post-indexed-word(i32 addrspace(200)* %array, i64 %count, i32 %val) addrspace(200) nounwind {
; CHECK-LABEL: store-post-indexed-word
; CHECK: str w{{[0-9]+}}, [c{{[0-9]+}}], #16
entry:
  %gep1 = getelementptr i32, i32 addrspace(200)* %array, i64 2
  br label %body

body:
  %iv2 = phi i32 addrspace(200)* [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr i32, i32 addrspace(200)* %iv2, i64 -1
  %load = load i32, i32 addrspace(200)* %gep2
  call void @use-word(i32 %load)
  store i32 %val, i32 addrspace(200)* %iv2
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr i32, i32 addrspace(200)* %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

define void @store-post-indexed-doubleword(i64 addrspace(200)* %array, i64 %count, i64 %val) addrspace(200) nounwind {
; CHECK-LABEL: store-post-indexed-doubleword
; CHECK: str x{{[0-9]+}}, [c{{[0-9]+}}], #32
entry:
  %gep1 = getelementptr i64, i64 addrspace(200)* %array, i64 2
  br label %body

body:
  %iv2 = phi i64 addrspace(200)* [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr i64, i64 addrspace(200)* %iv2, i64 -1
  %load = load i64, i64 addrspace(200)* %gep2
  call void @use-doubleword(i64 %load)
  store i64 %val, i64 addrspace(200)* %iv2
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr i64, i64 addrspace(200)* %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

define void @store-post-indexed-quadword(<2 x i64> addrspace(200)* %array, i64 %count, <2 x i64> %val) addrspace(200) nounwind {
; CHECK-LABEL: store-post-indexed-quadword
; CHECK: str q{{[0-9]+}}, [c{{[0-9]+}}], #64
entry:
  %gep1 = getelementptr <2 x i64>, <2 x i64> addrspace(200)* %array, i64 2
  br label %body

body:
  %iv2 = phi <2 x i64> addrspace(200)* [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr <2 x i64>, <2 x i64> addrspace(200)* %iv2, i64 -1
  %load = load <2 x i64>, <2 x i64> addrspace(200)* %gep2
  call void @use-quadword(<2 x i64> %load)
  store <2 x i64> %val, <2 x i64> addrspace(200)* %iv2
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr <2 x i64>, <2 x i64> addrspace(200)* %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

define void @store-post-indexed-float(float addrspace(200)* %array, i64 %count, float %val) addrspace(200) nounwind {
; CHECK-LABEL: store-post-indexed-float
; CHECK: str s{{[0-9]+}}, [c{{[0-9]+}}], #16
entry:
  %gep1 = getelementptr float, float addrspace(200)* %array, i64 2
  br label %body

body:
  %iv2 = phi float addrspace(200)* [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr float, float addrspace(200)* %iv2, i64 -1
  %load = load float, float addrspace(200)* %gep2
  call void @use-float(float %load)
  store float %val, float addrspace(200)* %iv2
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr float, float addrspace(200)* %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

define void @store-post-indexed-double(double addrspace(200)* %array, i64 %count, double %val) addrspace(200) nounwind {
; CHECK-LABEL: store-post-indexed-double
; CHECK: str d{{[0-9]+}}, [c{{[0-9]+}}], #32
entry:
  %gep1 = getelementptr double, double addrspace(200)* %array, i64 2
  br label %body

body:
  %iv2 = phi double addrspace(200)* [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr double, double addrspace(200)* %iv2, i64 -1
  %load = load double, double addrspace(200)* %gep2
  call void @use-double(double %load)
  store double %val, double addrspace(200)* %iv2
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr double, double addrspace(200)* %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

define void @store-post-indexed-capability(i8 addrspace(200)* addrspace(200)* %array, i64 %count, i8 addrspace(200)* %val) addrspace(200) nounwind {
; CHECK-LABEL: store-post-indexed-capability
; CHECK: str c{{[0-9]+}}, [c{{[0-9]+}}], #64
entry:
  %gep1 = getelementptr i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %array, i64 2
  br label %body

body:
  %iv2 = phi i8 addrspace(200)* addrspace(200)* [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %iv2, i64 -1
  %load = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %gep2
  call void @use-capability(i8 addrspace(200)* %load)
  store i8 addrspace(200)* %val, i8 addrspace(200)* addrspace(200)* %iv2
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

declare void @use-byte(i8) addrspace(200)
declare void @use-halfword(i16) addrspace(200)
declare void @use-word(i32) addrspace(200)
declare void @use-doubleword(i64) addrspace(200)
declare void @use-quadword(<2 x i64>) addrspace(200)
declare void @use-float(float) addrspace(200)
declare void @use-double(double) addrspace(200)
declare void @use-capability(i8 addrspace(200)*) addrspace(200)

; Check the following transform:
;
; stp w0, [c20]
;  ...
; add x20, x20, #32
;  ->
; stp w0, [c20], #32

define void @store-pair-post-indexed-word(i32 addrspace(200)* addrspace(200)* %dstptr, i32, i32 %src.real, i32 %src.imag) addrspace(200) nounwind {
; CHECK-LABEL: store-pair-post-indexed-word
; CHECK: stp w{{[0-9]+}}, w{{[0-9]+}}, [c{{[0-9]+}}], #16
  %dst = load i32 addrspace(200)*, i32 addrspace(200)* addrspace(200)* %dstptr
  %dst.realp = getelementptr inbounds i32, i32 addrspace(200)* %dst, i32 0
  %dst.imagp = getelementptr inbounds i32, i32 addrspace(200)* %dst, i32 1
  store i32 %src.real, i32 addrspace(200)* %dst.realp
  store i32 %src.imag, i32 addrspace(200)* %dst.imagp
  %dst.next = getelementptr inbounds i32, i32 addrspace(200)* %dst, i32 4
  store i32 addrspace(200)* %dst.next, i32 addrspace(200)* addrspace(200)* %dstptr
  ret void
}

define void @store-pair-post-indexed-doubleword(i64 addrspace(200)* addrspace(200)* %dstptr, i64, i64 %src.real, i64 %src.imag) addrspace(200) nounwind {
; CHECK-LABEL: store-pair-post-indexed-doubleword
; CHECK: stp x{{[0-9]+}}, x{{[0-9]+}}, [c{{[0-9]+}}], #32
  %dst = load i64 addrspace(200)*, i64 addrspace(200)* addrspace(200)* %dstptr
  %dst.realp = getelementptr inbounds i64, i64 addrspace(200)* %dst, i32 0
  %dst.imagp = getelementptr inbounds i64, i64 addrspace(200)* %dst, i32 1
  store i64 %src.real, i64 addrspace(200)* %dst.realp
  store i64 %src.imag, i64 addrspace(200)* %dst.imagp
  %dst.next = getelementptr inbounds i64, i64 addrspace(200)* %dst, i32 4
  store i64 addrspace(200)* %dst.next, i64 addrspace(200)* addrspace(200)* %dstptr
  ret void
}

define void @store-pair-post-indexed-float(float addrspace(200)* addrspace(200)* %dstptr, float %src.real, float %src.imag) addrspace(200) nounwind {
; CHECK-LABEL: store-pair-post-indexed-float
; CHECK: stp s{{[0-9]+}}, s{{[0-9]+}}, [c{{[0-9]+}}], #16
  %dst = load float addrspace(200)*, float addrspace(200)* addrspace(200)* %dstptr
  %dst.realp = getelementptr inbounds float, float addrspace(200)* %dst, i32 0
  %dst.imagp = getelementptr inbounds float, float addrspace(200)* %dst, i32 1
  store float %src.real, float addrspace(200)* %dst.realp
  store float %src.imag, float addrspace(200)* %dst.imagp
  %dst.next = getelementptr inbounds float, float addrspace(200)* %dst, i32 4
  store float addrspace(200)* %dst.next, float addrspace(200)* addrspace(200)* %dstptr
  ret void
}

define void @store-pair-post-indexed-double(double addrspace(200)* addrspace(200)* %dstptr, double %src.real, double %src.imag) addrspace(200) nounwind {
; CHECK-LABEL: store-pair-post-indexed-double
; CHECK: stp d{{[0-9]+}}, d{{[0-9]+}}, [c{{[0-9]+}}], #32
  %dst = load double addrspace(200)*, double addrspace(200)* addrspace(200)* %dstptr
  %dst.realp = getelementptr inbounds double, double addrspace(200)* %dst, i32 0
  %dst.imagp = getelementptr inbounds double, double addrspace(200)* %dst, i32 1
  store double %src.real, double addrspace(200)* %dst.realp
  store double %src.imag, double addrspace(200)* %dst.imagp
  %dst.next = getelementptr inbounds double, double addrspace(200)* %dst, i32 4
  store double addrspace(200)* %dst.next, double addrspace(200)* addrspace(200)* %dstptr
  ret void
}

define void @store-pair-post-indexed-capability(i8, i8 addrspace(200)* addrspace(200)* addrspace(200)* %dstptr,
                                                i8 addrspace(200)* %src.real, i8 addrspace(200)* %src.imag) addrspace(200) nounwind {
; CHECK-LABEL: store-pair-post-indexed-capability
; CHECK: stp c{{[0-9]+}}, c{{[0-9]+}}, [c{{[0-9]+}}], #64
  %dst = load i8 addrspace(200)* addrspace(200)*, i8 addrspace(200)* addrspace(200)* addrspace(200)* %dstptr
  %dst.realp = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %dst, i32 0
  %dst.imagp = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %dst, i32 1
  store i8 addrspace(200)* %src.real, i8 addrspace(200)* addrspace(200)* %dst.realp
  store i8 addrspace(200)* %src.imag, i8 addrspace(200)* addrspace(200)* %dst.imagp
  %dst.next = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %dst, i32 4
  store i8 addrspace(200)* addrspace(200)* %dst.next, i8 addrspace(200)* addrspace(200)* addrspace(200)* %dstptr
  ret void
}

; Check the following transform:
;
; (ldr|str) X, [c20]
;  ...
; sub x20, x20, #16
;  ->
; (ldr|str) X, [c20], #-16
;
; with X being either w0, x0, s0, d0 or q0.

define void @post-indexed-sub-word(i32 addrspace(200)* %a, i32 addrspace(200)* %b, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: post-indexed-sub-word
; CHECK: ldr w{{[0-9]+}}, [c{{[0-9]+}}], #-8
; CHECK: str w{{[0-9]+}}, [c{{[0-9]+}}], #-8
  br label %for.body
for.body:
  %phi1 = phi i32 addrspace(200)* [ %gep4, %for.body ], [ %b, %0 ]
  %phi2 = phi i32 addrspace(200)* [ %gep3, %for.body ], [ %a, %0 ]
  %i = phi i64 [ %dec.i, %for.body], [ %count, %0 ]
  %gep1 = getelementptr i32, i32 addrspace(200)* %phi1, i64 -1
  %load1 = load i32, i32 addrspace(200)* %gep1
  %gep2 = getelementptr i32, i32 addrspace(200)* %phi2, i64 -1
  store i32 %load1, i32 addrspace(200)* %gep2
  %load2 = load i32, i32 addrspace(200)* %phi1
  store i32 %load2, i32 addrspace(200)* %phi2
  %dec.i = add nsw i64 %i, -1
  %gep3 = getelementptr i32, i32 addrspace(200)* %phi2, i64 -2
  %gep4 = getelementptr i32, i32 addrspace(200)* %phi1, i64 -2
  %cond = icmp sgt i64 %dec.i, 0
  br i1 %cond, label %for.body, label %end
end:
  ret void
}

define void @post-indexed-sub-doubleword(i64 addrspace(200)* %a, i64 addrspace(200)* %b, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: post-indexed-sub-doubleword
; CHECK: ldr x{{[0-9]+}}, [c{{[0-9]+}}], #-16
; CHECK: str x{{[0-9]+}}, [c{{[0-9]+}}], #-16
  br label %for.body
for.body:
  %phi1 = phi i64 addrspace(200)* [ %gep4, %for.body ], [ %b, %0 ]
  %phi2 = phi i64 addrspace(200)* [ %gep3, %for.body ], [ %a, %0 ]
  %i = phi i64 [ %dec.i, %for.body], [ %count, %0 ]
  %gep1 = getelementptr i64, i64 addrspace(200)* %phi1, i64 -1
  %load1 = load i64, i64 addrspace(200)* %gep1
  %gep2 = getelementptr i64, i64 addrspace(200)* %phi2, i64 -1
  store i64 %load1, i64 addrspace(200)* %gep2
  %load2 = load i64, i64 addrspace(200)* %phi1
  store i64 %load2, i64 addrspace(200)* %phi2
  %dec.i = add nsw i64 %i, -1
  %gep3 = getelementptr i64, i64 addrspace(200)* %phi2, i64 -2
  %gep4 = getelementptr i64, i64 addrspace(200)* %phi1, i64 -2
  %cond = icmp sgt i64 %dec.i, 0
  br i1 %cond, label %for.body, label %end
end:
  ret void
}

define void @post-indexed-sub-quadword(<2 x i64> addrspace(200)* %a, <2 x i64> addrspace(200)* %b, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: post-indexed-sub-quadword
; CHECK: ldr q{{[0-9]+}}, [c{{[0-9]+}}], #-32
; CHECK: str q{{[0-9]+}}, [c{{[0-9]+}}], #-32
  br label %for.body
for.body:
  %phi1 = phi <2 x i64> addrspace(200)* [ %gep4, %for.body ], [ %b, %0 ]
  %phi2 = phi <2 x i64> addrspace(200)* [ %gep3, %for.body ], [ %a, %0 ]
  %i = phi i64 [ %dec.i, %for.body], [ %count, %0 ]
  %gep1 = getelementptr <2 x i64>, <2 x i64> addrspace(200)* %phi1, i64 -1
  %load1 = load <2 x i64>, <2 x i64> addrspace(200)* %gep1
  %gep2 = getelementptr <2 x i64>, <2 x i64> addrspace(200)* %phi2, i64 -1
  store <2 x i64> %load1, <2 x i64> addrspace(200)* %gep2
  %load2 = load <2 x i64>, <2 x i64> addrspace(200)* %phi1
  store <2 x i64> %load2, <2 x i64> addrspace(200)* %phi2
  %dec.i = add nsw i64 %i, -1
  %gep3 = getelementptr <2 x i64>, <2 x i64> addrspace(200)* %phi2, i64 -2
  %gep4 = getelementptr <2 x i64>, <2 x i64> addrspace(200)* %phi1, i64 -2
  %cond = icmp sgt i64 %dec.i, 0
  br i1 %cond, label %for.body, label %end
end:
  ret void
}

define void @post-indexed-sub-float(float addrspace(200)* %a, float addrspace(200)* %b, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: post-indexed-sub-float
; CHECK: ldr s{{[0-9]+}}, [c{{[0-9]+}}], #-8
; CHECK: str s{{[0-9]+}}, [c{{[0-9]+}}], #-8
  br label %for.body
for.body:
  %phi1 = phi float addrspace(200)* [ %gep4, %for.body ], [ %b, %0 ]
  %phi2 = phi float addrspace(200)* [ %gep3, %for.body ], [ %a, %0 ]
  %i = phi i64 [ %dec.i, %for.body], [ %count, %0 ]
  %gep1 = getelementptr float, float addrspace(200)* %phi1, i64 -1
  %load1 = load float, float addrspace(200)* %gep1
  %gep2 = getelementptr float, float addrspace(200)* %phi2, i64 -1
  store float %load1, float addrspace(200)* %gep2
  %load2 = load float, float addrspace(200)* %phi1
  store float %load2, float addrspace(200)* %phi2
  %dec.i = add nsw i64 %i, -1
  %gep3 = getelementptr float, float addrspace(200)* %phi2, i64 -2
  %gep4 = getelementptr float, float addrspace(200)* %phi1, i64 -2
  %cond = icmp sgt i64 %dec.i, 0
  br i1 %cond, label %for.body, label %end
end:
  ret void
}

define void @post-indexed-sub-double(double addrspace(200)* %a, double addrspace(200)* %b, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: post-indexed-sub-double
; CHECK: ldr d{{[0-9]+}}, [c{{[0-9]+}}], #-16
; CHECK: str d{{[0-9]+}}, [c{{[0-9]+}}], #-16
  br label %for.body
for.body:
  %phi1 = phi double addrspace(200)* [ %gep4, %for.body ], [ %b, %0 ]
  %phi2 = phi double addrspace(200)* [ %gep3, %for.body ], [ %a, %0 ]
  %i = phi i64 [ %dec.i, %for.body], [ %count, %0 ]
  %gep1 = getelementptr double, double addrspace(200)* %phi1, i64 -1
  %load1 = load double, double addrspace(200)* %gep1
  %gep2 = getelementptr double, double addrspace(200)* %phi2, i64 -1
  store double %load1, double addrspace(200)* %gep2
  %load2 = load double, double addrspace(200)* %phi1
  store double %load2, double addrspace(200)* %phi2
  %dec.i = add nsw i64 %i, -1
  %gep3 = getelementptr double, double addrspace(200)* %phi2, i64 -2
  %gep4 = getelementptr double, double addrspace(200)* %phi1, i64 -2
  %cond = icmp sgt i64 %dec.i, 0
  br i1 %cond, label %for.body, label %end
end:
  ret void
}

define void @post-indexed-sub-capability(i8 addrspace(200)* addrspace(200)* %a, i8 addrspace(200)* addrspace(200)* %b, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: post-indexed-sub-capability
; CHECK: ldr c{{[0-9]+}}, [c{{[0-9]+}}], #-32
; CHECK: str c{{[0-9]+}}, [c{{[0-9]+}}], #-32
  br label %for.body
for.body:
  %phi1 = phi i8 addrspace(200)* addrspace(200)* [ %gep4, %for.body ], [ %b, %0 ]
  %phi2 = phi i8 addrspace(200)* addrspace(200)* [ %gep3, %for.body ], [ %a, %0 ]
  %i = phi i64 [ %dec.i, %for.body], [ %count, %0 ]
  %gep1 = getelementptr i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %phi1, i64 -1
  %load1 = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %gep1
  %gep2 = getelementptr i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %phi2, i64 -1
  store i8 addrspace(200)* %load1, i8 addrspace(200)* addrspace(200)* %gep2
  %load2 = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %phi1
  store i8 addrspace(200)* %load2, i8 addrspace(200)* addrspace(200)* %phi2
  %dec.i = add nsw i64 %i, -1
  %gep3 = getelementptr i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %phi2, i64 -2
  %gep4 = getelementptr i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %phi1, i64 -2
  %cond = icmp sgt i64 %dec.i, 0
  br i1 %cond, label %for.body, label %end
end:
  ret void
}

define void @post-indexed-sub-doubleword-offset-min(i64 addrspace(200)* %a, i64 addrspace(200)* %b, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: post-indexed-sub-doubleword-offset-min
; CHECK: ldr x{{[0-9]+}}, [c{{[0-9]+}}], #-256
; CHECK: str x{{[0-9]+}}, [c{{[0-9]+}}], #-256
  br label %for.body
for.body:
  %phi1 = phi i64 addrspace(200)* [ %gep4, %for.body ], [ %b, %0 ]
  %phi2 = phi i64 addrspace(200)* [ %gep3, %for.body ], [ %a, %0 ]
  %i = phi i64 [ %dec.i, %for.body], [ %count, %0 ]
  %gep1 = getelementptr i64, i64 addrspace(200)* %phi1, i64 1
  %load1 = load i64, i64 addrspace(200)* %gep1
  %gep2 = getelementptr i64, i64 addrspace(200)* %phi2, i64 1
  store i64 %load1, i64 addrspace(200)* %gep2
  %load2 = load i64, i64 addrspace(200)* %phi1
  store i64 %load2, i64 addrspace(200)* %phi2
  %dec.i = add nsw i64 %i, -1
  %gep3 = getelementptr i64, i64 addrspace(200)* %phi2, i64 -32
  %gep4 = getelementptr i64, i64 addrspace(200)* %phi1, i64 -32
  %cond = icmp sgt i64 %dec.i, 0
  br i1 %cond, label %for.body, label %end
end:
  ret void
}

define void @post-indexed-doubleword-offset-out-of-range(i64 addrspace(200)* %a, i64 addrspace(200)* %b, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: post-indexed-doubleword-offset-out-of-range
; CHECK: ldr x{{[0-9]+}}, [c{{[0-9]+}}]
; CHECK: add c{{[0-9]+}}, c{{[0-9]+}}, #256
; CHECK: str x{{[0-9]+}}, [c{{[0-9]+}}]
; CHECK: add c{{[0-9]+}}, c{{[0-9]+}}, #256

  br label %for.body
for.body:
  %phi1 = phi i64 addrspace(200)* [ %gep4, %for.body ], [ %b, %0 ]
  %phi2 = phi i64 addrspace(200)* [ %gep3, %for.body ], [ %a, %0 ]
  %i = phi i64 [ %dec.i, %for.body], [ %count, %0 ]
  %gep1 = getelementptr i64, i64 addrspace(200)* %phi1, i64 1
  %load1 = load i64, i64 addrspace(200)* %gep1
  %gep2 = getelementptr i64, i64 addrspace(200)* %phi2, i64 1
  store i64 %load1, i64 addrspace(200)* %gep2
  %load2 = load i64, i64 addrspace(200)* %phi1
  store i64 %load2, i64 addrspace(200)* %phi2
  %dec.i = add nsw i64 %i, -1
  %gep3 = getelementptr i64, i64 addrspace(200)* %phi2, i64 32
  %gep4 = getelementptr i64, i64 addrspace(200)* %phi1, i64 32
  %cond = icmp sgt i64 %dec.i, 0
  br i1 %cond, label %for.body, label %end
end:
  ret void
}

define void @post-indexed-paired-min-offset(i64 addrspace(200)* %a, i64 addrspace(200)* %b, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: post-indexed-paired-min-offset
; CHECK: ldp x{{[0-9]+}}, x{{[0-9]+}}, [c{{[0-9]+}}], #-512
; CHECK: stp x{{[0-9]+}}, x{{[0-9]+}}, [c{{[0-9]+}}], #-512
  br label %for.body
for.body:
  %phi1 = phi i64 addrspace(200)* [ %gep4, %for.body ], [ %b, %0 ]
  %phi2 = phi i64 addrspace(200)* [ %gep3, %for.body ], [ %a, %0 ]
  %i = phi i64 [ %dec.i, %for.body], [ %count, %0 ]
  %gep1 = getelementptr i64, i64 addrspace(200)* %phi1, i64 1
  %load1 = load i64, i64 addrspace(200)* %gep1
  %gep2 = getelementptr i64, i64 addrspace(200)* %phi2, i64 1
  %load2 = load i64, i64 addrspace(200)* %phi1
  store i64 %load1, i64 addrspace(200)* %gep2
  store i64 %load2, i64 addrspace(200)* %phi2
  %dec.i = add nsw i64 %i, -1
  %gep3 = getelementptr i64, i64 addrspace(200)* %phi2, i64 -64
  %gep4 = getelementptr i64, i64 addrspace(200)* %phi1, i64 -64
  %cond = icmp sgt i64 %dec.i, 0
  br i1 %cond, label %for.body, label %end
end:
  ret void
}

define void @post-indexed-paired-offset-out-of-range(i64 addrspace(200)* %a, i64 addrspace(200)* %b, i64 %count) addrspace(200) nounwind {
; CHECK-LABEL: post-indexed-paired-offset-out-of-range
; CHECK: ldp x{{[0-9]+}}, x{{[0-9]+}}, [c{{[0-9]+}}]
; CHECK: add c{{[0-9]+}}, c{{[0-9]+}}, #512
; CHECK: stp x{{[0-9]+}}, x{{[0-9]+}}, [c{{[0-9]+}}]
; CHECK: add c{{[0-9]+}}, c{{[0-9]+}}, #512
  br label %for.body
for.body:
  %phi1 = phi i64 addrspace(200)* [ %gep4, %for.body ], [ %b, %0 ]
  %phi2 = phi i64 addrspace(200)* [ %gep3, %for.body ], [ %a, %0 ]
  %i = phi i64 [ %dec.i, %for.body], [ %count, %0 ]
  %gep1 = getelementptr i64, i64 addrspace(200)* %phi1, i64 1
  %load1 = load i64, i64 addrspace(200)* %phi1
  %gep2 = getelementptr i64, i64 addrspace(200)* %phi2, i64 1
  %load2 = load i64, i64 addrspace(200)* %gep1
  store i64 %load1, i64 addrspace(200)* %gep2
  store i64 %load2, i64 addrspace(200)* %phi2
  %dec.i = add nsw i64 %i, -1
  %gep3 = getelementptr i64, i64 addrspace(200)* %phi2, i64 64
  %gep4 = getelementptr i64, i64 addrspace(200)* %phi1, i64 64
  %cond = icmp sgt i64 %dec.i, 0
  br i1 %cond, label %for.body, label %end
end:
  ret void
}

define void @capability-pair-offset-out-of-range(i8 addrspace(200)* addrspace(200)* %p) addrspace(200) {
; CHECK-LABEL: capability-pair-offset-out-of-range
; CHECK: ldr c{{[0-9]+}}, [c0, #1024]
; CHECK: ldr c{{[0-9]+}}, [c0, #1040]
; CHECK: stp c{{[0-9]+}}, c{{[0-9]+}}, [c0, #1008]
entry:
  %off31 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %p, i64 63
  %off32 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %p, i64 64
  %off33 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %p, i64 65
  %x = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %off32, align 16
  %y = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %off33, align 16
  store i8 addrspace(200)* %x, i8 addrspace(200)* addrspace(200)* %off31, align 16
  store i8 addrspace(200)* %y, i8 addrspace(200)* addrspace(200)* %off32, align 16
  ret void
}

; DAGCombiner::MergeConsecutiveStores merges this into a vector store,
; replaceZeroVectorStore should split the vector store back into
; scalar stores which should get merged by AArch64LoadStoreOptimizer.
define void @merge_zr32(i32 addrspace(200)* %p) addrspace(200) {
; CHECK-LABEL: merge_zr32:
; CHECK: // %entry
; NOSTRICTALIGN-NEXT: str xzr, [c{{[0-9]+}}]
; STRICTALIGN-NEXT: stp wzr, wzr, [c{{[0-9]+}}]
; CHECK-NEXT: ret
entry:
  store i32 0, i32 addrspace(200)* %p
  %p1 = getelementptr i32, i32 addrspace(200)* %p, i32 1
  store i32 0, i32 addrspace(200)* %p1
  ret void
}

; Same as merge_zr32 but the merged stores should also get paried.
define void @merge_zr32_2(i32 addrspace(200)* %p) addrspace(200) {
; CHECK-LABEL: merge_zr32_2:
; CHECK: // %entry
; NOSTRICTALIGN-NEXT: stp xzr, xzr, [c{{[0-9]+}}]
; STRICTALIGN-NEXT: stp wzr, wzr, [c{{[0-9]+}}]
; STRICTALIGN-NEXT: stp wzr, wzr, [c{{[0-9]+}}, #8]
; CHECK-NEXT: ret
entry:
  store i32 0, i32 addrspace(200)* %p
  %p1 = getelementptr i32, i32 addrspace(200)* %p, i32 1
  store i32 0, i32 addrspace(200)* %p1
  %p2 = getelementptr i32, i32 addrspace(200)* %p, i64 2
  store i32 0, i32 addrspace(200)* %p2
  %p3 = getelementptr i32, i32 addrspace(200)* %p, i64 3
  store i32 0, i32 addrspace(200)* %p3
  ret void
}

; Like merge_zr32_2, but checking the largest allowed stp immediate offset.
define void @merge_zr32_2_offset(i32 addrspace(200)* %p) addrspace(200) {
; CHECK-LABEL: merge_zr32_2_offset:
; CHECK: // %entry
; NOSTRICTALIGN-NEXT: stp xzr, xzr, [c{{[0-9]+}}, #504]
; STRICTALIGN-NEXT: str wzr, [c{{[0-9]+}}, #504]
; STRICTALIGN-NEXT: str wzr, [c{{[0-9]+}}, #508]
; STRICTALIGN-NEXT: str wzr, [c{{[0-9]+}}, #512]
; STRICTALIGN-NEXT: str wzr, [c{{[0-9]+}}, #516]
; CHECK-NEXT: ret
entry:
  %p0 = getelementptr i32, i32 addrspace(200)* %p, i32 126
  store i32 0, i32 addrspace(200)* %p0
  %p1 = getelementptr i32, i32 addrspace(200)* %p, i32 127
  store i32 0, i32 addrspace(200)* %p1
  %p2 = getelementptr i32, i32 addrspace(200)* %p, i64 128
  store i32 0, i32 addrspace(200)* %p2
  %p3 = getelementptr i32, i32 addrspace(200)* %p, i64 129
  store i32 0, i32 addrspace(200)* %p3
  ret void
}

define void @no_merge_zr32_2_offset(i32 addrspace(200)* %p) addrspace(200) {
; CHECK-LABEL: no_merge_zr32_2_offset:
; CHECK: // %entry
; NOSTRICTALIGN-NEXT: str xzr, [c{{[0-9]+}}, #4096]
; NOSTRICTALIGN-NEXT: str xzr, [c{{[0-9]+}}, #4104]
; STRICTALIGN-NEXT: str wzr, [c{{[0-9]+}}, #4096]
; STRICTALIGN-NEXT: str wzr, [c{{[0-9]+}}, #4100]
; STRICTALIGN-NEXT: str wzr, [c{{[0-9]+}}, #4104]
; STRICTALIGN-NEXT: str wzr, [c{{[0-9]+}}, #4108]
; CHECK-NEXT: ret
entry:
  %p0 = getelementptr i32, i32 addrspace(200)* %p, i32 1024
  store i32 0, i32 addrspace(200)* %p0
  %p1 = getelementptr i32, i32 addrspace(200)* %p, i32 1025
  store i32 0, i32 addrspace(200)* %p1
  %p2 = getelementptr i32, i32 addrspace(200)* %p, i64 1026
  store i32 0, i32 addrspace(200)* %p2
  %p3 = getelementptr i32, i32 addrspace(200)* %p, i64 1027
  store i32 0, i32 addrspace(200)* %p3
  ret void
}

define void @merge_zr32_3(i32 addrspace(200)* %p) addrspace(200) {
; CHECK-LABEL: merge_zr32_3:
; CHECK: // %entry
; NOSTRICTALIGN-NEXT: stp xzr, xzr, [c{{[0-9]+}}]
; NOSTRICTALIGN-NEXT: stp xzr, xzr, [c{{[0-9]+}}, #16]
; STRICTALIGN-NEXT: stp wzr, wzr, [c{{[0-9]+}}]
; STRICTALIGN-NEXT: stp wzr, wzr, [c{{[0-9]+}}, #8]
; STRICTALIGN-NEXT: stp wzr, wzr, [c{{[0-9]+}}, #16]
; STRICTALIGN-NEXT: stp wzr, wzr, [c{{[0-9]+}}, #24]
; CHECK-NEXT: ret
entry:
  store i32 0, i32 addrspace(200)* %p
  %p1 = getelementptr i32, i32 addrspace(200)* %p, i32 1
  store i32 0, i32 addrspace(200)* %p1
  %p2 = getelementptr i32, i32 addrspace(200)* %p, i64 2
  store i32 0, i32 addrspace(200)* %p2
  %p3 = getelementptr i32, i32 addrspace(200)* %p, i64 3
  store i32 0, i32 addrspace(200)* %p3
  %p4 = getelementptr i32, i32 addrspace(200)* %p, i64 4
  store i32 0, i32 addrspace(200)* %p4
  %p5 = getelementptr i32, i32 addrspace(200)* %p, i64 5
  store i32 0, i32 addrspace(200)* %p5
  %p6 = getelementptr i32, i32 addrspace(200)* %p, i64 6
  store i32 0, i32 addrspace(200)* %p6
  %p7 = getelementptr i32, i32 addrspace(200)* %p, i64 7
  store i32 0, i32 addrspace(200)* %p7
  ret void
}

; Like merge_zr32, but with 2-vector type.
define void @merge_zr32_2vec(<2 x i32> addrspace(200)* %p) addrspace(200) {
; CHECK-LABEL: merge_zr32_2vec:
; CHECK: // %entry
; NOSTRICTALIGN-NEXT: str xzr, [c{{[0-9]+}}]
; STRICTALIGN-NEXT: stp wzr, wzr, [c{{[0-9]+}}]
; CHECK-NEXT: ret
entry:
  store <2 x i32> zeroinitializer, <2 x i32> addrspace(200)* %p
  ret void
}

; Like merge_zr32, but with 3-vector type.
define void @merge_zr32_3vec(<3 x i32> addrspace(200)* %p) addrspace(200) {
; CHECK-LABEL: merge_zr32_3vec:
; CHECK: // %entry
; NOSTRICTALIGN-NEXT: str xzr, [c{{[0-9]+}}]
; NOSTRICTALIGN-NEXT: str wzr, [c{{[0-9]+}}, #8]
; STRICTALIGN-NEXT: stp wzr, wzr, [c{{[0-9]+}}]
; STRICTALIGN-NEXT: str wzr, [c{{[0-9]+}}, #8]
; CHECK-NEXT: ret
entry:
  store <3 x i32> zeroinitializer, <3 x i32> addrspace(200)* %p
  ret void
}

; Like merge_zr32, but with 4-vector type.
define void @merge_zr32_4vec(<4 x i32> addrspace(200)* %p) addrspace(200) {
; CHECK-LABEL: merge_zr32_4vec:
; CHECK: // %entry
; NOSTRICTALIGN-NEXT: stp xzr, xzr, [c{{[0-9]+}}]
; STRICTALIGN-NEXT: stp wzr, wzr, [c{{[0-9]+}}]
; STRICTALIGN-NEXT: stp wzr, wzr, [c{{[0-9]+}}, #8]
; CHECK-NEXT: ret
entry:
  store <4 x i32> zeroinitializer, <4 x i32> addrspace(200)* %p
  ret void
}

; Like merge_zr32, but with 2-vector float type.
define void @merge_zr32_2vecf(<2 x float> addrspace(200)* %p) addrspace(200) {
; CHECK-LABEL: merge_zr32_2vecf:
; CHECK: // %entry
; NOSTRICTALIGN-NEXT: str xzr, [c{{[0-9]+}}]
; STRICTALIGN-NEXT: stp wzr, wzr, [c{{[0-9]+}}]
; CHECK-NEXT: ret
entry:
  store <2 x float> zeroinitializer, <2 x float> addrspace(200)* %p
  ret void
}

; Like merge_zr32, but with 4-vector float type.
define void @merge_zr32_4vecf(<4 x float> addrspace(200)* %p) addrspace(200) {
; CHECK-LABEL: merge_zr32_4vecf:
; CHECK: // %entry
; NOSTRICTALIGN-NEXT: stp xzr, xzr, [c{{[0-9]+}}]
; STRICTALIGN-NEXT: stp wzr, wzr, [c{{[0-9]+}}]
; STRICTALIGN-NEXT: stp wzr, wzr, [c{{[0-9]+}}, #8]
; CHECK-NEXT: ret
entry:
  store <4 x float> zeroinitializer, <4 x float> addrspace(200)* %p
  ret void
}

; Similar to merge_zr32, but for 64-bit values.
define void @merge_zr64(i64 addrspace(200)* %p) addrspace(200) {
; CHECK-LABEL: merge_zr64:
; CHECK: // %entry
; CHECK-NEXT: stp xzr, xzr, [c{{[0-9]+}}]
; CHECK-NEXT: ret
entry:
  store i64 0, i64 addrspace(200)* %p
  %p1 = getelementptr i64, i64 addrspace(200)* %p, i64 1
  store i64 0, i64 addrspace(200)* %p1
  ret void
}

; Similar to merge_zr32, but for 64-bit values and with unaligned stores.
define void @merge_zr64_unalign(<2 x i64> addrspace(200)* %p) addrspace(200) {
; CHECK-LABEL: merge_zr64_unalign:
; CHECK: // %entry
; NOSTRICTALIGN-NEXT: stp xzr, xzr, [c{{[0-9]+}}]
; STRICTALIGN: strb wzr,
; STRICTALIGN: strb
; STRICTALIGN: strb
; STRICTALIGN: strb
; STRICTALIGN: strb
; STRICTALIGN: strb
; STRICTALIGN: strb
; STRICTALIGN: strb
; STRICTALIGN: strb
; STRICTALIGN: strb
; STRICTALIGN: strb
; STRICTALIGN: strb
; STRICTALIGN: strb
; STRICTALIGN: strb
; STRICTALIGN: strb
; STRICTALIGN: strb
; CHECK-NEXT: ret
entry:
  store <2 x i64> zeroinitializer, <2 x i64> addrspace(200)* %p, align 1
  ret void
}

define void @merge_zr64_2(i64 addrspace(200)* %p) addrspace(200) {
; CHECK-LABEL: merge_zr64_2:
; CHECK: // %entry
; CHECK-NEXT: stp xzr, xzr, [c{{[0-9]+}}]
; CHECK-NEXT: stp xzr, xzr, [c{{[0-9]+}}, #16]
; CHECK-NEXT: ret
entry:
  store i64 0, i64 addrspace(200)* %p
  %p1 = getelementptr i64, i64 addrspace(200)* %p, i64 1
  store i64 0, i64 addrspace(200)* %p1
  %p2 = getelementptr i64, i64 addrspace(200)* %p, i64 2
  store i64 0, i64 addrspace(200)* %p2
  %p3 = getelementptr i64, i64 addrspace(200)* %p, i64 3
  store i64 0, i64 addrspace(200)* %p3
  ret void
}

; Like merge_zr64, but with 2-vector double type.
define void @merge_zr64_2vecd(<2 x double> addrspace(200)* %p) addrspace(200) {
; CHECK-LABEL: merge_zr64_2vecd:
; CHECK: // %entry
; CHECK-NEXT: stp xzr, xzr, [c{{[0-9]+}}]
; CHECK-NEXT: ret
entry:
  store <2 x double> zeroinitializer, <2 x double> addrspace(200)* %p
  ret void
}

; Like merge_zr64, but with 3-vector i64 type.
define void @merge_zr64_3vec(<3 x i64> addrspace(200)* %p) addrspace(200) {
; CHECK-LABEL: merge_zr64_3vec:
; CHECK: // %entry
; CHECK-NEXT: stp xzr, xzr, [c{{[0-9]+}}]
; CHECK-NEXT: str xzr, [c{{[0-9]+}}, #16]
; CHECK-NEXT: ret
entry:
  store <3 x i64> zeroinitializer, <3 x i64> addrspace(200)* %p
  ret void
}

; Like merge_zr64_2, but with 4-vector double type.
define void @merge_zr64_4vecd(<4 x double> addrspace(200)* %p) addrspace(200) {
; CHECK-LABEL: merge_zr64_4vecd:
; CHECK: // %entry
; CHECK-NEXT: movi v[[REG:[0-9]]].2d, #0000000000000000
; CHECK-NEXT: stp q[[REG]], q[[REG]], [c{{[0-9]+}}]
; CHECK-NEXT: ret
entry:
  store <4 x double> zeroinitializer, <4 x double> addrspace(200)* %p
  ret void
}
