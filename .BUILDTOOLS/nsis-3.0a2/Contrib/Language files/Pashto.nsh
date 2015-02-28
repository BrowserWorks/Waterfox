;Language: Pashto (1123)
;By Pakhtosoft - www.pakhtosoft.com

!insertmacro LANGFILE "Pashto" = "پښتو" "Pashto"

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "امسته اسانګر ته ښه راغلاست $(^NameDA) د "
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT ".لګونې ته يوسي $(^NameDA) دا اسانګر به تاسې د$\r$\n$\r$\n.د امستې د پېلولو نه مخکښې د نورو ساوترو د بندولو سپارښتنه کوو. د دې کار په کولو سره به دا شونه شي چې پرته له کمپيوټر د بياپيلاته اړينې غونډال دوتنې اوسمهاله شي$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "نالګاو اسانګر ته ښه راغلاست $(^NameDA) د"
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT ".نالګونې ته يوسي $(^NameDA) دا اسانګر به تاسې د$\r$\n$\r$\n.نه وي پرانيستل شوی $(^NameDA) د نالګاو د پېلولو نه مخکښې، ځان ډاډمن کړﺉ چې$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_WELCOMEPAGE | MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_BUTTONTEXT_FINISH "&پای"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "منښتليک تړون"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE ".لګولو نه مخکښې منښتليک توکي وګورﺉ $(^NameDA) د"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM ".د لګاونې لپاره د تړون منل اړين دي $(^NameDA) که چېرې تړون توکي منئ، زه منم ټک وهئ چې مخکښې ولاړ شئ. د"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX ".لګولو لپاره د تړون منل اړين دي $(^NameDA) که چېرې د تړون توکي منئ، نو لاندې خوښبکس ټک وهئ. د $_CLICK"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS ".لګولو لپاره د تړون منل اړين دي $(^NameDA) که چېرې د تړون توکي منئ، نو لاندې لمړی غوراوی ټک وهئ. د $_CLICK"
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "منښتليک تړون"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE ".نالګولو نه مخکښې د منښتليک توکي وګورﺉ $(^NameDA) د"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM ".نالګولو لپاره د تړون منل اړين دي $(^NameDA) که چېرې د تړون توکي منئ، زه منم ټک وهئ چې مخکښې ولاړ شئ. د"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX ".نالګولو لپاره د تړون منل اړين دي $(^NameDA) که چېرې د تړون توکي منئ، نو لاندې خوښبکس ټک وهئ. د $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS ".نالګولو لپاره د تړون منل اړين دي $(^NameDA) که چېرې د تړون توکي منئ، نو لاندې لمړی غوراوی ټک وهئ. د $_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP ".د تړون د نورې برخې کتلو لپاره پېج ډاون کيلۍ ووهئ"
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "رغتوکي خوښ کړﺉ"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE ".کومې ځانګړتياوې چې لګول غواړﺉ، خوښ يې کړﺉ $(^NameDA) د"
!endif

!ifdef MUI_UNCOMPONENETSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "رغتوکي خوښ کړﺉ"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE ".کومې ځانګړتياوې چې نالګول غواړﺉ، خوښ يې کړﺉ $(^NameDA) د"
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "سپړاوي"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO ".د رغتوکي سپړاوي کتلو لپاره موږک د هغې دپاسه ودروﺉ"
  !else
    #FIXME:MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO 
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "لګاو ځای وټاکئ"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE ".لګول غواړﺉ ويې ټاکئ $(^NameDA) په کومه پوښۍ کښې چې"
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "نالګاو ځای وټاکئ"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE ".نالګول غواړﺉ ويې ټاکئ $(^NameDA) د کومې پوښۍ نه چې"
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "لګيږي"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE ".په بشپړه توګه ولګول شي $(^NameDA) مهرباني وکړﺉ لږه تمه وکړﺉ ترڅو"
  ${LangFileString} MUI_TEXT_FINISH_TITLE "لګونه بشپړه شوه"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE ".امسته په برياليتوب سرته ورسېده"
  ${LangFileString} MUI_TEXT_ABORT_TITLE "لګونه بنده شوه"
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE ".امسته په برياليتوب سرته ونه رسېده"
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "نالګيږي"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE ".په بشپړه توګه ونالګول شي $(^NameDA) مهرباني وکړﺉ لږه تمه وکړﺉ ترڅو"
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "نالګونه بشپړه شوه"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE ".نالګاو په برياليتوب سرته ورسېدو"
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "نالګونه بنده شوه"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE ".نالګاو په برياليتوب سرته ونه رسېدو"
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "امسته اسانګر بشپړيږي $(^NameDA) د"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT ".ستاسې په کمپيوټر کښې ولګول شو $(^NameDA)$\r$\n$\r$\nد دې اسانګر د بندولو لپاره پای ته ټک ورکړﺉ"
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "لګاو بشپړولو لپاره ستاسې کمپيوټر بياپېلات ته اړتيا لري. ايا اوس بياپېلون کول غواړﺉ؟ $(^NameDA) د"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "نالګاو اسانګر بشپړيږي $(^NameDA) د"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT ".ستاسې له کمپيوټر نه ونالګول شو $(^NameDA)$\r$\n$\r$\nد دې اسانګر د بندولو لپاره پای ته ټک ورکړﺉ"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT " نالګاو بشپړولو لپاره ستاسې کمپيوټر بياپېلات ته اړتيا لري. ايا اوس بياپېلون کول غواړﺉ؟ $(^NameDA) د"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "سمدستي بياپېلون"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "وروسته زه پخپله بياپېلون کول غواړم"
  ${LangFileString} MUI_TEXT_FINISH_RUN "&پرانيستل $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "&ماولوله ښودل"
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "پېل غورنۍ پوښۍ خوښه کړﺉ"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "د لنډلارو لپاره يو پېل غورنۍ پوښۍ خوښه کړﺉ $(^NameDA) د"
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP ".د پېل غورنۍ هغه پوښۍ چې د ساوتري لنډلاري پکښې جوړول غواړﺉ خوښه کړﺉ. نوې پوښۍ جوړولو لپاره نوم هم ليکلی شئ"
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "لنډلاري مه جوړوه"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "نالګول $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE ".د خپل کمپيوټر نه ړنګول $(^NameDA)"
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "امسته بندول غواړﺉ؟ $(^Name) ايا په ډاډمنه توګه د"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "نالګاو بندول غواړﺉ؟ $(^Name) ايا په ډاډمنه توګه د"
!endif
