;Language: Romanian (1048)
;Translated by Cristian Pirvu (pcristip@yahoo.com)
;Updates by Sorin Sbarnea - INTERSOL SRL (sbarneasorin@intersol.ro) - ROBO Design (www.robodesign.ro)
;New revision by George Radu (georadu@hotmail.com) http://mediatae.3x.ro
;New revision by Vlad Rusu (vlad@bitattack.ro)
;	- Use Romanian letters ăâîşţ
;	- ".. produsului" removed as unnecessary
;	- "Elimină" related terms replaced with more appropiate "Dezinstalează"
;	- Misc language tweaks

!insertmacro LANGFILE "Romanian" = "Română" "Romana"

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "Bine aţi venit la instalarea $(^NameDA)"
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "Această aplicaţie va instala $(^NameDA).$\r$\n$\r$\nEste recomandat să închideţi toate aplicaţiile înainte de începerea procesului de instalare. Acest lucru vă poate asigura un proces de instalare fără erori sau situaţii neprevăzute.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "Bine aţi venit la dezinstalarea $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT "Această aplicaţie va dezinstala $(^NameDA).$\r$\n$\r$\nEste recomandat să închideţi toate aplicaţiile înainte de începerea procesului de dezinstalare. Acest lucru vă poate asigura un proces de dezinstalare fără erori sau situaţii neprevăzute.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_WELCOMEPAGE | MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_BUTTONTEXT_FINISH "&Terminare"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "Contract de licenţă"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "Citiţi cu atenţie termenii contractului de licenţă înainte de a instala $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "Dacă acceptaţi termenii contractului de licenţă, apăsati De Acord. Pentru a instala $(^NameDA) trebuie să acceptaţi termenii din contractul de licenţă."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "Dacă acceptaţi termenii contractului de licenţă, bifaţi căsuţa de mai jos. Pentru a instala $(^NameDA) trebuie să acceptaţi termenii din contractul de licenţă. $_CLICK"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Dacă acceptaţi termenii contractului de licenţă, selectaţi prima opţiune de mai jos. Pentru a instala $(^NameDA) trebuie să acceptaţi termenii din contractul de licenţă. $_CLICK"
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "Contract de licenţă"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "Citiţi cu atenţie termenii contractului de licenţă înainte de a dezinstala $(^NameDA)."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "Dacă acceptaţi termenii contractului de licenţă, apăsati De Acord. Pentru a dezinstala $(^NameDA) trebuie să acceptaţi termenii din contractul de licenţă."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "Dacă acceptaţi termenii contractului de licenţă, bifaţi căsuţa de mai jos. Pentru a dezinstala $(^NameDA) trebuie să acceptaţi termenii din contractul de licenţă. $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Dacă acceptaţi termenii contractului de licenţă, selectaţi prima opţiune de mai jos. Pentru a dezinstala $(^NameDA) trebuie să acceptaţi termenii din contractul de licenţă. $_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "Apăsaţi Page Down pentru a vizualiza restul contractului de licenţă."
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "Selectare componente"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "Selectaţi componentele $(^NameDA) pe care doriţi să le instalaţi."
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "Selectare componente"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "Selectaţi componentele $(^NameDA) pe care doriţi să le dezinstalaţi."
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "Descriere"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Aşezaţi mouse-ul deasupra fiecărei componente pentru a vizualiza descrierea acesteia."
  !else
    #FIXME:MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO 
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "Selectare director destinaţie"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "Selectaţi directorul în care doriţi să instalaţi $(^NameDA)."
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "Selectare director de dezinstalat"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "Selectaţi directorul din care doriţi să dezinstalaţi $(^NameDA)."
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "În curs de instalare"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "Vă rugăm să aşteptaţi, $(^NameDA) se instalează."
  ${LangFileString} MUI_TEXT_FINISH_TITLE "Instalare terminată"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "Instalarea s-a terminat cu succes."
  ${LangFileString} MUI_TEXT_ABORT_TITLE "Instalare anulată"
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "Instalarea a fost anulată de utilizator."
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "În curs de dezinstalare"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "Vă rugăm să aşteptaţi, $(^NameDA) se dezinstalează."
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "Dezinstalare terminată"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "Dezinstalarea s-a terminat cu succes."
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "Dezinstalare anulată"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "Dezinstalarea fost anulată de utilizator."
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "Terminare instalare $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "$(^NameDA) a fost instalat.$\r$\n$\r$\nApăsaţi Terminare pentru a încheia instalarea."
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "Trebuie să reporniţi calculatorul pentru a termina instalarea. Doriţi să-l reporniţi acum?"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "Terminare dezinstalare $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "$(^NameDA) a fost dezinstalat.$\r$\n$\r$\nApăsaţi Terminare pentru a încheia dezinstalarea."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "Trebuie să reporniţi calculatorul pentru a termina dezinstalarea. Doriţi să-l reporniţi acum?"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "Reporneşte acum"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "Repornesc eu mai târziu"
  ${LangFileString} MUI_TEXT_FINISH_RUN "Executare $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "Afişare fişier readme (citeşte-mă)."
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "Selectare grup Meniul Start"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "Selectaţi un grup in Meniul Start pentru a crea comenzi rapide pentru produs."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "Selectaţi grupul din Meniul Start în care vor fi create comenzi rapide pentru produs. Puteţi de asemenea să creaţi un grup nou."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "Nu doresc comenzi rapide"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "Dezinstalare $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "Dezinstalare $(^NameDA) din calculatorul dumneavoastră."
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "Sunteţi sigur(ă) că doriţi să anulaţi instalarea $(^Name)?"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "Sunteţi sigur(ă) că doriţi să anulaţi dezinstalarea $(^Name)?"
!endif
