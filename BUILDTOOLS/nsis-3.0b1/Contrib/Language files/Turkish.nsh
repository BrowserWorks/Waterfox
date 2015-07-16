;Language: Turkish (1055)
;By Çagatay Dilsiz(Chagy)
;Updated by Fatih BOY (fatih_boy@yahoo.com)

!insertmacro LANGFILE "Turkish" = "Türkçe" "Turkce"

!ifdef MUI_WELCOMEPAGE
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TITLE "$(^NameDA) Kurulum sihirbazına hoş geldiniz"
  ${LangFileString} MUI_TEXT_WELCOME_INFO_TEXT "Bu sihirbaz size $(^NameDA) kurulumu boyunca rehberlik edecektir.$\r$\n$\r$\nKurulumu başlatmadan önce çalışan diğer programlari kapatmanızı öneririz. Böylece bilgisayarınızı yeniden başlatmadan bazı sistem dosyaları sorunsuz kurulabilir.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_UNWELCOMEPAGE
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TITLE "$(^NameDA) Programını Kaldırma Sihirbazına Hoş Geldiniz"
  ${LangFileString} MUI_UNTEXT_WELCOME_INFO_TEXT "Bu sihirbaz size $(^NameDA) programının kadırılımı boyunca rehberlik edecektir.$\r$\n$\r$\nKaldırım işlemeni başlatmadan önce çalışan diğer programlari kapatmanızı öneririz. Böylece bilgisayarınızı yeniden başlatmadan bazı sistem dosyaları sorunsuz kaldırılabilir.$\r$\n$\r$\n$_CLICK"
!endif

!ifdef MUI_LICENSEPAGE
  ${LangFileString} MUI_TEXT_LICENSE_TITLE "Lisans Sözleşmesi"
  ${LangFileString} MUI_TEXT_LICENSE_SUBTITLE "Lütfen $(^NameDA) programını kurmadan önce sözleşmeyi okuyunuz."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM "Sözleşme koşullarını kabul ediyorsanız, 'Kabul Ediyorum'a basınız. $(^NameDA) programını kurmak için sözleşme koşullarını kabul etmelisiniz."
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_CHECKBOX "Sözleşme koşullarını kabul ediyorsanız, aşağıdaki onay kutusunu doldurunuz. $(^NameDA) programını kurmak için sözleşme koşullarını kabul etmelisiniz. $_CLICK"
  ${LangFileString} MUI_INNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Sözleşme koşullarını kabul ediyorsanız, asagidaki onay düğmesini seçiniz. $(^NameDA) programını kurmak için sözleşme koşullarını kabul etmelisiniz. $_CLICK"
!endif

!ifdef MUI_UNLICENSEPAGE
  ${LangFileString} MUI_UNTEXT_LICENSE_TITLE "Lisans Sözleşmesi"
  ${LangFileString} MUI_UNTEXT_LICENSE_SUBTITLE "Lütfen $(^NameDA) programını sisteminizden kaldırmadan önce sözleşmeyi okuyunuz."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM "Sözleşme koşullarını kabul ediyorsanız, 'Kabul Ediyorum'a basınız. $(^NameDA) programını sisteminizden kaldırmak için sözleşme koşullarını kabul etmelisiniz."
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_CHECKBOX "Sözleşme koşullarını kabul ediyorsanız, aşağıdaki onay kutusunu doldurunuz. $(^NameDA) programını sisteminizden kaldırmak için sözleşme koşullarını kabul etmelisiniz. $_CLICK"
  ${LangFileString} MUI_UNINNERTEXT_LICENSE_BOTTOM_RADIOBUTTONS "Sözleşme koşullarını kabul ediyorsanız, asagidaki onay düğmesini seçiniz. $(^NameDA) programını sisteminizden kaldırmak için sözleşme koşullarını kabul etmelisiniz. $_CLICK"
!endif

!ifdef MUI_LICENSEPAGE | MUI_UNLICENSEPAGE
  ${LangFileString} MUI_INNERTEXT_LICENSE_TOP "Sözleşmenin geri kalanını okumak için 'page down' tuşuna basabilirsiniz."
!endif

!ifdef MUI_COMPONENTSPAGE
  ${LangFileString} MUI_TEXT_COMPONENTS_TITLE "Bileşen seçimi"
  ${LangFileString} MUI_TEXT_COMPONENTS_SUBTITLE "Lütfen $(^NameDA) için kurmak istediginiz bileşenleri seçiniz."
!endif

!ifdef MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_UNTEXT_COMPONENTS_TITLE "Bileşen Şeçimi"
  ${LangFileString} MUI_UNTEXT_COMPONENTS_SUBTITLE "Lütfen kaldırmak istediğiniz $(^NameDA) program bileşenini seçiniz."
!endif

!ifdef MUI_COMPONENTSPAGE | MUI_UNCOMPONENTSPAGE
  ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_TITLE "Açıklama"
  !ifndef NSIS_CONFIG_COMPONENTPAGE_ALTERNATIVE
    ${LangFileString} MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO "Bileşenlerin açıklamalarını görmek için imleci bileşen üzerine götürün."
  !else
    #FIXME:MUI_INNERTEXT_COMPONENTS_DESCRIPTION_INFO 
  !endif
!endif

!ifdef MUI_DIRECTORYPAGE
  ${LangFileString} MUI_TEXT_DIRECTORY_TITLE "Hedef dizini seçimi"
  ${LangFileString} MUI_TEXT_DIRECTORY_SUBTITLE "$(^NameDA) programını kurmak istediğiniz dizini şeçiniz."
!endif

!ifdef MUI_UNDIRECTORYPAGE
  ${LangFileString} MUI_UNTEXT_DIRECTORY_TITLE "Kaldırılıcak Dizin Seçimi"
  ${LangFileString} MUI_UNTEXT_DIRECTORY_SUBTITLE "$(^NameDA) programını kaldırmak istediginiz dizini seçiniz."
!endif

!ifdef MUI_INSTFILESPAGE
  ${LangFileString} MUI_TEXT_INSTALLING_TITLE "Kuruluyor"
  ${LangFileString} MUI_TEXT_INSTALLING_SUBTITLE "Lütfen $(^NameDA) kurulurken bekleyiniz."
  ${LangFileString} MUI_TEXT_FINISH_TITLE "Kurulum Tamamlandı"
  ${LangFileString} MUI_TEXT_FINISH_SUBTITLE "Kurulum başarıyla tamamlandı."
  ${LangFileString} MUI_TEXT_ABORT_TITLE "Kurulum İptal Edildi"
  ${LangFileString} MUI_TEXT_ABORT_SUBTITLE "Kurulum tam olarak tamamlanmadı."
!endif

!ifdef MUI_UNINSTFILESPAGE
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_TITLE "Kaldırılıyor"
  ${LangFileString} MUI_UNTEXT_UNINSTALLING_SUBTITLE "Litfen $(^NameDA) programı sisteminizden kaldırılırken bekleyiniz."
  ${LangFileString} MUI_UNTEXT_FINISH_TITLE "Kaldırma İşlemi Tamamlandır"
  ${LangFileString} MUI_UNTEXT_FINISH_SUBTITLE "Kaldırma işlemi başarıyla tamamlandı."
  ${LangFileString} MUI_UNTEXT_ABORT_TITLE "Kaldırma İşlemi İptal Edildi"
  ${LangFileString} MUI_UNTEXT_ABORT_SUBTITLE "Kaldırma İşlemi tamamlanamadı."
!endif

!ifdef MUI_FINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_INFO_TITLE "$(^NameDA) Kurulum sihirbazı tamamlanıyor."
  ${LangFileString} MUI_TEXT_FINISH_INFO_TEXT "$(^NameDA)  bilgisayariniza yüklendi.$\r$\n$\r$\nLütfen 'Bitir'e basarak kurulumu sonlandırın."
  ${LangFileString} MUI_TEXT_FINISH_INFO_REBOOT "$(^NameDA) kurulumunun tamamlanması için bilgisayarınızı yeniden başlatmanız gerekiyor.Bilgisayarınızı yeniden başlatmak istiyor musunuz?"
!endif

!ifdef MUI_UNFINISHPAGE
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TITLE "$(^NameDA) Programı Kaldırma Sihirbazı Tamamlanıyor"
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_TEXT "$(^NameDA) programı sisteminizden kaldırıldı.$\r$\n$\r$\nSihirbazı kapatmak için 'bitir'e basınız."
  ${LangFileString} MUI_UNTEXT_FINISH_INFO_REBOOT "$(^NameDA) programını kaldırma işleminin tamamlanması için bilgisayarınızın yeniden başlatılması gerekiyor. Bilgisayarınızın şimdi yeniden başlatılmasını ister misiniz?"
!endif

!ifdef MUI_FINISHPAGE | MUI_UNFINISHPAGE
  ${LangFileString} MUI_TEXT_FINISH_REBOOTNOW "Yeniden başlat"
  ${LangFileString} MUI_TEXT_FINISH_REBOOTLATER "Bilgisayarımı daha sonra başlatacağım."
  ${LangFileString} MUI_TEXT_FINISH_RUN "$(^NameDA) programını çalıştır"
  ${LangFileString} MUI_TEXT_FINISH_SHOWREADME "beni oku/readme dosyasını &göster"
  ${LangFileString} MUI_BUTTONTEXT_FINISH "&Bitir"  
!endif

!ifdef MUI_STARTMENUPAGE
  ${LangFileString} MUI_TEXT_STARTMENU_TITLE "Başlat Menüsü Klasör Seçimi"
  ${LangFileString} MUI_TEXT_STARTMENU_SUBTITLE "$(^NameDA) kısayollarının konulacagı başlat menüsü klasörünü seçiniz."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_TOP "Programın kısayollarının konulacağı başlat menüsü klasörünü seçiniz. Farklı bir isim girerek yeni bir klasör yaratabilirsiniz."
  ${LangFileString} MUI_INNERTEXT_STARTMENU_CHECKBOX "Kısayolları oluşturmadan devam et"
!endif

!ifdef MUI_UNCONFIRMPAGE
  ${LangFileString} MUI_UNTEXT_CONFIRM_TITLE "$(^NameDA) Programını Kaldır"
  ${LangFileString} MUI_UNTEXT_CONFIRM_SUBTITLE "$(^NameDA) programını sisteminizden kaldırma."
!endif

!ifdef MUI_ABORTWARNING
  ${LangFileString} MUI_TEXT_ABORTWARNING "$(^Name) kurulumundan çıkmak istediğinize emin misiniz?"
!endif

!ifdef MUI_UNABORTWARNING
  ${LangFileString} MUI_UNTEXT_ABORTWARNING "$(^Name) Programi Kaldırma işleminden çıkmak istediğinize emin misiniz?"
!endif
