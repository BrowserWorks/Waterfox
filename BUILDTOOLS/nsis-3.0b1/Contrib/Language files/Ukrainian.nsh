;Language: Ukrainian (1058)
;By Yuri Holubow, http://www.Nash-Soft.com
;Correct by Osidach Vitaly (Vit_Os2)

!insertmacro LANGFILE "Ukrainian" = "Українська" "Ukrayins'ka"

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "Ласкаво просимо до Майстра Встановлення $(^NameDA)"
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "Дана програма встановить $(^NameDA) на Ваш комп'ютер.$\r$\n$\r$\nРекомендовано закрити всі програми перед початком інсталяції. Це дозволить програмі встановлення оновити системні файли без перезавантаження системи.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "Ласкаво просимо до Майстра Видалення $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT "Даний майстер допоможе видалити $(^NameDA).$\r$\n$\r$\nПеред початком видалення, перевірте, чи не запущено $(^NameDA).$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "Ліцензійна Угода"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "Перегляньте ліцензію перед встановленням $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "Якщо Ви приймаєте всі умови Угоди, натисніть на кнопку Згоден. Ви повинні прийняти умови Угоди для встановлення $(^NameDA)."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "Якщо Ви приймаєте всі умови Угоди, встановіть відмітку у квадратику нижче. Ви повинні прийняти умови Угоди для встановлення $(^NameDA). $_CLICK"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Якщо Ви приймаєте всі умови Угоди, виберіть перший варіант з тих що нижче. Ви повинні прийняти умови Угоди для встановлення $(^NameDA). $_CLICK"
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "Ліцензійна угода"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "Прочитайте умови ліцензійної угоди перед видаленням $(^NameDA)."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "Якщо Ви приймаєте всі умови Угоди, натисніть на кнопку Згоден. Ви повинні прийняти умови Угоди для видалення $(^NameDA)."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "Якщо Ви приймаєте всі умови Угоди, встановіть відмітку у квадратику нижче. Ви повинні прийняти умови Угоди для видалення $(^NameDA). $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Якщо Ви приймаєте всі умови Угоди, виберіть перший варіант з тих, що нижче. Ви повинні прийняти умови Угоди для видалення $(^NameDA). $_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "Натисніть PageDown щоб переміститись вниз угоди."
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "Оберіть компоненти"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "Оберіть компоненти $(^NameDA) які Ви бажаєте встановити."
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "Компоненти програми"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "Оберіть які компоненти $(^NameDA) Ви бажаєте видалити."
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "Опис"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Підведіть вашу мишку до компонента, щоб побачити його опис."
  !else
    #FIXME:MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO 
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "Оберіть теку встановлення"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "Оберіть теку для встановлення $(^NameDA)."
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "Вибір теки для видалення"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "Оберіть теку, з якої Ви бажаєте видалити $(^NameDA)."
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "Копіювання файлів"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "Зачекайте, доки програма встановлення скопіює всі необхідні файли $(^NameDA)."
  ${LangFileString} MUI_TEXT_FINISH_TITLE "Встановлення завершено"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "Встановлення успішно завершено."
  ${LangFileString} MUI_TEXT_ABORT_TITLE "Встановлення перервана"
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "Встановлення не було успішно завершено."
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "Видалення"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "Зачекайте, йде видалення файлів $(^NameDA)."
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "Видалення завершено"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "Видалення програми було успішно завершено."
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "Видалення перервано"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "Видалення не було виконано повністю."
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "Завершення майстра встановлення $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "$(^NameDA) встановлено на ваш комп'ютер.$\r$\n$\r$\nНатисніть Кінець для виходу."
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "Для того, щоб завершити встановлення $(^NameDA) Ваш комп'ютер повинен перезавантажитися. Зробити це зараз?"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "Завершення Майстра Видалення $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "$(^NameDA) видалений з вашого комп'ютера.$\r$\n$\r$\nНатисніть Вихід, щоб закрити Майстра."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "Для того, щоб закінчити видалення $(^NameDA) ваш комп'ютер повинен перезавантажитися. Ви бажаєте зробити це зараз?"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "Перезавантажитися зараз"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "Я хочу перезавантажитися власноруч пізніше"
  ${LangFileString} MUI_TEXT_FINISH_RUN "&Запустити $(^NameDA)"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "&Показати інформацію про програму"
  ${LangFileString} MUI_BUTTONTEXT_FINISH "&Кінець"  
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "Тека в меню Пуск"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "Оберіть теку в меню Пуск для ярликів програми."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "Оберіть теку в меню Пуск в яку будуть поміщені ярлики для встановленої програми. Ви також можете ввести інше ім'я для створення нової теки."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "Не створювати ярлики"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "Видалення $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "Видалення $(^NameDA) з вашого комп'ютера."
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "Ви впевнені, що бажаєте покинути встановлення $(^Name)?"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "Ви впевнені що бажаєте покинути Майстер Видалення $(^Name)?"
!endif
