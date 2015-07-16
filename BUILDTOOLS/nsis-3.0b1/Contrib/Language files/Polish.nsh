;Language: Polish (1045)
;By Piotr Murawski & Rafał Lampe
;Updated by cube and SYSTEMsoft Group
;Updated by Paweł Porwisz, http://www.pepesoft.tox.pl
;Corrected by Mateusz Gola (aka Prozac) - http://www.videopedia.pl/avirecomp

!insertmacro LANGFILE "Polish" = "Polski" =

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "Witamy w kreatorze instalacji programu $(^NameDA)"
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "Kreator ten pomoże Ci zainstalować program $(^NameDA).$\r$\n$\r$\nZalecane jest zamknięcie wszystkich uruchomionych programów przed rozpoczęciem instalacji. Pozwoli to na uaktualnienie niezbędnych plików systemowych bez konieczności ponownego uruchamiania komputera.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "Witamy w deinstalatorze $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT "Deinstalator poprowadzi Cię przez proces deinstalacji $(^NameDA).$\r$\n$\r$\nPrzed rozpoczęciem deinstalacji programu, upewnij się, czy $(^NameDA) NIE jest właśnie uruchomiony.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "Umowa licencyjna"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "Przed instalacją programu $(^NameDA) zapoznaj się z warunkami licencji."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "Jeżeli akceptujesz warunki umowy, wybierz Zgadzam się, aby kontynuować. Musisz zaakceptować warunki umowy, aby zainstalować $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "Jeżeli akceptujesz warunki umowy, zaznacz pole wyboru poniżej, aby kontynuować. Musisz zaakceptować warunki umowy, aby zainstalować $(^NameDA). $_CLICK"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Jeżeli akceptujesz warunki umowy, wybierz pierwszą opcję poniżej, aby kontynuować. Musisz zaakceptować warunki umowy, aby zainstalować $(^NameDA). $_CLICK"
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "Umowa licencyjna"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "Przed deinstalacją programu $(^NameDA) zapoznaj się z warunkami licencji."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "Jeżeli akceptujesz warunki umowy, wybierz Zgadzam się, aby kontynuować. Musisz zaakceptować warunki umowy, aby odinstalować $(^NameDA)."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "Jeżeli akceptujesz warunki umowy, zaznacz pole wyboru poniżej, aby kontynuować. Musisz zaakceptować warunki umowy, aby odinstalować $(^NameDA). $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Jeżeli akceptujesz warunki umowy, wybierz pierwszą opcję poniżej, aby kontynuować. Musisz zaakceptować warunki umowy, aby odinstalować $(^NameDA). $_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "Naciśnij klawisz Page Down, aby zobaczyć dalszą część umowy."
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "Wybierz komponenty"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "Wybierz komponenty programu $(^NameDA), które chcesz zainstalować."
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "Wybierz komponenty"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "Wybierz, które elementy $(^NameDA) chcesz odinstalować."
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "Opis"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Przesuń kursor myszy nad komponent, aby zobaczyć jego opis."
  !else
    #FIXME:MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO 
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "Wybierz lokalizację dla instalacji"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "Wybierz folder, w którym ma być zainstalowany $(^NameDA)."
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "Wybór miejsca deinstalacji"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "Wybierz folder, z którego chcesz odinstalować $(^NameDA)."
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "Instalacja"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "Proszę czekać, podczas gdy $(^NameDA) jest instalowany."
  ${LangFileString} MUI_TEXT_FINISH_TITLE "Zakończono instalację"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "Instalacja zakończona pomyślnie."
  ${LangFileString} MUI_TEXT_ABORT_TITLE "Instalacja przerwana"
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "Instalacja nie została zakończona pomyślnie."
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "Deinstalacja"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "Proszę czekać, $(^NameDA) jest odinstalowywany."
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "Zakończono odinstalowanie"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "Odinstalowanie zakończone pomyślnie."
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "Deinstalacja przerwana"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "Deinstalacja nie została zakończona pomyślnie."
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "Kończenie pracy instalatora $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "$(^NameDA) został pomyślnie zainstalowany na Twoim komputerze.$\r$\n$\r$\nKliknij Zakończ, aby zakończyć działanie instalatora."
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "Twój komputer musi zostać ponownie uruchomiony, aby zakończyć instalację programu $(^NameDA). Czy chcesz zrobić to teraz?"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "Kończenie pracy deinstalatora $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "$(^NameDA) został odinstalowany z Twojego komputera.$\r$\n$\r$\nKliknij Zakończ, aby zakończyć działanie deinstalatora."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "Twój komputer musi zostać ponownie uruchomiony w celu zakończenia deinstalacji programu $(^NameDA). Czy chcesz zrobić to teraz?"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "Uruchom ponownie teraz"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "Sam uruchomię ponownie komputer później"
  ${LangFileString} MUI_TEXT_FINISH_RUN "&Uruchom program $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "&Pokaż plik ReadMe"
  ${LangFileString} MUI_BUTTONTEXT_FINISH "&Zakończ"  
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "Wybierz folder w menu Start"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "Wybierz folder menu Start, w którym zostaną umieszczone skróty do programu"
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "Wybierz folder w menu Start, w którym chciałbyś umieścić skróty do programu. Możesz także utworzyć nowy folder wpisując jego nazwę."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "Nie twórz skrótów"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "Odinstaluj $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "Usuń $(^NameDA) z Twojego komputera."
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "Czy na pewno chcesz zakończyć działanie instalatora $(^Name)?"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "Czy na pewno chcesz przerwać proces deinstalacji $(^Name)?"
!endif

!ifdef MULTIUSER_INSTALLMODEPAGE
  ${LangFileString} MULTIUSER_TEXT_INSTALLMODE_TITLE "Wybierz użytkowników"
  ${LangFileString} MULTIUSER_TEXT_INSTALLMODE_SUBTITLE "Wybierz, dla których użytkowników chcesz zainstalować program $(^NameDA)."
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_TOP "Wybierz, czy chcesz zainstalować program $(^NameDA) tylko dla siebie, czy dla wszystkich użytkowników tego komputera. $(^ClickNext)"
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_ALLUSERS "Zainstaluj dla wszystkich użytkowników tego komputera"
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_CURRENTUSER "Zainstaluj tylko dla mnie"
!endif
