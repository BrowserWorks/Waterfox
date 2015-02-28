;Language: Asturian (1150)
;By Marcos (marcoscostales@gmail.com).

!insertmacro LANGFILE "Asturian" = "Asturies" =

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "Bienveníu al Asistente d'Instalación de $(^NameDA)"
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "Esti programa instalará $(^NameDA) nel to ordenador.$\r$\n$\r$\nEncamiéntase que zarres toles demás aplicaciones enantes d'aniciar la instalación. Esto faerá posible anovar ficheros rellacionaos col sistema ensin tener que reaniciar el to ordenador.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "Bienveníu al Asistente de Desinstalación de $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT "Esti asistente guiaráte durante la desinstalación de $(^NameDA).$\r$\n$\r$\nEnantes d'aniciar la desinstalación, asegúrate de que $(^NameDA) nun se ta executando.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "Alcuerdu de llicencia"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "Por favor revisa los términos de la llicencia enantes d'instalar $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "Si aceutes tolos términos del alcuerdu, seleiciona Aceuto pa siguir. Tienes d'aceutar l'alcuerdu pa instalar $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "Si aceutes los términos del alcuerdu, conseña embaxo la caxella. Tienes d'aceutar los términos pa instalar $(^NameDA). $_CLICK"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Si aceutes los términos del alcuerdu, seleiciona embaxo la primer opción. Tienes d'aceutar los términos pa instalar $(^NameDA). $_CLICK"
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "Alcuerdu de llicencia"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "Por favor revisa los términos de la llicencia enantes de desinstalar $(^NameDA)."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "Si aceutes tolos términos del alcuerdu, seleiciona Aceuto pa siguir. Tienes d'aceutar l'alcuerdu pa desinstalar $(^NameDA)."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "Si aceutes los términos del alcuerdu, conseña embaxu la caxella. Tienes d'aceutar los términos pa desinstalar $(^NameDA). $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Si aceutes los términos del alcuerdu, seleccione embaxu la primer opción. Tienes d'aceutar los términos pa desinstalar $(^NameDA). $_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "Calca Avanzar Páxina pa ver el restu del alcuerdu."
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "Seleición de componentes"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "Seleicione qué carauterístiques de $(^NameDA) deseyes instalar."
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "Descripción"
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "Seleición de componentes"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "Seleicione qué carauterístiques de $(^NameDA) quies desinstalar."
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Allugue'l mur enriba d'un componente pa ver la so descripción."
  !else
    #FIXME:MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "Escoyer llugar d'instalación"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "Escueye'l direutoriu pa instalar $(^NameDA)."
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "Escoyer llugar de desinstalación"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "Escueye'l direutoriu dende'l cual se desinstalará $(^NameDA)."
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "Instalando"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "Por favor espera mientres $(^NameDA) s'instala."
  ${LangFileString} MUI_TEXT_FINISH_TITLE "Instalación Completada"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "La instalación completóse correutamente."
  ${LangFileString} MUI_TEXT_ABORT_TITLE "Instalación Desaniciada"
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "La instalación nun se completó correutamente."
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "Desinstalando"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "Por favor espera mientres $(^NameDA) se desinstala."
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "Desinstalación Completada"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "La desinstalación completóse correutamente."
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "Desinstalación Desaniciada"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "La desinstalación nun se completó correutamente."
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "Completando l'Asistente d'Instalación de $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "$(^NameDA) foi instaláu nel to sistema.$\r$\n$\r$\nCalca Finar pa zarrar esti asistente."
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "El to sistema tien de reaniciase pa que pueda completase la instalación de $(^NameDA). ¿Quies reaniciar agora?"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "Completando l'Asistente de Desinstalación de $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "$(^NameDA) foi desinstaláu del to sistema.$\r$\n$\r$\nCalca Finar pa zarrar esti asistente."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "El to ordenador tien que reaniciar pa finar la desinstalación de $(^NameDA). ¿Quies reiniciar agora?"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "Reaniciar agora"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "Deseo reaniciar manualmente más sero"
  ${LangFileString} MUI_TEXT_FINISH_RUN "&Executar $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "&Ver Lléame"
  ${LangFileString} MUI_BUTTONTEXT_FINISH "&Finar"  
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "Escoyer Carpeta del Menú Aniciu"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "Escueye una Carpeta del Menú Aniciu pa los accesos direutos de $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "Seleiciona una carpeta del Menú Aniciu na que quieras criar los accesos direutos del programa. Tamién puedes introducir un nome pa criar una nueva carpeta."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "Non criar accesos direutos"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "Desinstalar $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "Desaniciar $(^NameDA) del to sistema."
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "¿De xuru que quies colar de la instalación de $(^Name)?"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "¿De xuru que quies colar de la desinstalación de $(^Name)?"
!endif

!ifdef MULTIUSER_INSTALLMODEPAGE
  ${LangFileString} MULTIUSER_TEXT_INSTALLMODE_TITLE "Escoyer Usuarios"
  ${LangFileString} MULTIUSER_TEXT_INSTALLMODE_SUBTITLE "Escueye los usuarios pa los cuales quies instalar $(^NameDA)."
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_TOP "Seleiciona si quies instalar $(^NameDA) namái pa tí o pa tolos usuarios d'esti Ordenador.$(^ClickNext)"
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_ALLUSERS "Instalación pa cualisquier usuariu d'esti ordenador"
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_CURRENTUSER "Instalación namái pa mí"
!endif
