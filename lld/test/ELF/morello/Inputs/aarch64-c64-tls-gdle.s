  .global bar
  .global foo
  .section .tdata,"awT",%progbits
  .align 2
  .type bar, %object
bar:
  .space 0x00FEED00
  .size bar, . - bar

  .type foo, %object
foo:
  .space 0x00BEEF00
  .size foo, . - foo

  .text
