;Language: Farsi (1065)
;By FzerorubigD - FzerorubigD@gmail.com - Thanx to all people help me in forum.persiantools.com

!insertmacro LANGFILE "Farsi" "Persian" "فارسی" "Farsi"

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "به برنامه نصب $(^NameDA) خوش آمدید."
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "این برنامه شما را در نصب $(^NameDA) یاری می‌کند.$\r$\n$\r$\nتوصیه می‌کنیم کلیه برنامه‌های در حال اجرا را ببندید. این به برنامه نصب اجازه می‌دهد که فایل‌های لازم را بدون نیاز به راه اندازی دوباره‌ی کامپیوتر شما به روز کند.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "به برنامه حذف $(^NameDA) خوش آمدید."
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT " این برنامه برای حذف $(^NameDA) به شما کمک می‌کند.$\r$\n$\r$\nقبل از حذف $(^NameDA) مطمئن شوید این برنامه در حال اجرا نباشد.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "توافقنامه نصب"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "لطفا پیش از نصب $(^NameDA) مفاد توافقنامه را مرور کنید."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "اگر کلیه بندهای توافقنامه را قبول دارید دکمه‌ی موافقم را بفشارید. برای نصب $(^NameDA) شما بایست این توافقنامه را قبول کنید."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "اگر کلیه بندهای توافقنامه را قبول دارید تیک زیر را انتخاب کنید. برای نصب $(^NameDA) شما بایست این توافقنامه را قبول کنید. $_CLICK"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "اگر کلیه بندهای توافقنامه را قبول دارید گزینه اول را انتخاب کنید. برای نصب $(^NameDA) شما بایست این توافقنامه را قبول کنید. $_CLICK"
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "توافقنامه حذف"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "لطفا کلیه بندهای این توافقنامه را قبل ار حذف $(^NameDA) مرور کنید."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "اگر کلیه بندهای توافقنامه را قبول دارید دکمه‌ی موافقم را بفشارید. برای حذف $(^NameDA) شما بایست این توافقنامه را قبول کنید."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "اگر کلیه بندهای توافقنامه را قبول دارید تیک زیر را انتخاب کنید. برای حذف $(^NameDA) شما بایست این توافقنامه ر قبول کنید. $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "اگر کلیه بندهای توافقنامه را قبول دارید گزینه اول را انتخاب کنید. برای حذف $(^NameDA) شما بایست این توافقنامه ر قبول کنید. $_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "برای دیدن متن به صورت کامل از کلید Page Down استفاده کنید."
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "انتخاب اجزای برنامه "
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "اجزایی از $(^NameDA) که می‌خواهید نصب شوند را انتخاب کنید."
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "انتخاب اجزای برنامه"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "اجزایی از $(^NameDA) را که می‌خواهید حذف کنید انتخاب کنید."
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "توضیحات"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "نشانگر ماوس را بر روی اجزایی که می‌خواهید ببرید تا توضیحات آن را ببینید."
  !else
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "يكي از گزينه هاي نصب را انتخاب كنيد تا توضيحات مربوط به آن را ببينيد."
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "انتخاب پوشه نصب"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "پوشه‌ای که می‌خواهید $(^NameDA) در آن نصب شود را انتخاب کنید."
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "پوشه حذف را انتخاب کنید"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "پوشه‌ای که می‌خواهید $(^NameDA) را از آن حذف کنید انتخاب کنید."
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "نصب برنامه"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "لطفا مدت زمانی که $(^NameDA) در حال نصب است را صبر کنید."
  ${LangFileString} MUI_TEXT_FINISH_TITLE "نصب پایان یافت"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "برنامه نصب با موفقیت پایان یافت."
  ${LangFileString} MUI_TEXT_ABORT_TITLE "برنامه نصب لغو شد."
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "برنامه نصب به صورت نیمه تمام پایان یافت."
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "حذف برنامه"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "لطفا مدت زمانی که $(^NameDA) در حال حذف است را صبر کنید."
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "حذف پایان یافت"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "برنامه حذف با موفقیت پایان یافت."
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "برنامه حذف لغو شد"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "برنامه حذف به صورت نیمه تمام پایان یافت"
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "برنامه نصب $(^NameDA) پایان یافت"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "$(^NameDA) بر روی کامپیوتر شما نصب شد.$\r$\n$\r$\nبر روی دکمه‌ی پایان برای خروج از این برنامه کلیک کنید."
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "کامپیوتر شما برای تکمیل نصب $(^NameDA) بایستی دوباره راه اندازی شود. آیا می‌خواهید این کار را الان انجام دهید؟"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "برنامه حذف $(^NameDA) پایان یافت"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "$(^NameDA) از روی کامپیوتر شما حذف شد.$\r$\n$\r$\nبر روی دکمه‌ی پایان برای خروج از این برنامه کلیک کنید."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "کامپیوتر شما برای تکمیل حذف$(^NameDA) بایست دوباره راه اندازی شود.آیا می‌خواهید این کار را الان انجام دهید؟"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "راه اندازی مجدد."
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "من خودم این کار را انجام خواهم داد."
  ${LangFileString} MUI_TEXT_FINISH_RUN "&اجرای $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "&نمایش فایل توضیحات"
  ${LangFileString} MUI_BUTTONTEXT_FINISH "&پایان"
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "انتخاب پوشه در منوی برنامه‌ها"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "پوشه‌ای که می‌خواهید میانبرهای $(^NameDA) در آن قرار بگیرند را انتخاب کنید."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "پوشه‌ای در منوی برنامه‌ها که می‌خواهید میانبرهای برنامه در آنجا ایجاد شوند را انتخاب کنید. برای ایجاد یک پوشه جدید میتوانید یک نام تایپ کنید."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "میانبری نساز"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "حذف $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "پاک کردن $(^NameDA) از روی کامپیوتر شما."
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "آیا مطمئنید که می‌خواهید از برنامه نصب $(^Name) خارج شوید؟"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "آیا مطمئنید که می‌خواهید از برنامه حذف $(^Name) خارج شوید؟"
!endif
