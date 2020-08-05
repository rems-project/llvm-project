if("ARM" IN_LIST LLVM_TARGETS_TO_BUILD)
  add_subdirectory(ARM)
endif()

if("AArch64" IN_LIST LLVM_TARGETS_TO_BUILD)
  add_subdirectory(ARM64)
endif()
