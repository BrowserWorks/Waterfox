; unicode is not enabled by default
; unicode installers will not be able to run on Windows 9x!
Unicode true

Name "Unicode Games"
OutFile "unicode.exe"

ShowInstDetails show

XPStyle on

Section "Unicode in UI"

	DetailPrint "Hello World!"
	DetailPrint "שלום עולם!"
	DetailPrint "مرحبا العالم!"
	DetailPrint "こんにちは、世界！"
	DetailPrint "你好世界！"
	DetailPrint "привет мир!"
	DetailPrint "안녕하세요!"

	DetailPrint "${U+00A9}" # arbitrary unicode chars

SectionEnd

Section "Unicode in Files"

	# TODO add file I/O unicode function examples

SectionEnd
