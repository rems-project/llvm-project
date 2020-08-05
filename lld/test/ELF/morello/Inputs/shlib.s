 .text
 .global from_app
 .global func
 .type func, %function
 .size func, 16
func:
 adrp c0, :got: from_app
 ldr c0, [c0, :got_lo12: from_app]
 nop
 ret

 .global func2
 .type func2, %function
 .size func2, 4
func2:   ret

 .global rodata
 .size rodata, 8
 .type rodata, %object
 .rodata
rodata:
 .xword 1

 .global data
 .type data,%object
 .size data, 8
 .data
data:
 .xword 2
