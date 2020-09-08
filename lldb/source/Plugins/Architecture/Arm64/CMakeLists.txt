add_lldb_library(lldbPluginArchitectureArm64 PLUGIN
  ArchitectureArm64.cpp

  LINK_LIBS
    lldbPluginProcessUtility
    lldbCore
    lldbTarget
    lldbUtility
  LINK_COMPONENTS
    Support
  )
