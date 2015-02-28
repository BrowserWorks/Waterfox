;Language: Lithuanian (1063)
;By Vytautas Krivickas (Vytautas). Updated by Danielius Scepanskis (Daan daniel@takas.lt) 2004.01.09

!insertmacro LANGFILE "Lithuanian" = "Lietuvių" "Lietuviu"

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "Sveiki atvykę į $(^NameDA) įdiegimo programą."
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "Ši programa jums padės lengvai įdiegti $(^NameDA).$\r$\n$\r$\nRekomenduojama išjungti visas programas, prieš pradedant įdiegimą. Tai leis atnaujinti sistemos failus neperkraunat kompiuterio.$\r$\n$\r$\n"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "Sveiki atvykę į $(^NameDA) pašalinimo programą."
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT "Ši programa jums padės lengvai ištrinti $(^NameDA).$\r$\n$\r$\nPrieš pradedant pasitikrinkite kad $(^NameDA) yra išjungta.$\r$\n$\r$\n"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "Naudojimo sutartis"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "Prašome perskaityti sutartį prieš įdiegdami $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "Jei jūs sutinkate su nurodytomis sąlygomis, spauskite Sutinku. Jūs privalote sutikti, jei norite įdiegti $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "Jei jūs sutinkate su nurodytomis sąlygomis, padėkite varnelę tam skirtame laukelyje. Jūs privalote sutikti, jei norite įdiegti $(^NameDA). "
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Jei jūs sutinkate su nurodytomis sąlygomis, pasirinkite pirmą pasirinkimą esantį žemiau. Jūs privalote sutikti, jei norite įdiegti $(^NameDA). "
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "Naudojimo sutartis"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "Prašome perskaityti sutartį prieš $(^NameDA) pašalinimą."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "Jei jūs sutinkate su nurodytomis sąlygomis, spauskite Sutinku. Jūs privalote sutikti, jei norite ištrinti $(^NameDA)."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "s, padėkite varnelę tam skirtame laukelyje. Jūs privalote sutikti, jei norite ištrinti $(^NameDA). "
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Jei jūs sutinkate su nurodytomis sąlygomis, pasirinkite pirmą pasirinkimą esantį žemiau. Jūs privalote sutikti, jei norite ištrinti $(^NameDA)."
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "Paspauskite Page Down ir perskaitykite visą sutartį."
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "Pasirinkite"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "Pasirinkite kokias $(^NameDA) galimybes jūs norite įdiegti."
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "Pasirinkite"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "Pasirinkite kokias $(^NameDA) galimybes jūs norite pašalinti."
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "Paaiškinimas"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Užveskite pelės žymeklį ant komponento ir pamatysite jo aprašymą."
  !else
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Pasirinkite komponentį ir pamatysite jo aprašymą."
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "Pasirinkite įdiegimo vietą"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "Pasirinkite katalogą į kūri įdiegsite $(^NameDA)."
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "Pasirinkite ištrinimo vietą"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "Pasirinkite katalogą iš kurio ištrinsite $(^NameDA)."
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "Diegiama"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "Prašome palaukti, kol $(^NameDA) bus įdiegtas."
  ${LangFileString} MUI_TEXT_FINISH_TITLE "Įdiegimas baigtas"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "Įdiegimas baigtas sekmingai."
  ${LangFileString} MUI_TEXT_ABORT_TITLE "Įdiegimas nutrauktas"
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "Įdiegimas nebuvo baigtas sekmingai."
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "Šalinama"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "Prašome palaukti, kol $(^NameDA) bus pašalinta."
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "Programos pašalinimas baigtas"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "Ištrynimas baigtas sekmingai."
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "Ištrynimas nutrauktas"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "Ištrynimas nebuvo baigtas sekmingai."
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "Baigiu $(^NameDA) įdiegimo procesą"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "$(^NameDA) buvo įdiegtas į jūsų kompiuterį.$\r$\n$\r$\nPaspauskite Baigti."
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "Jūsų kompiuteris turi būti perkrautas, kad būtų baigtas $(^NameDA) įdiegimas. Ar jūs norite perkrauti dabar?"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "Baigiu $(^NameDA) pašalinimo programą."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "$(^NameDA) buvo ištrinta iš jūsų kompiuterio.$\r$\n$\r$\nPaspauskite Baigti."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "Jūsų kompiuteris turi būti perkrautas, kad būtų baigtas $(^NameDA) pašalinimas. Ar jūs norite perkrauti dabar?"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "Perkrauti dabar"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "Aš noriu perkrauti veliau pats"
  ${LangFileString} MUI_TEXT_FINISH_RUN "&Leisti $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "&Parodyti dokumentaciją"
  ${LangFileString} MUI_BUTTONTEXT_FINISH "&Baigti"  
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "Pasirinkite Start Menu katalogą"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "Pasirinkite Start Menu katalogą, kuriame bus sukurtos programos nuorodos."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "Pasirinkite Start Menu katalogą, kuriame bus sukurtos programos nuorodos. Jūs taip pat galite sukurti naują katalogą."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "Nekurti nuorodų"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "Panaikinti $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "Ištrinti $(^NameDA) iš jūsų kompiuterio."
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "Ar jūs tikrai norite išjungti $(^Name) įdiegimo programą?"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "Ar jūs tikrai norite išjungti $(^Name) pašalinimo programą?"
!endif
