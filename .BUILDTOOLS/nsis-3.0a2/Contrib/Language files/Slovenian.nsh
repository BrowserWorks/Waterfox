;Language: Slovenian (1060)
;By Janez Dolinar, edited by Martin Srebotnjak - Lugos.si

# We use "slovenski", the other alternative is "slovenščina" (Note: "slovenčina" is the native name of Slovak)
!insertmacro LANGFILE "Slovenian" = "Slovenski" =

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "Dobrodošli v čarovniku namestitve $(^NameDA)"
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "Ta čarovnik vas vodi skozi namestitev programa $(^NameDA).$\r$\n$\r$\nPred namestitvijo je priporočeno zapreti vsa ostala okna in programe. S tem omogočite nemoteno namestitev programa in potrebnih sistemskih datotek brez ponovnega zagona računalnika.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "Dobrodošli v čarovniku za odstranitev $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT "Ta čarovnik vas bo vodil skozi odstranitev $(^NameDA).$\r$\n$\r$\nPreden pričnete z odstranitvijo, se prepričajte, da program $(^NameDA) ni zagnan.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "Licenčna pogodba"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "Prosimo, da si ogledate pogoje licenčne pogodbe pred namestitvijo $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "Če se strinjate s pogoji, pritisnite Se strinjam. Da bi lahko namestili $(^NameDA), se morate s pogodbo strinjati."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "Če se strinjate z licenčnimi pogoji pogodbe, spodaj izberite ustrezno okence. Za namestitev $(^NameDA) se morate strinjati s pogoji pogodbe. $_CLICK"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Če se strinjate z licenčnimi pogoji pogodbe, spodaj izberite prvo možnost. Za namestitev $(^NameDA) se morate strinjati s pogoji pogodbe. $_CLICK"
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "Licenčna pogodba"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "Prosimo, da pred odstranitvijo $(^NameDA) pregledate pogoje licenčne pogodbe."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "Če se strinjate s pogoji licenčne pogodbe, izberite Se strinjam. Za odstranitev $(^NameDA) se morate strinjati s pogoji."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "Če se strinjate s pogoji licenčne pogodbe, kliknite na okence spodaj. Za odstranitev $(^NameDA) se morate strinjati s pogoji. $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Če se strinjate s pogoji licenčne pogodbe, spodaj izberite prvo podano možnost. Za odstranitev $(^NameDA) se morate strinjati s pogoji. $_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "Za preostali del pogodbe pritisnite tipko 'Page Down'."
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "Izbor komponent"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "Izberite, katere komponente izdelka $(^NameDA) želite namestiti."
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "Izbor komponent"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "Izberite komponente $(^NameDA), ki jih želite odstraniti."
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "Opis"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Povlecite miško nad komponento, da vidite njen opis."
  !else
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Izberite komponento za prikaz njenega opisa."
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "Izberite pot namestive"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "Izberite mapo, v katero želite namestiti $(^NameDA)."
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "Izbor mape"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "Izberite mapo, iz katere želite odstraniti $(^NameDA)."
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "Nameščanje poteka"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "Prosimo, počakajte, $(^NameDA) se namešča."
  ${LangFileString} MUI_TEXT_FINISH_TITLE "Dokončana namestitev"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "Namestitev je uspešno zaključena."
  ${LangFileString} MUI_TEXT_ABORT_TITLE "Prekinjena namestitev"
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "Namestitev ni bila uspešno zaključena."
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "Odstranjevanje poteka"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "Prosimo, počakajte, dokler se program $(^NameDA) odstranjuje."
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "Odstranitev končana"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "Odstranitev je uspešno končana."
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "Odstranitev prekinjena"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "Odstranitev ni bila končana uspešno."
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "Zaključevanje namestitve $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "Program $(^NameDA) je bil nameščen na vaš računalnik.$\r$\n$\r$\nPritisnite Dokončaj za zaprtje čarovnika."
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "Za dokončanje namestitve $(^NameDA) morate ponovno zagnati računalnik. Želite zdaj ponovno zagnati računalnik?"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "Čarovnik za odstranitev $(^NameDA) se zaključuje"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "Program $(^NameDA) je odstranjen z vašega računalnika.$\r$\n$\r$\nKliknite Dokončaj, da zaprete čarovnika."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "Da bi se namestitev $(^NameDA) dokončala, morate ponovno zagnati računalnik. Želite zdaj znova zagnati računalnik?"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "Ponovni zagon"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "Računalnik želim znova zagnati kasneje"
  ${LangFileString} MUI_TEXT_FINISH_RUN "&Zaženi $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "&Pokaži BeriMe"
  ${LangFileString} MUI_BUTTONTEXT_FINISH "Do&končaj"  
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "Izberite mapo menija Start"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "Izberite mapo menija Start za bližnjice do $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "Izberite mapo menija Start, kjer želite ustvariti bližnjico do programa. Če vpišete novo ime, boste ustvarili istoimensko mapo."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "Ne ustvari bližnjic"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "Odstranitev $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "Odstrani $(^NameDA) z vašega računalnika."
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "Ste prepričani, da želite prekiniti namestitev $(^Name)?"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "Ste prepričani, da želite zapustiti odstranitev $(^Name)?"
!endif

!ifdef MULTIUSER_INSTALLMODEPAGE
  ${LangFileString} MULTIUSER_TEXT_INSTALLMODE_TITLE "Izberite uporabnike"
  ${LangFileString} MULTIUSER_TEXT_INSTALLMODE_SUBTITLE "Izberite uporabnike, za katere želite namestiti $(^NameDA)."
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_TOP "Izberite, ali želite namestiti $(^NameDA) le zase ali za vse uporabnike tega računalnika. $(^ClickNext)"
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_ALLUSERS "Namesti za vse uporabnike tega računalnika"
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_CURRENTUSER "Namesti le zame"
!endif
