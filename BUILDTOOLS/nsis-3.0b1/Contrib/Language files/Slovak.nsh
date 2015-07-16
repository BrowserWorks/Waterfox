;Language: Slovak (1051)
;Translated by:
;  Kypec (peter.dzugas@mahe.sk)
;edited by:
;  Marián Hikaník (podnety@mojepreklady.net)
;  Ivan Masár <helix84@centrum.sk>, 2008.

!insertmacro LANGFILE "Slovak" = "Slovenčina" "Slovencina"

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "Vitajte v sprievodcovi inštaláciou programu $(^NameDA)"
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "Tento sprievodca vás prevedie inštaláciou $(^NameDA).$\r$\n$\r$\nPred začiatkom inštalácie sa odporúča ukončiť všetky ostatné programy. Tým umožníte aktualizovanie systémových súborov bez potreby reštartovania vášho počítača.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "Vitajte v sprievodcovi odinštalovaním programu $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT "Tento sprievodca vás prevedie procesom odinštalovania programu $(^NameDA).$\r$\n$\r$\nPred spustením procesu odinštalovania sa uistite, že program $(^NameDA) nie je práve aktívny.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "Licenčná zmluva"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "Pred inštaláciou $(^NameDA) si prosím preštudujte licenčné podmienky."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "Ak súhlasíte s podmienkami zmluvy, kliknite na tlačidlo Súhlasím a môžete pokračovať v inštalácii. Ak chcete v inštalácii pokračovať, musíte odsúhlasiť podmienky licenčnej zmluvy $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "Ak súhlasíte s podmienkami zmluvy, zaškrtnite nižšie uvedené políčko. Ak chcete v inštalácii pokračovať, musíte odsúhlasiť podmienky licenčnej zmluvy $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Ak súhlasíte s podmienkami zmluvy, označte prvú z nižšie uvedených možností. Ak chcete v inštalácii pokračovať, musíte odsúhlasiť podmienky licenčnej zmluvy $(^NameDA)."
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "Licenčná zmluva"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "Pred odinštalovaním programu $(^NameDA) si prosím prečítajte licenčné podmienky."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "Ak súhlasíte s podmienkami zmluvy, zvoľte Súhlasím. Licenčnú zmluvu musíte odsúhlasiť, ak chcete v odinštalovaní programu $(^NameDA) pokračovať."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "Ak súhlasíte s podmienkami zmluvy, zaškrtnite nižšie uvedené políčko. Licenčnú zmluvu musíte odsúhlasiť, ak chcete pokračovať v odinštalovaní programu $(^NameDA). $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Ak súhlasíte s podmienkami licenčnej zmluvy, označte prvú z nižšie uvedených možností. Licenčnú zmluvu musíte odsúhlasiť, ak chcete pokračovať v odinštalovaní programu $(^NameDA). $_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "Stlačením klávesu Page Down posuniete text licenčnej zmluvy."
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "Voľba súčastí programu"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "Zvoľte si tie súčasti programu $(^NameDA), ktoré chcete nainštalovať."
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "Voľba súčastí"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "Zvoľte súčasti programu $(^NameDA), ktoré chcete odinštalovať."
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "Popis"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Pri prejdení kurzorom myši nad názvom súčasti sa zobrazí jej popis."
  !else
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Označte nejakú súčasť, ak chcete zobraziť jej podrobnejší popis."
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "Voľba umiestnenia programu"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "Vyberte si priečinok, do ktorého chcete nainštalovať program $(^NameDA)."
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "Umiestenie programu pre odinštalovanie"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "Vyberte si priečinok, z ktorého chcete odinštalovať program $(^NameDA)."
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "Inštalácia"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "Počkajte prosím, kým prebehne inštalácia programu $(^NameDA)."
  ${LangFileString} MUI_TEXT_FINISH_TITLE "Ukončenie inštalácie"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "Inštalácia bola dokončená úspešne."
  ${LangFileString} MUI_TEXT_ABORT_TITLE "Prerušenie inštalácie"
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "Inštaláciu sa nepodarilo dokončiť."
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "Odinštalovanie"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "Čakajte prosím, kým prebehne odinštalovanie programu $(^NameDA)."
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "Ukončenie odinštalovania"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "Odinštalovanie bolo úspešne dokončené."
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "Prerušenie odinštalovania"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "Odinštalovanie sa neukončilo úspešne."
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "Dokončenie inštalácie programu $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "Program $(^NameDA) bol nainštalovaný do vášho počítača.$\r$\nKliknite na tlačidlo Dokončiť a tento sprievodca sa ukončí."
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "Pre úplné dokončenie inštalácie programu $(^NameDA) je potrebné reštartovať váš počítač. Chcete ho reštartovať ihneď?"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "Dokončenie sprievodcu odinštalovaním"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "Program $(^NameDA) bol odinštalovaný z vášho počítača.$\r$\n$\r$\nKliknite na tlačidlo Dokončiť a tento sprievodca sa ukončí."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "Pre úplné dokončenie odinštalovania programu $(^NameDA) je nutné reštartovať váš počítač. Chcete ho reštartovať ihneď?"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "Reštartovať teraz"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "Reštartovať neskôr (manuálne)"
  ${LangFileString} MUI_TEXT_FINISH_RUN "&Spustiť program $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "&Zobraziť súbor s informáciami"
  ${LangFileString} MUI_BUTTONTEXT_FINISH "&Dokončiť"  
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "Voľba umiestnenia v ponuke Štart"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "Vyberte si priečinok v ponuke Štart, kam sa umiestnia odkazy na program $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "Vyberte si priečinok v ponuke Štart, v ktorom chcete vytvoriť odkazy na program. Takisto môžete napísať názov nového priečinka."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "Nevytvárať odkazy"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "Odinštalovanie programu $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "Odstránenie programu $(^NameDA) z vášho počítača."
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "Naozaj chcete ukončiť inštaláciu programu $(^Name)?"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "Naozaj chcete ukončiť proces odinštalovania programu $(^Name)?"
!endif

!ifdef MULTIUSER_INSTALLMODEPAGE
  ${LangFileString} MULTIUSER_TEXT_INSTALLMODE_TITLE "Vybrať používateľov"
  ${LangFileString} MULTIUSER_TEXT_INSTALLMODE_SUBTITLE "Vyberte pre ktorých používateľov chcete nainštalovať $(^NameDA)."
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_TOP "Vyberte, či chcete nainštalovať program $(^NameDA) iba pre seba alebo pre všetkých používateľov tohto počítača. $(^ClickNext)"
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_ALLUSERS "Nainštalovať pre všetkých používateľov tohto počítača"
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_CURRENTUSER "Nainštalovať iba pre mňa"
!endif