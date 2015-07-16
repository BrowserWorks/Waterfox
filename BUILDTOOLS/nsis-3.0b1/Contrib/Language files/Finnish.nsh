;Compatible with Modern UI 1.86
;Language: Finnish (1035)
;By Eclipser (Jonne Lehtinen) <Eclipser at pilvikaupunki dot com>
;Updated by Puuhis (puuhis@puuhis.net)
;Updated 11/08 by WTLib Team

!insertmacro LANGFILE "Finnish" = "Suomi" =

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "Tervetuloa $(^NameDA) -ohjelman asennukseen"
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "Saat tarvittavia ohjeita sitä mukaa kuin $(^NameDA) -ohjelman asennus edistyy.$\r$\n$\r$\nOn suositeltavaa sulkea kaikki muut ohjelmat ennen asennuksen aloittamista, jotta asennus voi päivittää järjestelmätiedostoja käynnistämättä konetta uudelleen.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "Tervetuloa $(^NameDA) -ohjelman poisto-ohjelmaan"
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT "Saat tarvittavia ohjeita sitä mukaa kuin $(^NameDA) -ohjelman poisto edistyy.$\r$\n$\r$\nEnnen poiston aloittamista varmista, ettei $(^NameDA) ole käynnissä.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "Käyttöoikeussopimus"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "Lue käyttöehdot huolellisesti ennen $(^NameDA) -ohjelman asentamista."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "Jos hyväksyt ehdot, valitse Hyväksyn. Ohjelman asentaminen edellyttää käyttöehtojen hyväksymistä."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "Jos hyväksyt ehdot, laita rasti alla olevaan ruutuun. Ohjelman asentaminen edellyttää käyttöehtojen hyväksymistä. $_CLICK"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Jos hyväksyt ehdot, valitse ensimmäinen vaihtoehto alapuolelta. Ohjelman asentaminen edellyttää käyttöehtojen hyväksymistä. $_CLICK"
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "Käyttöoikeussopimus"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "Lue käyttöehdot huolellisesti ennen $(^NameDA) -ohjelman poistoa."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "Jos hyväksyt ehdot, valitse Hyväksyn. Ohjelman asentaminen edellyttää käyttöehtojen hyväksymistä."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "Jos hyväksyt ehdot, laita rasti alla olevaan ruutuun. Ohjelman asentaminen edellyttää käyttöehtojen hyväksymistä. $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Jos hyväksyt ehdot, valitse ensimmäinen vaihtoehto alapuolelta. Ohjelman asentaminen edellyttää käyttöehtojen hyväksymistä. $_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "Paina Page Down -näppäintä nähdäksesi loput sopimuksesta."
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "Valitse komponentit"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "Valitse toiminnot, jotka haluat asentaa ohjelmaan $(^NameDA)."
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "Valitse komponentit"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "Valitse $(^NameDA) toiminnot, jotka haluat poistaa."
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "Selitys"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Siirrä hiiri komponentin nimen päälle nähdäksesi sen selityksen."
  !else
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Valitse komponentti nähdäksesi sen selityksen."
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "Valitse asennuskansio"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "Valitse kansio, johon haluat asentaa $(^NameDA) -ohjelman."
!endif

!ifdef MUI_UNDIRECTORYSPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "Valitse kansio, josta poistetaan"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "Valitse kansio, josta $(^NameDA) poistetaan."
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "Asennetaan"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "Odota... $(^NameDA) asennetaan..."
  ${LangFileString} MUI_TEXT_FINISH_TITLE "Asennus valmis."
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "Asennus onnistui."
  ${LangFileString} MUI_TEXT_ABORT_TITLE "Asennus keskeytyi."
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "Asennus ei onnistunut."
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "Poistetaan"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "Odota... $(^NameDA) poistetaan."
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "Poisto valmis."
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "Poisto onnistui."
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "Poisto keskeytyi."
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "Poisto epäonnistui."
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "$(^NameDA) -ohjelman asennus on valmis"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "$(^NameDA) on asennettu tietokoneelle.$\r$\n$\r$\nValitse Valmis sulkeaksesi asennusohjelman."
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "$(^NameDA) -ohjelman asennuksen viimeisteleminen edellyttää tietokoneen uudelleenkäynnistämistä. Haluatko käynnistää tietokoneen uudelleen nyt?"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "$(^NameDA) on poistettu"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "$(^NameDA) on poistettu tietokoneelta.$\r$\n$\r$\nValitse Lopeta sulkeaksesi poisto-ohjelman."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "$(^NameDA) -ohjelman poiston viimeisteleminen edellyttää tietokoneen uudelleenkäynnistämistä. Haluatko käynnistää tietokoneen uudelleen nyt?"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "Käynnistä uudelleen nyt"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "Käynnistän uudelleen myöhemmin"
  ${LangFileString} MUI_TEXT_FINISH_RUN "Käynnistä $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "Näytä Lueminut-tiedosto"
  ${LangFileString} MUI_BUTTONTEXT_FINISH "&Valmis"  
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "Valitse Käynnistä-valikon kansio"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "Valitse Käynnistä-valikon kansio, johon ohjelman pikakuvakkeet asennetaan."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "Valitse Käynnistä-valikon kansio, johon haluat asentaa ohjelman pikakuvakkeet. Voit myös kirjoittaa uuden kansion nimen."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "Älä luo pikakuvakkeita."
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "Poista $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "Poista $(^NameDA) tietokoneesta."
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "Haluatko varmasti keskeyttää $(^Name) -ohjelman asennuksen?"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "Haluatko varmasti keskeyttää $(^Name) -ohjelman poiston?"
!endif
