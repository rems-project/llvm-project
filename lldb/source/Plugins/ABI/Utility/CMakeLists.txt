add_lldb_library(lldbPluginABIUtility PLUGIN
  LinuxSigInfo.cpp

  LINK_LIBS
    lldbCore
    lldbSymbol
    lldbTarget
  LINK_COMPONENTS
    Support
  )
