add_lldb_unittest(LLDBFormatterTests
  FormatManagerTests.cpp
  FormattersContainerTest.cpp
  StringPrinterTests.cpp

  LINK_LIBS
    lldbTarget
    lldbCore
    lldbInterpreter
    lldbSymbol
    lldbUtility

  LINK_COMPONENTS
    Support
  )
