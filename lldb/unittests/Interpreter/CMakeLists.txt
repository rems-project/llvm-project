add_lldb_unittest(InterpreterTests
  TestCommandPaths.cpp
  TestCompletion.cpp
  TestOptionArgParser.cpp
  TestOptionValue.cpp
  TestOptionValueFileColonLine.cpp

  LINK_LIBS
      lldbCore
      lldbHost
      lldbTarget
      lldbSymbol
      lldbUtility
      lldbUtilityHelpers
      lldbInterpreter
      lldbPluginPlatformMacOSX

  LINK_COMPONENTS
      RuntimeDyld
)
