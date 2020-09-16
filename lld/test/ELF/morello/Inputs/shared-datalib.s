 .text
 .global from_app

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
