; RUN: llc -emulated-tls -mtriple=aarch64-linux-android -mattr=+c64,+morello -target-abi=purecap < %s | FileCheck %s

; Copied from AArch64/emutls.ll

; Use my_emutls_get_address like __emutls_get_address.
@my_emutls_v_xyz = external addrspace(200) global i8, align 4
declare i8 addrspace(200)* @my_emutls_get_address(i8 addrspace(200)*)

define i32 @my_get_xyz() {
; CHECK-LABEL: my_get_xyz:
; CHECK:        adrp c[[ADDR:[0-9]+]], :got:my_emutls_v_xyz
; CHECK-NEXT:   ldr c0, [c[[ADDR]], :got_lo12:my_emutls_v_xyz]
; CHECK-NEXT:   bl my_emutls_get_address
; CHECK-NEXT:   ldr w0, [c0]
; CHECK-NEXT:   ldr c30, [csp], #16

entry:
  %call = call i8 addrspace(200)* @my_emutls_get_address(i8 addrspace(200) *@my_emutls_v_xyz)
  %0 = bitcast i8 addrspace(200)* %call to i32 addrspace(200)*
  %1 = load i32, i32 addrspace(200)* %0, align 4
  ret i32 %1
}

@i1 = thread_local addrspace(200) global i32 15
@i2 = external thread_local addrspace(200) global i32
@i3 = internal thread_local addrspace(200) global i32 15
@i4 = hidden thread_local addrspace(200) global i32 15
@i5 = external hidden thread_local addrspace(200) global i32
@s1 = thread_local addrspace(200) global i16 15
@b1 = thread_local addrspace(200) global i8 0

define i32 @f1() {
; CHECK-LABEL: f1:
; CHECK:        ldr c0, [c[[ADDR]], :got_lo12:__emutls_v.i1]
; CHECK-NEXT:   bl __emutls_get_address
; CHECK-NEXT:   ldr w0, [c0]
; CHECK-NEXT:   ldr c30, [csp], #16

entry:
  %tmp1 = load i32, i32 addrspace(200)* @i1
  ret i32 %tmp1
}

define i32 addrspace(200)* @f2() {
; CHECK-LABEL: f2:
; CHECK:        adrp c[[ADDR:[0-9]+]], :got:__emutls_v.i1
; CHECK-NEXT:   ldr c0, [c[[ADDR]], :got_lo12:__emutls_v.i1]
; CHECK-NEXT:   bl __emutls_get_address
; CHECK-NEXT:   ldr c30, [csp], #16

entry:
  ret i32 addrspace(200)* @i1
}

; ARM64-LABEL: .LCPI3_0
; ARM64-NEXT: .capinit __emutls_v.i3
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0

define i32 @f5() nounwind {
; ARM64-LABEL: f5:
; ARM64:        adrp x[[ADDR:[0-9]+]], .LCPI3_0
; C64-NEXT:     ldr c0, [c[[ADDR]], :lo12:.LCPI3_0]
; A64C-NEXT:    ldr c0, [x[[ADDR]], :lo12:.LCPI3_0]
; ARM64-NEXT:   bl __emutls_get_address
; C64-NEXT:     ldr w0, [c0]
; A64C-NEXT:    ldur w0, [c0, #0]
; ARM64-NEXT:   ldr c30, [csp], #16

entry:
  %tmp1 = load i32, i32 addrspace(200)* @i3
  ret i32 %tmp1
}

; ARM64-LABEL: .LCPI4_0
; ARM64-NEXT: .capinit __emutls_v.i3
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0

define i32 addrspace(200)* @f6() {
; ARM64-LABEL: f6:
; ARM64:        adrp x[[ADDR:[0-9]+]], .LCPI4_0
; C64-NEXT:     ldr c0, [c[[ADDR]], :lo12:.LCPI4_0]
; A64C-NEXT:    ldr c0, [x[[ADDR]], :lo12:.LCPI4_0]
; ARM64-NEXT:   bl __emutls_get_address
; ARM64-NEXT:   ldr c30, [csp], #16

entry:
  ret i32 addrspace(200)* @i3
}

; Simple test of comdat __thread variables.
; template <class T> struct A { static __thread T x; };
; template <class T> T __thread A<T>::x;
; int getIntX() { return A<int>::x++; }
; float getFloatX() { return A<float>::x++; }

$_ZN1AIiE1xE = comdat any
$_ZN1AIfE1xE = comdat any
@_ZN1AIiE1xE = linkonce_odr thread_local addrspace(200) global i32 0, comdat, align 4
@_ZN1AIfE1xE = linkonce_odr thread_local addrspace(200) global float 0.000000e+00, comdat, align 4

define i32 @_Z7getIntXv() {
; ARM64-LABEL: _Z7getIntXv:
; ARM64:        adrp x[[ADDR:[0-9]+]], :got:__emutls_v._ZN1AIiE1xE
; C64-NEXT:     ldr c0, [c[[ADDR]], :got_lo12:__emutls_v._ZN1AIiE1xE]
; A64C-NEXT:    ldr c0, [x[[ADDR]], :got_lo12:__emutls_v._ZN1AIiE1xE]
; ARM64-NEXT:   bl __emutls_get_address
; C64-NEXT  :   ldr {{.*}}, [c0]
; A64C-NEXT:    ldur {{.*}}, [c0, #0]
; ARM64:        add
; C64:          str {{.*}}, [c0]
; A64C:         stur {{.*}}, [c0, #0]

entry:
  %0 = load i32, i32 addrspace(200)* @_ZN1AIiE1xE, align 4
  %inc = add nsw i32 %0, 1
  store i32 %inc, i32 addrspace(200)* @_ZN1AIiE1xE, align 4
  ret i32 %0
}

define float @_Z9getFloatXv() {
; ARM64-LABEL: _Z9getFloatXv:
; ARM64:        adrp x[[ADDR:[0-9]+]], :got:__emutls_v._ZN1AIfE1xE
; C64-NEXT:     ldr c0, [c[[ADDR]], :got_lo12:__emutls_v._ZN1AIfE1xE]
; A64C-NEXT:    ldr c0, [x[[ADDR]], :got_lo12:__emutls_v._ZN1AIfE1xE]
; ARM64-NEXT:   bl __emutls_get_address
; C64-NEXT  :   ldr {{.*}}, [c0]
; A64C-NEXT:    ldur {{.*}}, [c0, #0]
; ARM64:        fadd s{{.*}}, s
; C64:          str {{.*}}, [c0]
; A64C:         stur {{.*}}, [c0, #0]

entry:
  %0 = load float, float addrspace(200)* @_ZN1AIfE1xE, align 4
  %inc = fadd float %0, 1.000000e+00
  store float %inc, float addrspace(200)* @_ZN1AIfE1xE, align 4
  ret float %0
}


;;;;;;;;;;;;;; __emutls_v. and __emutls_t.

; ARM64:      .data{{$}}
; ARM64:      .globl __emutls_v.i1
; ARM64-LABEL: __emutls_v.i1:
; ARM64-NEXT: .xword 4
; ARM64-NEXT: .xword 4
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .capinit __emutls_t.i1
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0

; ARM64:      .section .rodata,
; ARM64-LABEL: __emutls_t.i1:
; ARM64-NEXT: .word 15

; ARM64-NOT:   __emutls_v.i2

; ARM64:      .data{{$}}
; ARM64-NOT:  .globl
; ARM64-LABEL: __emutls_v.i3:
; ARM64-NEXT: .xword 4
; ARM64-NEXT: .xword 4
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .capinit __emutls_t.i3
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0

; ARM64:      .section .rodata,
; ARM64-LABEL: __emutls_t.i3:
; ARM64-NEXT: .word 15

; ARM64:      .hidden __emutls_v.i4
; ARM64:      .data{{$}}
; ARM64:      .globl __emutls_v.i4
; ARM64-LABEL: __emutls_v.i4:
; ARM64-NEXT: .xword 4
; ARM64-NEXT: .xword 4
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .capinit __emutls_t.i4
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0


; ARM64:      .section .rodata,
; ARM64-LABEL: __emutls_t.i4:
; ARM64-NEXT: .word 15

; ARM64-NOT:   __emutls_v.i5:
; ARM64:      .hidden __emutls_v.i5
; ARM64-NOT:   __emutls_v.i5:

; ARM64:      .data{{$}}
; ARM64:      .globl __emutls_v.s1
; ARM64-LABEL: __emutls_v.s1:
; ARM64-NEXT: .xword 2
; ARM64-NEXT: .xword 2
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .capinit __emutls_t.s1
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0

; ARM64:      .section .rodata,
; ARM64-LABEL: __emutls_t.s1:
; ARM64-NEXT: .hword 15

; ARM64:      .data{{$}}
; ARM64-LABEL: __emutls_v.b1:
; ARM64-NEXT: .xword 1
; ARM64-NEXT: .xword 1
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0

; ARM64-NOT:   __emutls_t.b1

; ARM64:      .section .data.__emutls_v._ZN1AIiE1xE,{{.*}},__emutls_v._ZN1AIiE1xE,comdat
; ARM64:      .weak __emutls_v._ZN1AIiE1xE
; ARM64:      .p2align 4
; ARM64-LABEL: __emutls_v._ZN1AIiE1xE:
; ARM64-NEXT: .xword 4
; ARM64-NEXT: .xword 4
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0

; ARM64:      .section .data.__emutls_v._ZN1AIfE1xE,{{.*}},__emutls_v._ZN1AIfE1xE,comdat
; ARM64:      .weak __emutls_v._ZN1AIfE1xE
; ARM64:      .p2align 4
; ARM64-LABEL: __emutls_v._ZN1AIfE1xE:
; ARM64-NEXT: .xword 4
; ARM64-NEXT: .xword 4
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .capinit __emutls_t._ZN1AIfE1xE
; ARM64-NEXT: .xword 0
; ARM64-NEXT: .xword 0


; ARM64:      .section .rodata.__emutls_t._ZN1AIfE1xE,{{.*}},__emutls_t._ZN1AIfE1xE,comdat
; ARM64:      .weak __emutls_t._ZN1AIfE1xE
; ARM64:      .p2align 2
; ARM64-LABEL: __emutls_t._ZN1AIfE1xE:
; ARM64-NEXT: .word 0
; ARM64-NEXT: .size
