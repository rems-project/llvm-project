  .global foo
  .section .tdata,"awT",%progbits
  .type foo, %function
foo:
  .word 42
  .size foo, . - foo

.text
