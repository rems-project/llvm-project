.text
.globl func2
.type func2,@function
func2:
  .globl func
  .type func, @function
  .globl _start
  .type _start, @function
  bl func
  b _start
  ret
