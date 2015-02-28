;Language: 'Chinese (Simplified)' (2052)
;Translator: Kii Ali <kiiali@cpatch.org>,<kiiali@ms1.url.com.tw>, <kiiali@pchome.com.tw>
;Revision date: 2010-09-28

!insertmacro LANGFILE "SimpChinese" "Chinese (Simplified)" "中文(简体)" "Hanyu (Jiantizi)"

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "欢迎使用 $(^NameDA) 安装向导"
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "这个向导将指引你完成 $(^NameDA) 的安装进程。$\r$\n$\r$\n在开始安装之前，建议先关闭其他所有应用程序。这将允许“安装程序”更新指定的系统文件，而不需要重新启动你的计算机。$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "欢迎使用 $(^NameDA) 解除安装向导"
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT "这个向导将全程指引你 $(^NameDA) 的解除安装进程。$\r$\n$\r$\n在开始解除安装之前，确懧 $(^NameDA) 并未运行当中。$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "许可证协议"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "在安装 $(^NameDA) 之前，请检阅授权条款。"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "如果你接受协议中的条款，单击 [我同意(I)] 继续安装。必须要接受协议才能安装 $(^NameDA) 。"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "如果你接受协议中的条款，单击下方的勾选框。必须要接受协议才能安装 $(^NameDA)。$_CLICK"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "如果你接受协议中的条款，选择下方第一个选项。必须要接受协议才能安装 $(^NameDA)。$_CLICK"
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "许可证协议"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "在解除安装 $(^NameDA) 之前，请检阅授权条款。"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "如果你接受协议中的条款，单击 [我同意(I)] 继续解除安装。如果你选定 [取消(C)] ，安装程序将会关闭。必须要接受协议才能解除安装 $(^NameDA) 。"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "如果你接受协议中的条款，单击下方的勾选框。必须要接受协议才能解除安装 $(^NameDA)。$_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "如果你接受协议中的条款，选择下方第一个选项。必须要接受协议才能解除安装 $(^NameDA)。$_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "检阅协议的其余部分，按 [PgDn] 往下卷动页面。"
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "选择组件"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "选择你想要安装 $(^NameDA) 的那些功能。"
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "选定组件"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "选定 $(^NameDA) 当中你想要解除安装的功能。"
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "描述"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "停悬你的鼠标指针到组件之上，便可见到它的描述。"
  !else
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "选择一个组件，便可见到它的描述。"
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "选定安装位置"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "选定 $(^NameDA) 要安装的文件夹。"
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "选定解除安装位置"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "选定 $(^NameDA) 要解除安装的文件夹。"
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "正在安装"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "$(^NameDA) 正在安装，请等候。"
  ${LangFileString} MUI_TEXT_FINISH_TITLE "安装完成"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "安装程序已成功地运行完成。"
  ${LangFileString} MUI_TEXT_ABORT_TITLE "安装己中止"
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "安装程序并未成功地运行完成。"
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "正在解除安装"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "$(^NameDA) 正在解除安装，请等候。"
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "解除安装已完成"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "解除安装程序已成功地运行完成。"
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "解除安装已中止"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "解除安装程序并未成功地运行完成。"
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "正在完成 $(^NameDA) 安装向导"
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "$(^NameDA) 已安装在你的系统。$\r$\n单击 [完成(F)] 关闭此向导。"
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "你的系统需要重新启动，以便完成 $(^NameDA) 的安装。现在要重新启动吗？"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "正在完成 $(^NameDA) 解除安装向导"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "$(^NameDA) 已从你的计算机解除安装。$\r$\n$\r$\n单击 [完成] 关闭这个向导。"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "计算机需要重新启动，以便完成 $(^NameDA) 的解除安装。现在想要重新启动吗？"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "是，现在重新启动(&Y)"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "否，我稍后再自行重新启动(&N)"
  ${LangFileString} MUI_TEXT_FINISH_RUN "运行 $(^NameDA)(&R)"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "显示“自述文件”(&M)"
  ${LangFileString} MUI_BUTTONTEXT_FINISH "完成(&F)"  
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "选择“开始菜单”文件夹"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "选择“开始菜单”文件夹，用于程序的快捷方式。"
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "选择“开始菜单”文件夹，以便创建程序的快捷方式。你也可以输入名称，创建新文件夹。"
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "不要创建快捷方式(&N)"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "解除安装 $(^NameDA)"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "从你的计算机解除安装 $(^NameDA) 。"
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "你确实要退出 $(^Name) 安装程序吗？"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "你确实要退出 $(^Name) 解除安装程序吗？"
!endif

!ifdef MULTIUSER_INSTALLMODEPAGE
  ${LangFileString} MULTIUSER_TEXT_INSTALLMODE_TITLE "选定用户"
  ${LangFileString} MULTIUSER_TEXT_INSTALLMODE_SUBTITLE "选定你想要安装 $(^NameDA) 给那一个用户。"
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_TOP "选择你想要安装 $(^NameDA) 给自己使用，或此计算机的所有用户。 $(^ClickNext)"
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_ALLUSERS "安装给此计算机的所有用户(&A)"
  ${LangFileString} MULTIUSER_INNERTEXT_INSTALLMODE_CURRENTUSER "安装给自己(&M)"
!endif
