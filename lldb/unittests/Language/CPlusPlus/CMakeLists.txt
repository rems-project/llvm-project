add_lldb_unittest(LanguageCPlusPlusTests
  CPlusPlusLanguageTest.cpp

  LINK_LIBS
    lldbPluginCPlusPlusLanguage
  LINK_COMPONENTS
    RuntimeDyld
  )
