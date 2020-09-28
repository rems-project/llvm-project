; RUN: llc -verify-machineinstrs -o - %s -mtriple=aarch64-linux-gnu -mattr=+c64,+morello -target-abi purecap | FileCheck %s

; CHECK-LABEL: ld_8bit_X
; CHECK: ldrb w0, [c0, x1]
define i32 @ld_8bit_X(i8 addrspace(200) * %addr, i64 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 %ld = load i8, i8 addrspace(200) * %newaddr
 %ext = zext i8 %ld to i32
 ret i32 %ext
}

; CHECK-LABEL: ld_8bit_anyext_x
; CHECK: ldrb w0, [c0, x1]
define i8 @ld_8bit_anyext_x(i8 addrspace(200) * %addr, i64 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 %ld = load i8, i8 addrspace(200) * %newaddr
 ret i8 %ld
}

; CHECK: ld_8bit_anyext_w
; CHECK: ldrb w0, [c0, w1, sxtw]
define i8 @ld_8bit_anyext_w(i8 addrspace(200) * %addr, i32 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i32 %offset
 %ld = load i8, i8 addrspace(200) * %newaddr
 ret i8 %ld
}

; CHECK-LABEL: ld_1bit_anyext_x
; CHECK: ldrb w0, [c0, x1]
define i1 @ld_1bit_anyext_x(i1 addrspace(200) * %addr, i64 %offset) {
 %newaddr = getelementptr i1, i1 addrspace(200)* %addr, i64 %offset
 %ld = load i1, i1 addrspace(200) * %newaddr
 ret i1 %ld
}

; CHECK-LABEL: ld_1bit_anyext_w
; CHECK: ldrb w0, [c0, w1, uxtw]
define i1 @ld_1bit_anyext_w(i1 addrspace(200) * %addr, i32 %offset) {
 %newoffset = zext i32 %offset to i64
 %newaddr = getelementptr i1, i1 addrspace(200)* %addr, i64 %newoffset
 %ld = load i1, i1 addrspace(200) * %newaddr
 ret i1 %ld
}

; CHECK-LABEL: ld_8bit_W_sxtw
; CHECK: ldrb w0, [c0, w1, sxtw]
define i32 @ld_8bit_W_sxtw(i8 addrspace(200) * %addr, i32 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i32 %offset
 %ld = load i8, i8 addrspace(200) * %newaddr
 %ext = zext i8 %ld to i32
 ret i32 %ext
}

; CHECK-LABEL: ld_8bit_W_uxtw
; CHECK: ldrb w0, [c0, w1, uxtw]
define i32 @ld_8bit_W_uxtw(i8 addrspace(200) * %addr, i32 %offset) {
 %offset1 = zext i32 %offset to i64
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset1
 %ld = load i8, i8 addrspace(200) * %newaddr
 %ext = zext i8 %ld to i32
 ret i32 %ext
}

; CHECK-LABEL: ld_8bit_sext_X
; CHECK: ldrsb w0, [c0, x1]
define i32 @ld_8bit_sext_X(i8 addrspace(200) * %addr, i64 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 %ld = load i8, i8 addrspace(200) * %newaddr
 %ext = sext i8 %ld to i32
 ret i32 %ext
}

; CHECK-LABEL: ld_8bit_sext_W_sxtw
; CHECK: ldrsb w0, [c0, w1, sxtw]
define i32 @ld_8bit_sext_W_sxtw(i8 addrspace(200) * %addr, i32 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i32 %offset
 %ld = load i8, i8 addrspace(200) * %newaddr
 %ext = sext i8 %ld to i32
 ret i32 %ext
}

; CHECK-LABEL: ld_8bit_sext_W_uxtw
; CHECK: ldrsb w0, [c0, w1, uxtw]
define i32 @ld_8bit_sext_W_uxtw(i8 addrspace(200) * %addr, i32 %offset) {
 %offset1 = zext i32 %offset to i64
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset1
 %ld = load i8, i8 addrspace(200) * %newaddr
 %ext = sext i8 %ld to i32
 ret i32 %ext
}

; CHECK-LABEL: ld_i16_sext_w_shift_sext
; CHECK: ldrsh	w0, [c0, w1, sxtw #1]
define i32 @ld_i16_sext_w_shift_sext(i16 addrspace(200)* %addr, i32 %offset) {
 %newaddr = getelementptr i16, i16 addrspace(200)* %addr, i32 %offset
 %ld = load i16, i16 addrspace(200) * %newaddr
 %ext = sext i16 %ld to i32
 ret i32 %ext
}

; CHECK-LABEL: ld_i16_sext_w_noshift_zext_64
; CHECK: ldrsh	x0, [c0, w1, uxtw]
define i64 @ld_i16_sext_w_noshift_zext_64(i8 addrspace(200)* %addr, i32 %offset) {
 %newoffset = zext i32 %offset to i64
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %newoffset
 %castaddr = bitcast i8 addrspace(200) * %newaddr to i16 addrspace(200) *
 %ld = load i16, i16 addrspace(200) * %castaddr
 %ext = sext i16 %ld to i64
 ret i64 %ext
}

; CHECK-LABEL: ld_i16_zext_w_noshift_zext_64
; CHECK: ldrh	w0, [c0, w1, uxtw]
define i64 @ld_i16_zext_w_noshift_zext_64(i8 addrspace(200)* %addr, i32 %offset) {
 %newoffset = zext i32 %offset to i64
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %newoffset
 %castaddr = bitcast i8 addrspace(200) * %newaddr to i16 addrspace(200) *
 %ld = load i16, i16 addrspace(200) * %castaddr
 %ext = zext i16 %ld to i64
 ret i64 %ext
}

; CHECK-LABEL: ld_i16_anyext_w_noshift_sext
; CHECK: ldrh	w0, [c0, w1, sxtw]
define i16 @ld_i16_anyext_w_noshift_sext(i8 addrspace(200)* %addr, i32 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i32 %offset
 %castaddr = bitcast i8 addrspace(200) * %newaddr to i16 addrspace(200) *
 %ld = load i16, i16 addrspace(200) * %castaddr
 ret i16 %ld
}

; CHECK-LABEL: ld_i32_sext_w_noshift_zext_64
; CHECK: ldrsw	x0, [c0, w1, uxtw]
define i64 @ld_i32_sext_w_noshift_zext_64(i8 addrspace(200)* %addr, i32 %offset) {
 %newoffset = zext i32 %offset to i64
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %newoffset
 %castaddr = bitcast i8 addrspace(200) * %newaddr to i32 addrspace(200) *
 %ld = load i32, i32 addrspace(200) * %castaddr
 %ext = sext i32 %ld to i64
 ret i64 %ext
}

; CHECK-LABEL: ld_i32_zext_w_noshift_zext_64
; CHECK: ldr	w0, [c0, w1, uxtw]
define i64 @ld_i32_zext_w_noshift_zext_64(i8 addrspace(200)* %addr, i32 %offset) {
 %newoffset = zext i32 %offset to i64
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %newoffset
 %castaddr = bitcast i8 addrspace(200) * %newaddr to i32 addrspace(200) *
 %ld = load i32, i32 addrspace(200) * %castaddr
 %ext = zext i32 %ld to i64
 ret i64 %ext
}

; CHECK-LABEL: ld_i32_anyext_w_shift_sext
; CHECK: ldr	w0, [c0, w1, sxtw #2]
define i32 @ld_i32_anyext_w_shift_sext(i32 addrspace(200)* %addr, i32 %offset) {
 %newaddr = getelementptr i32, i32 addrspace(200)* %addr, i32 %offset
 %ld = load i32, i32 addrspace(200) * %newaddr
 ret i32 %ld
}

; CHECK-LABEL: ld_i64_w_shift_sext
; CHECK: ldr	x0, [c0, w1, sxtw #3]
define i64 @ld_i64_w_shift_sext(i64 addrspace(200)* %addr, i32 %offset) {
 %newaddr = getelementptr i64, i64 addrspace(200)* %addr, i32 %offset
 %ld = load i64, i64 addrspace(200) * %newaddr
 ret i64 %ld
}

; CHECK-LABEL: ld_half_x_shift_zext
; CHECK: ldr	h0, [c0, x1, lsl #1]
define half @ld_half_x_shift_zext(half addrspace(200)* %addr, i64 %offset) {
 %newaddr = getelementptr half, half addrspace(200)* %addr, i64 %offset
 %ld = load half, half addrspace(200) * %newaddr
 ret half %ld
}

; CHECK-LABEL: ld_float_x_shift_zext
; CHECK: ldr	s0, [c0, w1, sxtw]
define float @ld_float_x_shift_zext(i8 addrspace(200)* %addr, i32 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i32 %offset
 %caddr = bitcast i8 addrspace(200) * %newaddr to float addrspace(200) *
 %ld = load float, float addrspace(200) * %caddr
 ret float %ld
}

; CHECK-LABEL: ld_double_x_shift_zext
; CHECK: ldr	d0, [c0, x1]
define double @ld_double_x_shift_zext(i8 addrspace(200)* %addr, i64 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 %caddr = bitcast i8 addrspace(200) * %newaddr to double addrspace(200) *
 %ld = load double, double addrspace(200) * %caddr
 ret double %ld
}

; Test all vector types
; Integers

; CHECK-LABEL: ld_v4i16
; CHECK: ldr	d0, [c0, x1]
define <4 x i16> @ld_v4i16(i8 addrspace(200)* %addr, i64 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 %caddr = bitcast i8 addrspace(200) * %newaddr to <4 x i16> addrspace(200) *
 %ld = load <4 x i16>, <4 x i16> addrspace(200) * %caddr
 ret <4 x i16> %ld
}

; CHECK-LABEL: ld_v8i16
; CHECK: ldr	q0, [c0, x1]
define <8 x i16> @ld_v8i16(i8 addrspace(200)* %addr, i64 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 %caddr = bitcast i8 addrspace(200) * %newaddr to <8 x i16> addrspace(200) *
 %ld = load <8 x i16>, <8 x i16> addrspace(200) * %caddr
 ret <8 x i16> %ld
}

; CHECK-LABEL: ld_v2i32
; CHECK: ldr	d0, [c0, x1]
define <2 x i32> @ld_v2i32(i8 addrspace(200)* %addr, i64 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 %caddr = bitcast i8 addrspace(200) * %newaddr to <2 x i32> addrspace(200) *
 %ld = load <2 x i32>, <2 x i32> addrspace(200) * %caddr
 ret <2 x i32> %ld
}

; CHECK-LABEL: ld_v4i32
; CHECK: ldr	q0, [c0, x1]
define <4 x i32> @ld_v4i32(i8 addrspace(200)* %addr, i64 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 %caddr = bitcast i8 addrspace(200) * %newaddr to <4 x i32> addrspace(200) *
 %ld = load <4 x i32>, <4 x i32> addrspace(200) * %caddr
 ret <4 x i32> %ld
}

; CHECK-LABEL: ld_v2i64
; CHECK: ldr	q0, [c0, x1]
define <2 x i64> @ld_v2i64(i8 addrspace(200)* %addr, i64 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 %caddr = bitcast i8 addrspace(200) * %newaddr to <2 x i64> addrspace(200) *
 %ld = load <2 x i64>, <2 x i64> addrspace(200) * %caddr
 ret <2 x i64> %ld
}

; Floating point

; CHECK-LABEL: ld_v4f16
; CHECK: ldr	d0, [c0, x1]
define <4 x half> @ld_v4f16(i8 addrspace(200)* %addr, i64 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 %caddr = bitcast i8 addrspace(200) * %newaddr to <4 x half> addrspace(200) *
 %ld = load <4 x half>, <4 x half> addrspace(200) * %caddr
 ret <4 x half> %ld
}

; CHECK-LABEL: ld_v8f16
; CHECK: ldr	q0, [c0, x1]
define <8 x half> @ld_v8f16(i8 addrspace(200)* %addr, i64 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 %caddr = bitcast i8 addrspace(200) * %newaddr to <8 x half> addrspace(200) *
 %ld = load <8 x half>, <8 x half> addrspace(200) * %caddr
 ret <8 x half> %ld
}

; CHECK-LABEL: ld_v2f32
; CHECK: ldr	d0, [c0, x1]
define <2 x float> @ld_v2f32(i8 addrspace(200)* %addr, i64 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 %caddr = bitcast i8 addrspace(200) * %newaddr to <2 x float> addrspace(200) *
 %ld = load <2 x float>, <2 x float> addrspace(200) * %caddr
 ret <2 x float> %ld
}

; CHECK-LABEL: ld_v4f32
; CHECK: ldr	q0, [c0, x1]
define <4 x float> @ld_v4f32(i8 addrspace(200)* %addr, i64 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 %caddr = bitcast i8 addrspace(200) * %newaddr to <4 x float> addrspace(200) *
 %ld = load <4 x float>, <4 x float> addrspace(200) * %caddr
 ret <4 x float> %ld
}

; CHECK-LABEL: ld_v2f64
; CHECK: ldr	q0, [c0, x1]
define <2 x double> @ld_v2f64(i8 addrspace(200)* %addr, i64 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 %caddr = bitcast i8 addrspace(200) * %newaddr to <2 x double> addrspace(200) *
 %ld = load <2 x double>, <2 x double> addrspace(200) * %caddr
 ret <2 x double> %ld
}


; Stores

; CHECK-LABEL: st_8bit_X
; CHECK: strb w2, [c0, x1]
define void @st_8bit_X(i8 addrspace(200) * %addr, i64 %offset, i8 %val) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 store i8 %val, i8 addrspace(200) * %newaddr
 ret void
}

; CHECK-LABEL: st_8bit_anyext_x
; CHECK: strb w2, [c0, x1]
define void @st_8bit_anyext_x(i8 addrspace(200) * %addr, i64 %offset, i32 %val) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 %newval = trunc i32 %val to i8
 store i8 %newval, i8 addrspace(200) * %newaddr
 ret void
}

; CHECK-LABEL: st_8bit_anyext_x_64
; CHECK: strb w2, [c0, x1]
define void @st_8bit_anyext_x_64(i8 addrspace(200) * %addr, i64 %offset, i64 %val) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 %newval = trunc i64 %val to i8
 store i8 %newval, i8 addrspace(200) * %newaddr
 ret void
}

; CHECK-LABEL: st_8bit_anyext_w
; CHECK: strb w1, [c0, w1, sxtw]
define void @st_8bit_anyext_w(i8 addrspace(200) * %addr, i32 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i32 %offset
 %new = trunc i32 %offset to i8
 store i8 %new, i8 addrspace(200) * %newaddr
 ret void
}

; CHECK-LABEL: st_8bit_W_uxtw
; CHECK: strb w1, [c0, w1, uxtw]
define void @st_8bit_W_uxtw(i8 addrspace(200) * %addr, i32 %offset) {
 %offset1 = zext i32 %offset to i64
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset1
 %tr = trunc i32 %offset to i8
 store i8 %tr, i8 addrspace(200) * %newaddr
 ret void
}

; CHECK-LABEL: st_8bit_sext_W_sxtw
; CHECK: strb w1, [c0, w1, sxtw]
define void @st_8bit_sext_W_sxtw(i8 addrspace(200) * %addr, i32 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i32 %offset
 %tr = trunc i32 %offset to i8
 store i8 %tr, i8 addrspace(200) * %newaddr
 ret void
}

; CHECK-LABEL: st_i16_sext_w_noshift
; CHECK: strh w1, [c0, w1, sxtw]
define void @st_i16_sext_w_noshift(i8 addrspace(200) * %addr, i32 %offset) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i32 %offset
 %castaddr = bitcast i8 addrspace(200) * %newaddr to i16 addrspace(200) *
 %tr = trunc i32 %offset to i16
 store i16 %tr, i16 addrspace(200) * %castaddr
 ret void
}

; CHECK-LABEL: st_i32_zext_w_shift
; CHECK: str w1, [c0, w1, uxtw #2]
define void @st_i32_zext_w_shift(i32 addrspace(200) * %addr, i32 %offset) {
 %newoff = zext i32 %offset to i64
 %newaddr = getelementptr i32, i32 addrspace(200)* %addr, i64 %newoff
 store i32 %offset, i32 addrspace(200) * %newaddr
 ret void
}

; CHECK-LABEL: st_i64_zext_x_shift
; CHECK: str x1, [c0, x1, lsl #3]
define void @st_i64_zext_x_shift(i64 addrspace(200) * %addr, i64 %offset) {
 %newaddr = getelementptr i64, i64 addrspace(200)* %addr, i64 %offset
 store i64 %offset, i64 addrspace(200) * %newaddr
 ret void
}

; CHECK-LABEL: st_f16_sext_w_noshift
; CHECK: str h0, [c0, w1, sxtw]
define void @st_f16_sext_w_noshift(i8 addrspace(200) * %addr, i32 %offset,
                                   half %val) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i32 %offset
 %castaddr = bitcast i8 addrspace(200) * %newaddr to half addrspace(200) *
 store half %val, half addrspace(200) * %castaddr
 ret void
}

; CHECK-LABEL: st_f32_zext_x_noshift
; CHECK: str s0, [c0, x1]
define void @st_f32_zext_x_noshift(i8 addrspace(200) * %addr, i64 %offset,
                                   float %val) {
 %newaddr = getelementptr i8, i8 addrspace(200)* %addr, i64 %offset
 %castaddr = bitcast i8 addrspace(200) * %newaddr to float addrspace(200) *
 store float %val, float addrspace(200) * %castaddr
 ret void
}

; CHECK-LABEL: st_f64_zext_x_shift
; CHECK: str d0, [c0, x1, lsl #3]
define void @st_f64_zext_x_shift(double addrspace(200) * %addr, i64 %offset,
                                   double %val) {
 %newaddr = getelementptr double, double addrspace(200)* %addr, i64 %offset
 store double %val, double addrspace(200) * %newaddr
 ret void
}

; Test the different vector types

; CHECK-LABEL: st_v4i16_zext_x_shift
; CHECK: str d0, [c0, x1, lsl #3]
define void @st_v4i16_zext_x_shift(<4 x i16> addrspace(200) * %addr, i64 %offset,
                                   <4 x i16> %val) {
 %newaddr = getelementptr <4 x i16>, <4 x i16> addrspace(200)* %addr, i64 %offset
 store <4 x i16> %val, <4 x i16> addrspace(200) * %newaddr
 ret void
}

; CHECK-LABEL: st_v8i16_zext_x_shift
; CHECK: str q0, [c0, x1, lsl #4]
define void @st_v8i16_zext_x_shift(<8 x i16> addrspace(200) * %addr, i64 %offset,
                                   <8 x i16> %val) {
 %newaddr = getelementptr <8 x i16>, <8 x i16> addrspace(200)* %addr, i64 %offset
 store <8 x i16> %val, <8 x i16> addrspace(200) * %newaddr
 ret void
}

; CHECK-LABEL: st_v2i32_zext_x_shift
; CHECK: str d0, [c0, x1, lsl #3]
define void @st_v2i32_zext_x_shift(<2 x i32> addrspace(200) * %addr, i64 %offset,
                                   <2 x i32> %val) {
 %newaddr = getelementptr <2 x i32>, <2 x i32> addrspace(200)* %addr, i64 %offset
 store <2 x i32> %val, <2 x i32> addrspace(200) * %newaddr
 ret void
}

; CHECK-LABEL: st_v4i32_zext_x_shift
; CHECK: str q0, [c0, x1, lsl #4]
define void @st_v4i32_zext_x_shift(<4 x i32> addrspace(200) * %addr, i64 %offset,
                                   <4 x i32> %val) {
 %newaddr = getelementptr <4 x i32>, <4 x i32> addrspace(200)* %addr, i64 %offset
 store <4 x i32> %val, <4 x i32> addrspace(200) * %newaddr
 ret void
}

; CHECK-LABEL: st_v2i64_zext_x_shift
; CHECK: str q0, [c0, x1, lsl #4]
define void @st_v2i64_zext_x_shift(<2 x i64> addrspace(200) * %addr, i64 %offset,
                                   <2 x i64> %val) {
 %newaddr = getelementptr <2 x i64>, <2 x i64> addrspace(200)* %addr, i64 %offset
 store <2 x i64> %val, <2 x i64> addrspace(200) * %newaddr
 ret void
}

; Test vectors with floating point types

; CHECK-LABEL: st_v4f16_zext_x_shift
; CHECK: str d0, [c0, x1, lsl #3]
define void @st_v4f16_zext_x_shift(<4 x half> addrspace(200) * %addr, i64 %offset,
                                   <4 x half> %val) {
 %newaddr = getelementptr <4 x half>, <4 x half> addrspace(200)* %addr, i64 %offset
 store <4 x half> %val, <4 x half> addrspace(200) * %newaddr
 ret void
}

; CHECK-LABEL: st_v8f16_zext_x_shift
; CHECK: str q0, [c0, x1, lsl #4]
define void @st_v8f16_zext_x_shift(<8 x half> addrspace(200) * %addr, i64 %offset,
                                   <8 x half> %val) {
 %newaddr = getelementptr <8 x half>, <8 x half> addrspace(200)* %addr, i64 %offset
 store <8 x half> %val, <8 x half> addrspace(200) * %newaddr
 ret void
}

; CHECK-LABEL: st_v2f32_zext_x_shift
; CHECK: str d0, [c0, x1, lsl #3]
define void @st_v2f32_zext_x_shift(<2 x float> addrspace(200) * %addr, i64 %offset,
                                   <2 x float> %val) {
 %newaddr = getelementptr <2 x float>, <2 x float> addrspace(200)* %addr, i64 %offset
 store <2 x float> %val, <2 x float> addrspace(200) * %newaddr
 ret void
}

; CHECK-LABEL: st_v4f32_zext_x_shift
; CHECK: str q0, [c0, x1, lsl #4]
define void @st_v4f32_zext_x_shift(<4 x float> addrspace(200) * %addr, i64 %offset,
                                   <4 x float> %val) {
 %newaddr = getelementptr <4 x float>, <4 x float> addrspace(200)* %addr, i64 %offset
 store <4 x float> %val, <4 x float> addrspace(200) * %newaddr
 ret void
}

; CHECK-LABEL: st_v2f64_zext_x_shift
; CHECK: str q0, [c0, x1, lsl #4]
define void @st_v2f64_zext_x_shift(<2 x double> addrspace(200) * %addr, i64 %offset,
                                   <2 x double> %val) {
 %newaddr = getelementptr <2 x double>, <2 x double> addrspace(200)* %addr, i64 %offset
 store <2 x double> %val, <2 x double> addrspace(200) * %newaddr
 ret void
}
