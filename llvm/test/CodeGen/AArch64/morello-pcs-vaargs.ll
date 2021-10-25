; RUN: llc -march=aarch64 -mattr=+morello,+c64,+use-16-cap-regs,+legacy-morello-vararg -target-abi purecap -o - %s | FileCheck %s --check-prefix=PCS16
; RUN: llc -march=aarch64 -mattr=+morello,+c64,+legacy-morello-vararg -target-abi purecap -o - %s | FileCheck %s --check-prefix=PCS32

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none-unknown-elf"


;----------------
; Generated from:
;
; int foo(int n, ...) {
;   int i;
;   int sum = 0;
;   va_list arguments;
;   va_start(arguments, n);
;   for (i = 0; i < n; ++i)
;     sum += *va_arg(arguments, int*);
;   va_end(arguments);
;   return sum;
; }
;
; Check that argument regs are passed onto
; the stack when performing variadic calls.
;
;PCS16-LABEL: foo
;
;PCS16: str c29,     [csp, #{{[0-9]+}}]
;PCS16: stp c3,  c2, [csp, #{{[0-9]+}}]
;PCS16: stp x1,  x2, [csp, #{{[0-9]+}}]
;PCS16: str c1,      [csp, #{{[0-9]+}}]
;PCS16: stp x3,  x4, [csp, #{{[0-9]+}}]
;PCS16: stp c5,  c4, [csp, #{{[0-9]+}}]
;PCS16: stp q0,  q1, [csp]
;PCS16: stp q2,  q3, [csp, #{{[0-9]+}}]
;PCS16: stp q4,  q5, [csp, #{{[0-9]+}}]
;PCS16: stp q6,  q7, [csp, #{{[0-9]+}}]
;PCS16: str x5,      [csp, #{{[0-9]+}}]
;
;PCS32-LABEL: foo
;
;PCS32: str c29,     [csp, #{{[0-9]+}}]
;PCS32: stp c3,  c2, [csp, #{{[0-9]+}}]
;PCS32: stp x1,  x2, [csp, #{{[0-9]+}}]
;PCS32: str c1,      [csp, #{{[0-9]+}}]
;PCS32: stp x3,  x4, [csp, #{{[0-9]+}}]
;PCS32: stp c5,  c4, [csp, #{{[0-9]+}}]
;PCS32: stp c7,  c6, [csp, #{{[0-9]+}}]
;PCS32: stp q0,  q1, [csp]
;PCS32: stp q2,  q3, [csp, #{{[0-9]+}}]
;PCS32: stp q4,  q5, [csp, #{{[0-9]+}}]
;PCS32: stp q6,  q7, [csp, #{{[0-9]+}}]
;PCS32: stp x5,  x6, [csp, #{{[0-9]+}}]
;PCS32: str x7,      [csp, #{{[0-9]+}}]

%struct.__va_list = type { i8 addrspace(200)*, i8 addrspace(200)*, i8 addrspace(200)*, i32, i32 }

define i32 @foo(i32 %n, ...) addrspace(200) {
entry:
  %arguments = alloca %struct.__va_list, align 16, addrspace(200)
  %0 = bitcast %struct.__va_list addrspace(200)* %arguments to i8 addrspace(200)*
  call void @llvm.lifetime.start.p200i8(i64 64, i8 addrspace(200)* nonnull %0)
  call void @llvm.va_start.p200i8(i8 addrspace(200)* nonnull %0)
  %cmp8 = icmp sgt i32 %n, 0
  br i1 %cmp8, label %for.body.lr.ph, label %for.end

for.body.lr.ph:                                   ; preds = %entry
  %gr_offs_p = getelementptr inbounds %struct.__va_list, %struct.__va_list addrspace(200)* %arguments, i64 0, i32 3
  %reg_top_p = getelementptr inbounds %struct.__va_list, %struct.__va_list addrspace(200)* %arguments, i64 0, i32 1
  %reg_top = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %reg_top_p, align 16
  %stack_p = getelementptr inbounds %struct.__va_list, %struct.__va_list addrspace(200)* %arguments, i64 0, i32 0
  %gr_offs.pre = load i32, i32 addrspace(200)* %gr_offs_p, align 16
  br label %for.body

for.body:                                         ; preds = %vaarg.end, %for.body.lr.ph
  %gr_offs = phi i32 [ %gr_offs.pre, %for.body.lr.ph ], [ %gr_offs11, %vaarg.end ]
  %sum.010 = phi i32 [ 0, %for.body.lr.ph ], [ %add, %vaarg.end ]
  %i.09 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %vaarg.end ]
  %1 = icmp sgt i32 %gr_offs, -1
  br i1 %1, label %vaarg.on_stack, label %vaarg.maybe_reg

vaarg.maybe_reg:                                  ; preds = %for.body
  %new_reg_offs = add nsw i32 %gr_offs, 8
  store i32 %new_reg_offs, i32 addrspace(200)* %gr_offs_p, align 16
  %inreg = icmp slt i32 %new_reg_offs, 1
  br i1 %inreg, label %vaarg.in_reg, label %vaarg.on_stack

vaarg.in_reg:                                     ; preds = %vaarg.maybe_reg
  %cap_neg_unscaled_reg_offs = shl i32 %gr_offs, 1
  %cap_neg_scaled_reg_offs = sub i32 -16, %cap_neg_unscaled_reg_offs
  %2 = sext i32 %cap_neg_scaled_reg_offs to i64
  %3 = getelementptr inbounds i8, i8 addrspace(200)* %reg_top, i64 %2
  br label %vaarg.end

vaarg.on_stack:                                   ; preds = %vaarg.maybe_reg, %for.body
  %gr_offs12 = phi i32 [ %new_reg_offs, %vaarg.maybe_reg ], [ %gr_offs, %for.body ]
  %stack = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %stack_p, align 16
  %4 = call i64 @llvm.cheri.cap.address.get.i64(i8 addrspace(200)* %stack)
  %align_stack = add i64 %4, 15
  %align_stack2 = and i64 %align_stack, -16
  %5 = call i8 addrspace(200)* @llvm.cheri.cap.address.set.i64(i8 addrspace(200)* %stack, i64 %align_stack2)
  %new_stack = getelementptr inbounds i8, i8 addrspace(200)* %5, i64 16
  store i8 addrspace(200)* %new_stack, i8 addrspace(200)* addrspace(200)* %stack_p, align 16
  br label %vaarg.end

vaarg.end:                                        ; preds = %vaarg.on_stack, %vaarg.in_reg
  %gr_offs11 = phi i32 [ %new_reg_offs, %vaarg.in_reg ], [ %gr_offs12, %vaarg.on_stack ]
  %vaargs.addr.in = phi i8 addrspace(200)* [ %3, %vaarg.in_reg ], [ %5, %vaarg.on_stack ]
  %vaargs.addr = bitcast i8 addrspace(200)* %vaargs.addr.in to i32 addrspace(200)* addrspace(200)*
  %6 = load i32 addrspace(200)*, i32 addrspace(200)* addrspace(200)* %vaargs.addr, align 16
  %7 = load i32, i32 addrspace(200)* %6, align 4
  %add = add nsw i32 %7, %sum.010
  %inc = add nuw nsw i32 %i.09, 1
  %exitcond = icmp eq i32 %inc, %n
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %vaarg.end, %entry
  %sum.0.lcssa = phi i32 [ 0, %entry ], [ %add, %vaarg.end ]
  call void @llvm.va_end.p200i8(i8 addrspace(200)* nonnull %0)
  call void @llvm.lifetime.end.p200i8(i64 64, i8 addrspace(200)* nonnull %0)
  ret i32 %sum.0.lcssa
}

declare void @llvm.lifetime.start.p200i8(i64 immarg, i8 addrspace(200)*) addrspace(200)

declare void @llvm.va_start.p200i8(i8 addrspace(200)*) addrspace(200)

declare i64 @llvm.cheri.cap.address.get.i64(i8 addrspace(200)*) addrspace(200)

declare i8 addrspace(200)* @llvm.cheri.cap.address.set.i64(i8 addrspace(200)*, i64) addrspace(200)

declare void @llvm.va_end.p200i8(i8 addrspace(200)*) addrspace(200)

declare void @llvm.lifetime.end.p200i8(i64 immarg, i8 addrspace(200)*) addrspace(200)

declare i8 addrspace(200)* @llvm.cheri.cap.offset.increment.i64(i8 addrspace(200)*, i64) addrspace(200)
