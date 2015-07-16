;Language: Gàidhlig (1169)
;Le GunChleoc

!insertmacro LANGFILE "ScotsGaelic" "Scottish Gaelic" "Gàidhlig" "Gaidhlig"

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "Fàilte dhan draoidh stàlaidh aig $(^NameDA)"
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "Stiùiridh an draoidh seo tron stàladh aig $(^NameDA) thu.$\r$\n$\r$\nMholamaid gun dùin thu a h-uile aplacaid eile mus tòisich thu air an stàladh. Mar sin, 's urrainn dhuinn faidhlichean an t-siostam iomchaidh ùrachadh gun fheum air ath-thòiseachadh a' choimpiutair agad.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "Fàilte dhan draoidh dì-stàlaidh aig $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT "Stiùiridh an draoidh seo tron dì-stàladh aig $(^NameDA) thu.$\r$\n$\r$\nMus tòisich thu air an dì-stàladh, dèan cinnteach nach eil $(^NameDA) a' ruith.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "Aonta ceadachais"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "An toir thu sùil air teirmichean a' cheadachais mus stàlaich thu $(^NameDA)?"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "Ma ghabhas tu ri teirmichean an aonta, briog air $\"Gabhaidh mi ris$\" gus leantainn air adhart. Feumaidh tu gabhail ris an aonta mus urrainn dhut $(^NameDA) a stàladh."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "Ma ghabhas tu ri teirmichean an aonta, thoir cromag sa bhogsa gu h-ìosal. Feumaidh tu gabhail ris an aonta mus urrainn dhut $(^NameDA) a stàladh. $_CLICK"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Ma ghabhas tu ri teirmichean an aonta, tagh a' chiad roghainn gu h-ìosal. Feumaidh tu gabhail ris an aonta mus urrainn dhut $(^NameDA) a stàladh. $_CLICK"
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "Aonta ceadachais"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "An toir thu sùil air teirmichean a' cheadachais mus dì-stàlaich thu $(^NameDA)?"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "Ma ghabhas tu ri teirmichean an aonta, briog air $\"Gabhaidh mi ris$\" gus leantainn air adhart. Feumaidh tu gabhail ris an aonta mus urrainn dhut $(^NameDA) a dhì-stàladh."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "Ma ghabhas tu ri teirmichean an aonta, cuir cromag sa bhogsa gu h-ìosal. Feumaidh tu gabhail ris an aonta mus urrainn dhut $(^NameDA) a dhì-stàladh. $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Ma ghabhas tu ri teirmichean an aonta, tagh a' chiad roghainn gu h-ìosal. Feumaidh tu gabhail ris an aonta mus urrainn dhut $(^NameDA) a dhì-stàladh. $_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "Brùth air Page Down gus an corr dhen aonta a shealltainn."
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "Tagh co-phàirtean"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "Tagh na feartan aig $(^NameDA) a tha thu airson stàladh."
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "Tagh co-phàirtean"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "Tagh na co-phàirtean aig $(^NameDA) a tha thu airson dì-stàladh."
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "Tuairisgeul"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Cuir an luchag agad air co-phàirt gus a tuairisgeul a shealltainn."
  !else
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Tagh co-phàirt gus a tuairisgeul a shealltainn."
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "Tagh ionad an stàlaidh"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "Tagh am pasgan sa thèid $(^NameDA) a stàladh."
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "Tagh ionad an dì-stàlaidh"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "Tagh am pasgan on a thèid $(^NameDA) a dhì-stàladh."
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "Ga stàladh"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "Fuirich ort fhad 's a tha $(^NameDA) ga stàladh."
  ${LangFileString} MUI_TEXT_FINISH_TITLE "Stàladh coileanta"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "Chaidh an stàladh a choileanadh gu soirbheachail."
  ${LangFileString} MUI_TEXT_ABORT_TITLE "Air sgur dhen stàladh"
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "Cha deach an stàladh a choileanadh."
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "Ga dhì-stàladh"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "Fuirich ort fhad 's a tha $(^NameDA) ga dhì-stàladh."
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "Dì-stàladh coileanta"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "Chaidh an dì-stàladh a choileanadh gu soirbheachail."
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "Air sgur dhen dì-stàladh"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "Cha deach an dì-stàladh a choileanadh."
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "A' coileanadh an draoidh stàlaidh aig $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "Chaidh $(^NameDA) a stàladh air a' choimpiutair agad.$\r$\n$\r$\nBriog air "Crìochnaich" gus an draoidh seo a dhùnadh."
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "Tha ath-thòiseachadh a dhìth air a' choimpiutair agad gus an stàladh aig $(^NameDA) a choileanadh. A bheil thu airson ath-thòiseachadh an-dràsta?"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "A' coileanadh an draoidh dì-stàlaidh aig $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "Chaidh $(^NameDA) a dhì-stàladh on choimpiutair agad.$\r$\n$\r$\nBriog air "Crìochnaich" gus an draoidh seo a dhùnadh."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "Tha ath-thòiseachadh a dhìth air a' choimpiutair agad gus an dì-stàladh aig $(^NameDA) a choileanadh. A bheil thu airson ath-thòiseachadh an-dràsta?"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "Ath-tòisich an-dràsta"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "Nì mi fhìn ath-thòiseachadh a làimh àm eile"
  ${LangFileString} MUI_TEXT_FINISH_RUN "&Ruith $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "&Seall am faidhle Leughmi"
  ${LangFileString} MUI_BUTTONTEXT_FINISH "&Crìochnaich"  
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "Tagh pasgan sa chlàr-taice tòiseachaidh"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "Tagh pasgan sa chlàr-taice tòiseachaidh airson na h-ath-ghoiridean aig $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "Tagh pasgan sa chlàr-taice tòiseachaidh sa bheil thu airson na h-ath-ghoiridean aig a' phrògram a chruthachadh. 'S urrainn dhut cuideachd ainm a chur a-steach gus pasgan ùr a chruthachadh."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "Na cruthaich ath-ghoiridean"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "Dì-stàlaich $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "Thoir $(^NameDA) air falbh on choimpiutair agad."
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "A bheil thu cinnteach gu bheil thu airson an stàladh aig $(^Name) fhàgail?"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "A bheil thu cinnteach gu bheil thu airson an dì-stàladh aig $(^Name) fhàgail?"
!endif

!ifdef MULTIUSER_INSTALLMODEPAGE
  ${LangFileString} MULTIUSER_TEXT_INSTALLMODE_TITLE "Tagh cleachdaichean"
  ${LangFileString} MULTIUSER_TEXT_INSTALLMODE_SUBTITLE "Tagh na cleachdaichean 's tu airson $(^NameDA) a stàladh air an son."
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_TOP "Tagh an stàlaich thu $(^NameDA) air do shon fhèin a-mhàin no airson a h-uile cleachdaiche air a' choimpiutair seo. $(^ClickNext)"
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_ALLUSERS "Stàlaich airson duine sam bith a chleachdas an coimpiutair seo"
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_CURRENTUSER "Na stàlaich ach air mo shon-sa"
!endif