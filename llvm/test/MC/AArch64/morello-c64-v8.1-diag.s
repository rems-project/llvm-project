// RUN: not llvm-mc -triple aarch64-none-linux-gnu -mattr=+v8.1a,+c64,+lse -show-encoding < %s 2> %t
// RUN: FileCheck < %t %s
// RUN: not llvm-mc -triple aarch64-none-linux-gnu -mattr=+v8.1a,+c64,+lse,+morello -show-encoding < %s 2> %t
// RUN: FileCheck < %t %s
  .text

  cas w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  cas w0, w1, [x2]

  casb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  casb w0, w1, [x2]

  casalb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  casalb w0, w1, [x2]

  cas x0, x1, [x2]
// CHECK:: error: invalid operand for instruction
// CHECK-NEXT:  cas x0, x1, [x2]

  swp w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  swp w0, w1, [x2]

  swpb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  swpb w0, w1, [x2]

  swpalb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  swpalb w0, w1, [x2]

  swp x0, x1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  swp x0, x1, [x2]

  casp w0, w1, w2, w3, [x5]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  casp w0, w1, w2, w3, [x5]

  caspl w0, w1, w2, w3, [x5]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  caspl w0, w1, w2, w3, [x5]

  ldadd w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldadd w0, w1, [x2]

  ldaddb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT  ldaddb w0, w1, [x2]

  ldaddalb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldaddalb w0, w1, [x2]

  ldadd x0, x1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldadd x0, x1, [x2]

  ldclr w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldclr w0, w1, [x2]

  ldclrb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldclrb w0, w1, [x2]

  ldclralb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldclralb w0, w1, [x2]

  ldclr x0, x1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldclr x0, x1, [x2]

  ldeor w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldeor w0, w1, [x2]

  ldeorb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldeorb w0, w1, [x2]

  ldeoralb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldeoralb w0, w1, [x2]

  ldeor x0, x1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldeor x0, x1, [x2]

  ldset w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldset w0, w1, [x2]

  ldsetb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldsetb w0, w1, [x2]

  ldsetalb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldsetalb w0, w1, [x2]

  ldset x0, x1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldset x0, x1, [x2]

  ldsmax w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldsmax w0, w1, [x2]

  ldsmaxb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldsmaxb w0, w1, [x2]

  ldsmaxalb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT  ldsmaxalb w0, w1, [x2]

  ldsmax x0, x1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldsmax x0, x1, [x2]

  ldsmin w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldsmin w0, w1, [x2]

  ldsminb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldsminb w0, w1, [x2]

  ldsminalb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldsminalb w0, w1, [x2]

  ldsmin x0, x1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldsmin x0, x1, [x2]

  ldumax w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldumax w0, w1, [x2]

  ldumaxb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldumaxb w0, w1, [x2]

  ldumaxalb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldumaxalb w0, w1, [x2]

  ldumax x0, x1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldumax x0, x1, [x2]

  ldumin w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldumin w0, w1, [x2]

  lduminb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  lduminb w0, w1, [x2]

  lduminalb w0, w1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  lduminalb w0, w1, [x2]

  ldumin x0, x1, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  ldumin x0, x1, [x2]

  stadd w0, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  stadd w0, [x2]

  staddlb w0, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  staddlb w0, [x2]

  stclr w0, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  stclr w0, [x2]

  stclrlb w0, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  stclrlb w0, [x2]

  steor w0, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  steor w0, [x2]

  steorlb w0, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  steorlb w0, [x2]

  stset w0, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT  stset w0, [x2]

  stsetlb w0, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  stsetlb w0, [x2]

  stsmax w0, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  stsmax w0, [x2]

  stsmaxlb w0, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  stsmaxlb w0, [x2]

  stsmin w0, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  stsmin w0, [x2]

  stsminlb w0, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  stsminlb w0, [x2]

  stumax w0, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  stumax w0, [x2]

  stumaxlb w0, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  stumaxlb w0, [x2]

  stumin w0, [x2]
// CHECK: error: invalid operand for instruction
// CHECK-NEXT:  stumin w0, [x2]
