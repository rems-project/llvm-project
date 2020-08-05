  .section .text.2, "ax", %progbits
  .global func
  .type func, %function
  .size func, 4
func:
  b  far_away
  bl far_away


  .section .text.3, "ax", %progbits
  .global far_away
  .type far_away, %function
  .size far_away, 4
far_away:
  ret
