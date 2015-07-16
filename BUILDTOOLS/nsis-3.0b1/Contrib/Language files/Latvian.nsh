;Language: Latviešu [Latvian] - (1062)
;By Valdis Griķis
;Corrections by Kristaps Meņģelis / x-f (x-f 'AT' inbox.lv)

!insertmacro LANGFILE "Latvian" = "Latviešu" "Latviesu"

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "Esiet sveicināti '$(^NameDA)' uzstādīšanas vednī"
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "Šis uzstādīšanas vednis jums palīdzēs veikt '$(^NameDA)' uzstādīšanu.$\r$\n$\r$\nĻoti ieteicams aizvērt citas programmas pirms šīs programmas uzstādīšanas veikšanas. Tas ļaus atjaunot svarīgus sistēmas failus bez datora pārstartēšanas.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "Esiet sveicināti '$(^NameDA)' atinstalēšanas vednī"
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT "Šis vednis jums palīdzēs veikt '$(^NameDA)' atinstalēšanu.$\r$\n$\r$\nPirms sākt atinstalēšanas procesu, pārliecinieties, vai '$(^NameDA)' pašlaik nedarbojas.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "Licences līgums"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "Lūdzu izlasiet licences līgumu pirms '$(^NameDA)' uzstādīšanas."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "Ja piekrītat licences līguma noteikumiem, spiediet 'Piekrītu', lai turpinātu uzstādīšanu. Jums ir jāpiekrīt licences noteikumiem, lai uzstādītu '$(^NameDA)'."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "Ja piekrītat licences līguma noteikumiem, tad atzīmējiet izvēles rūtiņu. Jums ir jāpiekrīt licences noteikumiem, lai uzstādītu '$(^NameDA)'. $_CLICK"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Ja piekrītat licences līguma noteikumiem, tad izvēlieties pirmo zemākesošo opciju. Jums ir jāpiekrīt licences noteikumiem, lai uzstādītu '$(^NameDA)'. $_CLICK"
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "Licences līgums"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "Lūdzu izlasiet licences līgumu pirms '$(^NameDA)' atinstalēšanas."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "Ja piekrītat licences noteikumiem, spiediet 'Piekrītu', lai turpinātu. Jums ir jāpiekrīt licences noteikumiem, lai atinstalētu '$(^NameDA)'."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "Ja piekrītat licences līguma noteikumiem, tad iezīmējiet izvēles rūtiņu. Jums ir jāpiekrīt licences noteikumiem, lai atinstalētu '$(^NameDA)'. $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Ja piekrītat licences līguma noteikumiem, tad izvēlieties pirmo zemākesošo opciju. Jums ir jāpiekrīt licences noteikumiem, lai atinstalētu '$(^NameDA)'. $_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "Spiediet 'Page Down', lai aplūkotu visu līgumu."
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "Izvēlieties komponentus"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "Izvēlieties nepieciešamās '$(^NameDA)' sastāvdaļas, kuras uzstādīt."
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "Izvēlieties komponentus"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "Izvēlieties nepieciešamās '$(^NameDA)' sastāvdaļas, kuras atinstalēt."
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "Apraksts"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Novietojiet peles kursoru uz komponenta, lai tiktu parādīts tā apraksts."
  !else
    #FIXME:MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO 
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "Izvēlieties uzstādīšanas mapi"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "Izvēlieties mapi, kurā uzstādīt '$(^NameDA)'."
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "Izvēlieties atinstalēšanas mapi"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "Izvēlieties mapi, no kuras notiks '$(^NameDA)' atinstalēšana."
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "Notiek uzstādīšana"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "Lūdzu uzgaidiet, kamēr notiek '$(^NameDA)' uzstādīšana."
  ${LangFileString} MUI_TEXT_FINISH_TITLE "Uzstādīšana pabeigta"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "Uzstādīšana noritēja veiksmīgi."
  ${LangFileString} MUI_TEXT_ABORT_TITLE "Uzstādīšana atcelta"
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "Uzstādīšana nenoritēja veiksmīgi."
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "Notiek atinstalēšana"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "Lūdzu uzgaidiet, kamēr '$(^NameDA)' tiek atinstalēta."
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "Atinstalēšana pabeigta"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "Atinstalēšana noritēja veiksmīgi."
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "Atinstalēšana atcelta"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "Atinstalēšana nenoritēja veiksmīgi."
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "Tiek pabeigta '$(^NameDA)' uzstādīšana"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "'$(^NameDA)' tika veiksmīgi uzstādīta jūsu datorā.$\r$\n$\r$\nNospiediet 'Pabeigt', lai aizvērtu vedni."
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "Jūsu datoru ir nepieciešams pārstartēt, lai pabeigtu '$(^NameDA)' uzstādīšanu. Vai vēlaties pārstartēt datoru tūlīt?"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "Tiek pabeigta '$(^NameDA)' atinstalācija"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "'$(^NameDA)' tika veiksmīgi izdzēsta no jūsu datora.$\r$\n$\r$\nNospiediet 'Pabeigt', lai aizvērtu vedni."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "Jūsu datoru nepieciešams pārstartēt, lai pabeigtu '$(^NameDA)' atinstalēšanu. Vai vēlaties pārstartēt datoru tūlīt?"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "Pārstartēt tūlīt"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "Es vēlos pārstartēt pats vēlāk"
  ${LangFileString} MUI_TEXT_FINISH_RUN "P&alaist '$(^NameDA)'"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "Pa&rādīt LasiMani failu"
  ${LangFileString} MUI_BUTTONTEXT_FINISH "&Pabeigt"  
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "Izvēlieties 'Start Menu' folderi"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "Izvēlieties 'Start Menu' mapi '$(^NameDA)' saīsnēm."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "Izvēlieties 'Start Menu' mapi, kurā tiks izveidotas programmas saīsnes. Varat arī pats izveidot jaunu mapi."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "Neveidot saīsnes"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "'$(^NameDA)' atinstalēšana"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "Dzēst '$(^NameDA)' no jūsu datora."
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "Vai tiešām vēlaties pārtraukt '$(^Name)' uzstādīšanu?"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "Vai tiešām vēlaties pārtraukt '$(^Name)' atinstalēšanu?"
!endif
