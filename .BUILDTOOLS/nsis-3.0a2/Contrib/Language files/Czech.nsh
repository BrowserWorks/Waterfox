;Language: Czech (1029)
;By SELiCE (ls@selice.cz - http://ls.selice.cz)
;Corrected by Ondřej Vaniš - http://www.vanis.cz/ondra

!insertmacro LANGFILE "Czech" = "Čeština" "Cestina"

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "Vítejte v průvodci instalace programu $(^NameDA)"
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "Tento průvodce Vás provede instalací $(^NameDA).$\r$\n$\r$\nPřed začátkem instalace je doporučeno zavřít všechny ostatní aplikace. Toto umožní aktualizovat důležité systémové soubory bez restartování Vašeho počítače.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "Vítejte v $(^NameDA) odinstalačním průvodci"
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT "Tento průvodce Vás provede odinstalací $(^NameDA).$\r$\n$\r$\nPřed začátkem odinstalace, se přesvědčte, že $(^NameDA) není spuštěn.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "Licenční ujednání"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "Před instalací programu $(^NameDA) si prosím prostudujte licenční podmínky."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "Jestliže souhlasíte se všemi podmínkami ujednání, zvolte 'Souhlasím' pro pokračování. Pro instalaci programu $(^NameDA) je nutné souhlasit s licenčním ujednáním."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "Jestliže souhlasíte se všemi podmínkami ujednání, zaškrtněte níže uvedenou volbu. Pro instalaci programu $(^NameDA) je nutné souhlasit s licenčním ujednáním. $_CLICK"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Jestliže souhlasíte se všemi podmínkami ujednání, zvolte první z možností uvedených níže. Pro instalaci programu $(^NameDA) je nutné souhlasit s licenčním ujednáním. $_CLICK"
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "Licenční ujednání"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "Před odinstalováním programu $(^NameDA) si prosím prostudujte licenční podmínky."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "Jestliže souhlasíte se všemi podmínkami ujednání, zvolte 'Souhlasím' pro pokračování. Pro odinstalování programu $(^NameDA) je nutné souhlasit s licenčním ujednáním."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "Jestliže souhlasíte se všemi podmínkami ujednání, zaškrtněte níže uvedenou volbu. Pro odinstalování programu $(^NameDA) je nutné souhlasit s licenčním ujednáním. $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Jestliže souhlasíte se všemi podmínkami ujednání, zvolte první z níže uvedených možností. Pro odinstalování programu $(^NameDA) je nutné souhlasit s licenčním ujednáním. $_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "Stisknutím klávesy Page Down posunete text licenčního ujednání."
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "Volba součástí"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "Zvolte součásti programu $(^NameDA), které chcete nainstalovat."
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "Volba součástí"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "Zvolte součásti programu $(^NameDA), které chcete odinstalovat."
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "Popis"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Při pohybu myší nad instalátorem programu se zobrazí její popis."
  !else
    #FIXME:MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "Zvolte umístění instalace"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "Zvolte složku, do které bude program $(^NameDA) nainstalován."
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "Zvolte umístění odinstalace"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "Zvolte složku, ze které bude program $(^NameDA) odinstalován."
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "Instalace"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "Vyčkejte, prosím, na dokončení instalace programu $(^NameDA)."
  ${LangFileString} MUI_TEXT_FINISH_TITLE "Instalace dokončena"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "Instalace proběhla v pořádku."
  ${LangFileString} MUI_TEXT_ABORT_TITLE "Instalace přerušena"
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "Instalace nebyla dokončena."
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "Odinstalace"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "Vyčkejte, prosím, na dokončení odinstalace programu $(^NameDA)."
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "Odinstalace dokončena"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "Odinstalace proběhla v pořádku."
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "Odinstalace přerušena"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "Odinstalace nebyla dokončena."
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "Dokončení průvodce programu $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "Program $(^NameDA) byl nainstalován na Váš počítač.$\r$\n$\r$\nKlikněte 'Dokončit' pro ukončení průvodce."
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "Pro dokončení instalace programu $(^NameDA) je nutno restartovat počítač. Chcete restatovat nyní?"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "Dokončuji odinstalačního průvodce $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "$(^NameDA) byl odinstalován z Vašeho počítače.$\r$\n$\r$\nKlikněte na 'Dokončit' pro ukončení tohoto průvodce."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "Pro dokončení odinstalace $(^NameDA) musí být Váš počítač restartován. Chcete restartovat nyní?"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "Restartovat nyní"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "Restartovat ručně později"
  ${LangFileString} MUI_TEXT_FINISH_RUN "&Spustit program $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "&Zobrazit Čti-mne"
  ${LangFileString} MUI_BUTTONTEXT_FINISH "&Dokončit"  
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "Zvolte složku v Nabídce Start"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "Zvolte složku v Nabídce Start pro zástupce programu $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "Zvolte složku v Nabídce Start, ve které chcete vytvořit zástupce programu. Můžete také zadat nové jméno pro vytvoření nové složky."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "Nevytvářet zástupce"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "Odinstalovat program $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "Odebrat program $(^NameDA) z Vašeho počítače."
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "Opravdu chcete ukončit instalaci programu $(^Name)?"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "Skutečně chcete ukončit odinstalaci $(^Name)?"
!endif
