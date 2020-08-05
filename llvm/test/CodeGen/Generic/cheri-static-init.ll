; REQUIRES: mips-registered-target
; RUN: %cheri_llc -o - %s:q
; Test that this compiles without any errors

@f = addrspace(200) global void (...) addrspace(200)* addrspacecast (void (...)* bitcast (void ()* @_none_mbrtowc to void (...)*) to void (...) addrspace(200)*), align 32

; Function Attrs: noinline nounwind
define void @_none_mbrtowc() #0 {
entry:
  ret void
}
