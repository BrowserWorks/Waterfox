;Language: Georgian (1079)
;Translation by David Huriev and format updated by Jim Park

!insertmacro LANGFILE "Georgian" = "ქართული" "Kartuli"

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "მოგესალმებათ $(^NameDA)–ის საინსტალაციო პროგრამა"
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "ეს პროგრამა ჩატვირთავს $(^NameDA)–ს თქვენს კომპიუტერში.$\r$\n$\r$\nჩატვირთვამდე რეკომენდირებულია ყველა პროგრამის დახურვა. ამ შემთხვევაში პროგრამა სისტემურ ფაილებს ისე შეცვლის, რომ კომპიუტერს გადატვირთვა არ დასჭირდება.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "მოგესალმებათ $(^NameDA)–ის დეინსტალაციის ფანჯარა"
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT "ეს პროგრამა წაშლის $(^NameDA)–ს კომპიუტერიდან.$\r$\n$\r$\nწაშლამდე დახურეთ პროგრამა $(^NameDA).$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "სალიცენზიო შეთანხმება"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "სანამ $(^NameDA)–ს ჩატვირთავთ გაეცანით სალიცენზიო შეთანხმებას."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "თუ ეთანხმებით პირობებს, დააწკაპუნეთ ღილაკზე $\"ვეთანხმები$\". პროგრამის ჩასატვირთად აუცილებელია დათანხმება."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "თუ ეთანხმებით პირობებს, მონიშნეთ ფანჯარა ქვემოთ. $(^NameDA)–ის ჩასატვირთად აუცილებელია პირობებზე დათანხმება. $_CLICK"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "თუ ეთანხმებით პირობებს მონიშნეთ ქვემოთ მოცემული პირველი ვარიანტი. $(^NameDA)–ის ჩასატვირთად აუცილებელია პირობებზე დათანხმება. $_CLICK"
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "სალიცენზიო შეთანხმება"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "სანამ წაშლით $(^NameDA)–ს გაეცანით სალიცენზიო შეთანხმებას."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "თუ ეთანხმებით პირობებს დააწკაპუნეთ ღილაკზე $\"თანხმობა$\". $(^NameDA)–ის წასაშლელად საჭიროა პიროებებზე დათანხმება. $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "თუ ეთანხმებით პირობებს მონიშნეთ ფანჯარა ქვემოთ. $(^NameDA)–ს წასაშლელად საჭიროა პიროებებზე დათანხმება. $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "თუ ეთანხმებით პირობებს მონიშნეთ ქვემოთ მოცემული პირველი ვარიანტი. $(^NameDA)–ს წასაშლელად საჭიროა პიროებებზე დათანხმება. $_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "ტექსტის წასაკითხად გამოიყენეთ ღილაკები $\"PageUp$\" და $\"PageDown$\"."
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "ჩასატვირთი პროგრამის კომპონენტები"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "აირჩიეთ $(^NameDA)–ის კომპონენტები, რომლის ჩატვირთაც გსურთ."
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "პროგრამის კომპონენტები"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "აირჩიეთ $(^NameDA)–ის კომპონენტები, რომლის წაშლაც გსურთ."
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "შემადგენლობა"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "მიიყვანეთ მაუსი კომპონენტის სახელწოდებასთან მის სრულად წასაკითხად."
  !else
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "აირჩიეთ კომპონენტი, შემადგენლობის დასანახად."
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "ჩასატვირთი ფოლდერის მონიშვნა"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "აირჩიეთ $(^NameDA)–ს ჩასატვირთი ფოლდერი."
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "წასაშლელი ფოლდერის მონიშვნა"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "მიუთითეთ ფოლდერი, საიდანაც უნდა წაიშალოს $(^NameDA)."
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "ჩატვირთვა"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "დაელოდეთ, მიმდინარეობს $(^NameDA)–ის ჩატვირთვა..."
  ${LangFileString} MUI_TEXT_FINISH_TITLE "ჩატვირთვა დასრულებულია"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "პროგრამა წარმატებით ჩაიტვირთა."
  ${LangFileString} MUI_TEXT_ABORT_TITLE "ჩატვირთვა შეწყდა"
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "ჩატვირთვა არ დასრულებულა."
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "წაშლა"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "დაელოდეთ, მიმდინარეობს $(^NameDA)–ის წაშლა..."
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "წაიშალა"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "პროგრამა სრულად წაიშალა."
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "შეწყდა წაშლა"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "სრულად არ წაშლილა."
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "დასრულდა $(^NameDA)–ის საინსტალაციო პროგრამა"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "$(^NameDA) ჩაიტვირთა კომპიუტერში.$\r$\n$\r$\nდააწკაპუნეთ ღილაკზე $\"მზადაა$\" საინსტალაციო პროგრამიდან გამოსასვლელად."
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "$(^NameDA)–ის ჩატვირთვის დასასრულებლად გადატვირთეთ კომპიუტერი. ახლავე გსურთ მისი გადატვირთვა?"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "$(^NameDA)–ის წაშლის პროგრამა"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "$(^NameDA) წაიშალა კომპიუტერიდან.$\r$\n$\r$\nდააწკაპუნეთ ღილაკზე $\"მზადაა$\" წაშლის პროგრამიდან გამოსასვლელად."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "$(^NameDA)–ის სრულად წასაშლელად გადატვირთეთ კომპიუტერი. ახლავე გსურთ მისი გადატვირთვა?"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "დიახ, ახლავე გადაიტვირთოს"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "არა, მოგვიანებით გადავტვირთავ კომპიუტერს"
  ${LangFileString} MUI_TEXT_FINISH_RUN "$(^NameDA)–ის &ჩართვა"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "ReadMe &ფაილის ჩვენება" #FIXME: BUGBUG "ReadMe"?
  ${LangFileString} MUI_BUTTONTEXT_FINISH "&მზადაა"  
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "მენიუში არსებული ფოლდერი $\"სტარტი$\""
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "აირჩიეთ ფოლდერი მენიუში $\"სტარტი$\" $(^NameDA)–ის იარლიყების განსათავსებლად."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "აირჩიეთ ფოლდერი მენიუში $\"სტარტი$\", სადაც განთავსდება პროგრამის იარლიყები. თქვენ სხვა სახელიც შეგიძლიათ მიუთითოთ ახალი ფოლდერის შესაქმნელად."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "არ შეიქმნას იარლიყი"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "$(^NameDA)–ის წაშლა"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "$(^NameDA)–ის კომპიუტერიდან წაშლა."
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "ნამდვილად გსურთ უარი თქვათ $(^Name)–ის ჩატვირთვაზე?"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "ნამდვილად გსურთ უარი თქვათ $(^Name)–ის წაშლაზე?"
!endif
