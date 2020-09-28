; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+c64,+morello -target-abi purecap -aarch64-enable-atomic-cfg-tidy=0 -verify-machineinstrs < %s | FileCheck %s

@addr = global i8* blockaddress(@test_blockaddress, %block)

define void @test_blockaddress() {
; CHECK-LABEL: test_blockaddress:
  store volatile i8* blockaddress(@test_blockaddress, %block), i8** @addr
  %val = load volatile i8*, i8** @addr
  indirectbr i8* %val, [label %block]
; CHECK: adrp [[DEST_HI:c[0-9]+]], [[DEST_LBL:.Ltmp[0-9]+]]
; CHECK: add [[DEST:c[0-9]+]], [[DEST_HI]], {{#?}}:lo12:[[DEST_LBL]]+1
; CHECK: gcvalue [[DESTVAL:x[0-9]+]], [[DEST]]
; CHECK: stur [[DESTVAL]],
; CHECK: ldur [[NEWDEST:x[0-9]+]]
; CHECK: br [[NEWDEST]]

block:
  ret void
}

; CHECK-LABEL: addr:
; CHECK-NEXT:	.xword	.Ltmp0+1
