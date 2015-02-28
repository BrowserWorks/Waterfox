;Language: Croatian (1050)
;By Igor Ostriz

!insertmacro LANGFILE "Croatian" = "Hrvatski" =

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "Dobrodošli u instalaciju programa $(^NameDA)"
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "Instalacija programa $(^NameDA) na Vaše računalo sastoji se od nekoliko jednostavnih koraka kroz koje će Vas provesti ovaj čarobnjak.$\r$\n$\r$\nPreporučamo zatvaranje svih ostalih aplikacija prije samog početka instalacije. To će omogućiti nadogradnju nekih sistemskih datoteka bez potrebe za ponovnim pokretanjem Vašeg računala. U svakom trenutku instalaciju možete prekinuti pritiskom na 'Odustani'.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "Dobrodošli u postupak uklanjanja programa $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT "Ovaj će Vas čarobnjak provesti kroz postupak uklanjanja programa $(^NameDA).$\r$\n$\r$\nPrije samog početka, molim zatvorite program $(^NameDA) ukoliko je slučajno otvoren.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "Ugovor o licenci"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "Pročitajte licencu prije instalacije programa $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "Ako prihvaćate uvjete licence, pritisnite 'Prihvaćam' za nastavak. Da biste instalirali program $(^NameDA), morate prihvatiti licencu."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "Ukoliko prihvaćate uvjete licence, označite donji kvadratić. Morate prihvatiti licencu za instalaciju programa $(^NameDA). $_CLICK"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Ukoliko prihvaćate uvjete licence, odaberite prvu donju opciju. Morate prihvatiti licencu za instalaciju programa $(^NameDA). $_CLICK"
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "Ugovor o licenci"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "Pročitajte licencu prije uklanjanja programa $(^NameDA)."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "Ako prihvaćate uvjete licence, pritisnite 'Prihvaćam' za nastavak. Da biste instalirali program $(^NameDA), morate prihvatiti licencu."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "Ukoliko prihvaćate uvjete licence, označite donji kvadratić. Morate prihvatiti licencu za uklanjanje programa $(^NameDA). $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Ukoliko prihvaćate uvjete licence, odaberite prvu donju opciju. Morate prihvatiti licencu za uklanjanje programa $(^NameDA). $_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "Služite se tipkom 'Page Down' da biste vidjeli ostatak licence."
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "Izbor komponenti"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "Odaberite komponente programa $(^NameDA) koje želite instalirati."
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "Izbor komponenti"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "Odaberite koje komponente programa $(^NameDA) želite ukloniti."
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "Opis"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Postavite pokazivač iznad komponente za njezin opis."
  !else
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Označite komponentu za njezin opis."
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "Odaberite odredište za instalaciju"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "Odaberite mapu u koju želite instalirati program $(^NameDA)."
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "Odaberite polazište za uklanjanje"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "Odaberite mapu iz koje želite ukloniti program $(^NameDA)."
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "Instalacija u tijeku..."
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "Pričekajte završetak instalacije programa $(^NameDA)."
  ${LangFileString} MUI_TEXT_FINISH_TITLE "Kraj instalacije"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "Instalacija je u potpunosti završila uspješno."
  ${LangFileString} MUI_TEXT_ABORT_TITLE "Instalacija je prekinuta"
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "Instalacija nije završila uspješno."
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "Uklanjanje u tijeku..."
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "Pričekajte završetak uklanjanja programa $(^NameDA)."
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "Uklanjanje završeno"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "Uklanjanje je u potpunosti završilo uspješno."
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "Uklanjanje je prekinuto"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "Uklanjanje nije završilo uspješno."
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "Dovršetak instalacije programa $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "Program $(^NameDA) upravo je instaliran.$\r$\n$\r$\nOdaberite 'Kraj' za završetak."
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "Da bi se dovršila instalacija programa $(^NameDA), trebate ponovno pokrenuti računalo. Želite li to učiniti sada?"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "Završetak uklanjanja programa $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "Program $(^NameDA) uklonjen je s Vašeg računala.$\r$\n$\r$\nOdaberite 'Kraj' za zatvaranje ovog čarobnjaka."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "Da bi se dovršio postupka uklanjanja programa $(^NameDA), trebate ponovno pokrenuti računalo. Želite li to učiniti sada?"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "Ponovno pokreni računalo sada"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "Ponovno ću pokrenuti računalo kasnije"
  ${LangFileString} MUI_TEXT_FINISH_RUN "&Pokreni program $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "Otvori datoteku '&Readme'"
  ${LangFileString} MUI_BUTTONTEXT_FINISH "&Kraj"  
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "Izbor mape u izborniku 'Start'"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "Odaberite ime za programsku mapu unutar izbornika 'Start'."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "Program će pripadati odabranoj programskoj mapi u izborniku 'Start'. Možete odrediti novo ime za mapu ili odabrati već postojeću."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "Nemoj napraviti prečace"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "Uklanjanje programa $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "Program $(^NameDA) bit će uklonjen s Vašeg računala."
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "Jeste li sigurni da želite prekinuti instalaciju programa $(^Name)?"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "Jeste li sigurni da želite prekinuti uklanjanje programa $(^Name)?"
!endif
