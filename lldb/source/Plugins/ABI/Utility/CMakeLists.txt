add_lldb_library(lldbPluginABIUtility
  LinuxSigInfo.cpp

  LINK_LIBS
    lldbCore
    lldbSymbol
    lldbTarget
    lldbPluginTypeSystemClang
  LINK_COMPONENTS
    Support
  )
