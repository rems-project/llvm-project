// RUN: not llvm-mc -triple aarch64-none-linux-gnu -show-encoding -mattr=+v8.2a,+rcpc-immo,+c64,+rcpc < %s 2>&1 | FileCheck %s
// RUN: not llvm-mc -triple aarch64-none-linux-gnu -show-encoding -mattr=+v8.2a,+rcpc-immo,+c64,+morello,+rcpc < %s 2>&1 | FileCheck %s


  ldaprb w0, [x0, #0]
  ldaprh w0, [x17, #0]
  ldapr w0, [x1, #0]
  ldapr x0, [x0, #0]
  ldapr w18, [x0]
  ldapr x15, [x0]

// CHECK: error: invalid operand for instruction
// CHECK: error: invalid operand for instruction
// CHECK: error: invalid operand for instruction
// CHECK: error: invalid operand for instruction
// CHECK: error: invalid operand for instruction
// CHECK: error: invalid operand for instruction

stlurb   w2, [x11, #100]
ldapurb  w4, [x12]
ldapursb w9, [sp, #-1]
ldapursb x2, [sp, #0]
stlurh   w10, [x18, #-100]
ldapurh  w14, [x21, #100]

// CHECK: error: unrecognized instruction mnemonic
// CHECK: error: unrecognized instruction mnemonic
// CHECK: error: unrecognized instruction mnemonic
// CHECK: error: unrecognized instruction mnemonic
// CHECK: error: unrecognized instruction mnemonic
// CHECK: error: unrecognized instruction mnemonic

ldapursh w18, [sp, #3]
ldapursh x3, [x24, #-100]
stlur    w20, [x27, #100]
ldapur   w24, [sp, #6]
ldapursw x6, [x30, #-100]
stlur    x10, [x2, #100]
ldapur   x14, [sp, #9]

// CHECK: error: unrecognized instruction mnemonic
// CHECK: error: unrecognized instruction mnemonic
// CHECK: error: unrecognized instruction mnemonic
// CHECK: error: unrecognized instruction mnemonic
// CHECK: error: unrecognized instruction mnemonic
// CHECK: error: unrecognized instruction mnemonic
// CHECK: error: unrecognized instruction mnemonic
