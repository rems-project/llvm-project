  .data
funcptr1:
  .chericap func
  .size funcptr1, 16

funcptr2:
  .chericap func
  .size funcptr2, 16

ifuncptr:
  .chericap ifunc
  .size ifuncptr, 16

  .global func
  .type func,%function
  .section function,"ax",%progbits
func:
  ret
  .size func, .-func

  .globl ifunc
  .type ifunc,STT_GNU_IFUNC
  .section ifunction,"ax",%progbits
ifunc:
  ret
  .size ifunc, .-ifunc
