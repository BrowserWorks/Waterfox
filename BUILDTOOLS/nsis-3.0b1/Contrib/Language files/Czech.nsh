;Language: Czech (1029)
;By Václav Pavlíček (v.pavlicek@centrum.cz), dříve SELiCE

!insertmacro LANGFILE "Czech" = "Čeština" =

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "Vítejte v průvodci instalace programu $(^NameDA)"
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "Tento průvodce vás provede instalací programu $(^NameDA).$\r$\n$\r$\nPřed spuštěním instalačního programu je doporučeno ukončit všechny ostatní aplikace. Umožní to aktualizovat související systémové soubory bez restartování počítače.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "Vítejte v průvodci odinstalace programu $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT "Tento průvodce vás provede odinstalací programu $(^NameDA).$\r$\n$\r$\nPřed spuštěním odinstalace se přesvědčte, zda program $(^NameDA) není spuštěn.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "Licenční smlouva"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "Před instalací programu $(^NameDA) si prosím projděte licenční podmínky."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "Jestliže souhlasíte s podmínkami smlouvy, klikněte na tlačítko Souhlasím. Chcete-li nainstalovat program $(^NameDA), je nutné s touto smlouvou souhlasit."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "Jestliže souhlasíte s podmínkami smlouvy, zaškrtněte políčko níže. Chcete-li nainstalovat program $(^NameDA), je nutné s touto smlouvou souhlasit. $_CLICK"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Jestliže souhlasíte s podmínkami smlouvy, vyberte níže první možnost. Chcete-li nainstalovat program $(^NameDA), je nutné s touto smlouvou souhlasit. $_CLICK"
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "Licenční smlouva"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "Před odinstalací programu $(^NameDA) si prosím projděte licenční podmínky."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "Jestliže souhlasíte s podmínkami smlouvy, klikněte na tlačítko Souhlasím. Chcete-li odinstalovat program $(^NameDA), je nutné s touto smlouvou souhlasit."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "Jestliže souhlasíte s podmínkami smlouvy, zaškrtněte políčko níže. Chcete-li odinstalovat program $(^NameDA), je nutné s touto smlouvou souhlasit. $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Jestliže souhlasíte s podmínkami smlouvy, vyberte níže první možnost. Chcete-li odinstalovat program $(^NameDA), je nutné s touto smlouvou souhlasit. $_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "Zbytek textu zobrazíte stisknutím klávesy Page Down."
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "Volba součástí"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "Výběr součástí programu $(^NameDA) pro instalaci."
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "Volba součástí"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "Výběr součástí programu $(^NameDA) pro odinstalaci."
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "Popis"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Chcete-li zobrazit popis součásti, umístěte na ní ukazatel myši."
  !else
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Chcete-li zobrazit popis součásti, vyberte ji."
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "Volba umístění instalace"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "Výběr instalační složky programu $(^NameDA)."
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "Volba umístění odinstalace"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "Výběr odinstalační složky programu $(^NameDA)."
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "Instalace"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "Počkejte prosím na dokončení instalace programu $(^NameDA)."
  ${LangFileString} MUI_TEXT_FINISH_TITLE "Instalace dokončena"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "Instalace byla úspěšně dokončena."
  ${LangFileString} MUI_TEXT_ABORT_TITLE "Instalace přerušena"
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "Instalace nebyla úspěšně dokončena."
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "Odinstalace"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "Počkejte prosím na dokončení odinstalace programu $(^NameDA)."
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "Odinstalace dokončena"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "Odinstalace byla úspěšně dokončena."
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "Odinstalace přerušena"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "Odinstalace nebyla úspěšně dokončena."
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "Dokončení instalace programu $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "Program $(^NameDA) byl nainstalován do počítače.$\r$\n$\r$\nKliknutím na tlačítko Dokončit ukončíte tohoto průvodce."
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "K dokončení instalace programu $(^NameDA) je nutné restartovat počítač. Chcete jej restartovat nyní?"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "Dokončení odinstalace programu $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "Program $(^NameDA) byl odinstalován z počítače.$\r$\n$\r$\nKliknutím na tlačítko Dokončit ukončíte tohoto průvodce."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "K dokončení odinstalace $(^NameDA) je nutné restartovat počítač. Chcete jej restartovat nyní?"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "Restartovat nyní"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "Restartovat později ručně"
  ${LangFileString} MUI_TEXT_FINISH_RUN "&Spustit program $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "&Zobrazit soubor Readme (Čti mě)"
  ${LangFileString} MUI_BUTTONTEXT_FINISH "&Dokončit"  
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "Volba složky v Nabídce Start"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "Výběr složky v Nabídce Start pro zástupce programu $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "Vyberte složku v Nabídce Start, ve které chcete vytvořit zástupce programu. Chcete-li vytvořit novou složku, zadejte její název."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "Nevytvořit zástupce"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "Odinstalace programu $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "Odebere program $(^NameDA) z počítače."
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "Opravdu chcete instalaci programu $(^Name) ukončit?"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "Opravdu chcete odinstalaci programu $(^Name) ukončit?"
!endif

!ifdef MULTIUSER_INSTALLMODEPAGE
  ${LangFileString} MULTIUSER_TEXT_INSTALLMODE_TITLE "Volba uživatelů"
  ${LangFileString} MULTIUSER_TEXT_INSTALLMODE_SUBTITLE "Výběr uživatelů, kterým bude program $(^NameDA) nainstalován."
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_TOP "Vyberte, zda chcete program $(^NameDA) nainstalovat pouze pro sebe, nebo pro všechny uživatele počítače. $(^ClickNext)"
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_ALLUSERS "Instalovat pro všechny uživatele počítače"
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_CURRENTUSER "Instalovat pouze pro sebe"
!endif
