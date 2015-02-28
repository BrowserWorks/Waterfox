;Language: Arabic (1025)
;Translation by asdfuae@msn.com
;updated by Rami Kattan

!insertmacro LANGFILE "Arabic" = "العربية" "Al-Arabiyyah"

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "مرحبا بك في مرشد إعداد $(^NameDA)"
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "سيساعدك هذا المرشد في تنصيب $(^NameDA).$\r$\n$\r$\nمن المفضل إغلاق جميع البرامج قبل التنصيب. سيساعد هذا في تجديد ملفات النظام دون الحاجة لإعادة تشغيل الجهاز.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "مرحبا بك في مرشد إزالة $(^NameDA) "
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT "هذا المرشد سيدلّك أثناء إزالة $(^NameDA).$\r$\n$\r$\n قبل البدء بالإزالة، يرجى التأكد من أن $(^NameDA) غير شغّال.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "إتفاقية‏ الترخيص"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "الرجاء مراجعة إتفاقية‏ الترخيص قبل تنصيب $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "عند الموافقة على شروط الإتفاقية‏، إضغط أوافق للمتابعة. يجب الموافقة على الإتفاقية‏ لتنصيب $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "عند الموافقة على شروط الإتفاقية‏، علّم مربع العلامة التالي. يجب الموافقة على الإتفاقية‏ لتنصيب $(^NameDA). $_CLICK"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "عند الموافقة على شروط الإتفاقية، إختر الخيار الأول من التالي. يجب الموافقة على الإتفاقية لتنصيب $(^NameDA). $_CLICK"
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "إتفاقية الترخيص"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "الرجاء مراجعة شروط الترخيص قبل إزالة $(^NameDA)."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "عند الموافقة على شروط الإتفاقية، إضغط على موافق. يجب الموافقة على الإتفاقية لإزالة $(^NameDA)."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "عند الموافقة على شروط الإتفاقية، علّم المربع العلامة التالي. يجب الموافقة على الإتفاقية لإزالة $(^NameDA). $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "عند الموافقة على شروط الإتفاقية، إختر الخيار الأول من التالي. يجب الموافقة على الإتفاقية لإزالة $(^NameDA). $_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "إضعط مفتاح صفحة للأسفل لرؤية باقي الإتفاقية"
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "إختر المكونات"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "إختر ميزات $(^NameDA) المراد تنصيبها."
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "إختر المكونات"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "إختر ميزات $(^NameDA) المراد إزالتها."
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "الوصف"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "أشر بالفأرة فوق أحد المكونات لرؤية الوصف"
  !else
    #FIXME:MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "إختر موقع التنصيب"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "إختر المجلد المراد تنصيب $(^NameDA) فيه."
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "إختر موقع المزيل"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "إختر المجلد الذي سيزال منه $(^NameDA)."
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "تنصيب"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "الرجاء الإنتظار أثناء تنصيب $(^NameDA)."
  ${LangFileString} MUI_TEXT_FINISH_TITLE "إنتهى التنصيب"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "إنتهت عملية التنصيب بنجاح."
  ${LangFileString} MUI_TEXT_ABORT_TITLE "إلغاء التنصيب"
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "لم ينتهي التنصيب بنجاح."
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "إزالة"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "الرجاء الإنتظار أثناء إزالة $(^NameDA)."
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "إنتهى"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "إنتهت عملية الإزالة بنجاح."
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "إلغاء الإزالة"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "لم تنتهي الإزالة بنجاح."
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "إنهاء مرشد إعداد $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "لقد تم تنصيب $(^NameDA) على الجهاز$\r$\n$\r$\nإضغط إنهاء لإغلاق مرشد الإعداد."
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "يجب إعادة تشغيل الجهاز لإنهاء تنصيب $(^NameDA). هل تريد إعادة التشغيل الآن؟"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "إنهاء مرشد إزالة $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "لقد تم إزالة $(^NameDA) من الجهاز.$\r$\n$\r$\n إضغط إنهاء لإغلاق المرشد."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "يجب إعادة تشغيل الجهاز لإنهاء إزالة $(^NameDA). هل تريد إعادة التشغيل الآن؟"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "أعد التشغيل الآن"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "أرغب في إعادة تشغيل الجهاز في وقت لاحق"
  ${LangFileString} MUI_TEXT_FINISH_RUN "&شغل $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "اعرض& أقرأني"
  ${LangFileString} MUI_BUTTONTEXT_FINISH "&إنهاء"  
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "إختر مجلد قائمة ابدأ"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "إختر مجلد قائمة ابدأ لإختصارات $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "إختر المجلد في قائمة ابدأ الذي ستنشأ فيه إختصارات البرنامج. يمكن أيضا كتابة إسم لإنشاء مجلد جديد."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "لا تنشئ إختصارات"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "إزالة $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "إزالة $(^NameDA) من الجهاز."
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "هل أنت متأكد من إغلاق منصّب $(^Name)؟"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "هل أنت متأكد من أنك الخروج من مزيل $(^Name)؟"
!endif
