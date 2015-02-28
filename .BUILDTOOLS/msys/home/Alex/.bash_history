cd /mozilla/
cd /c/mozilla
cd mozilla-beta/
ls
./mach build
./mach build-backend --backend=VisualStudio
./mach clobber
./mach build 
./mach build 
./mach build 
cl -FoAssertions.obj -c -I../../dist/stl_wrappers -DWIN32_LEAN_AND_MEAN -D_WIN32 -DWIN32 -D_CRT_RAND_S -DCERT_CHAIN_PARA_HAS_EXTRA_FIELDS -DOS_WIN=1 -D_UNICODE -DCHROMIUM_BUILD -DU_STATIC_IMPLEMENTATION -DUNICODE -DNOMINMAX -D_WINDOWS -D_SECURE_ATL -DCOMPILER_MSVC -DSTATIC_EXPORTABLE_JS_API -DMOZILLA_INTERNAL_API -DIMPL_LIBXUL -DAB_CD=en-US -DNO_NSPR_10_SUPPORT -Ic:/mozilla/mozilla-beta/dom/mobileconnection -I. -Ic:/mozilla/objdir/ipc/ipdl/_ipdlheaders -Ic:/mozilla/mozilla-beta/ipc/chromium/src -Ic:/mozilla/mozilla-beta/ipc/glue -I../../dist/include -Ic:/mozilla/objdir/dist/include/nspr -Ic:/mozilla/objdir/dist/include/nss -MD -FI../../dist/include/mozilla-config.h -DMOZILLA_CLIENT -TP -nologo -D_HAS_EXCEPTIONS=0 -W3 -Gy -wd4251 -wd4244 -wd4267 -wd4345 -wd4351 -wd4482 -wd4800 -wd4819 -we4553 -GR- -DNDEBUG -DTRIMMED -Zi -UDEBUG -DNDEBUG -O2 -w -Oy -Fdgenerated.pdb c:/mozilla/mozilla-beta/dom/mobileconnection/Assertions.cpp
cd /c/mozilla/objdir/dom/mobileconnection
cl -FoAssertions.obj -c -I../../dist/stl_wrappers -DWIN32_LEAN_AND_MEAN -D_WIN32 -DWIN32 -D_CRT_RAND_S -DCERT_CHAIN_PARA_HAS_EXTRA_FIELDS -DOS_WIN=1 -D_UNICODE -DCHROMIUM_BUILD -DU_STATIC_IMPLEMENTATION -DUNICODE -DNOMINMAX -D_WINDOWS -D_SECURE_ATL -DCOMPILER_MSVC -DSTATIC_EXPORTABLE_JS_API -DMOZILLA_INTERNAL_API -DIMPL_LIBXUL -DAB_CD=en-US -DNO_NSPR_10_SUPPORT -Ic:/mozilla/mozilla-beta/dom/mobileconnection -I. -Ic:/mozilla/objdir/ipc/ipdl/_ipdlheaders -Ic:/mozilla/mozilla-beta/ipc/chromium/src -Ic:/mozilla/mozilla-beta/ipc/glue -I../../dist/include -Ic:/mozilla/objdir/dist/include/nspr -Ic:/mozilla/objdir/dist/include/nss -MD -FI../../dist/include/mozilla-config.h -DMOZILLA_CLIENT -TP -nologo -D_HAS_EXCEPTIONS=0 -W3 -Gy -wd4251 -wd4244 -wd4267 -wd4345 -wd4351 -wd4482 -wd4800 -wd4819 -we4553 -GR- -DNDEBUG -DTRIMMED -Zi -UDEBUG -DNDEBUG -O2 -w -Oy -Fdgenerated.pdb c:/mozilla/mozilla-beta/dom/mobileconnection/Assertions.cpp
cd /c/mozilla/objdir/dom/quota
cl -FoQuotaManager.obj -c -I../../dist/stl_wrappers -DWIN32_LEAN_AND_MEAN -D_WIN32 -DWIN32 -D_CRT_RAND_S -DCERT_CHAIN_PARA_HAS_EXTRA_FIELDS -DOS_WIN=1 -D_UNICODE -DCHROMIUM_BUILD -DU_STATIC_IMPLEMENTATION -DUNICODE -DNOMINMAX -D_WINDOWS -D_SECURE_ATL -DCOMPILER_MSVC -DSTATIC_EXPORTABLE_JS_API -DMOZILLA_INTERNAL_API -DIMPL_LIBXUL -DAB_CD=en-US -DNO_NSPR_10_SUPPORT -Ic:/mozilla/mozilla-beta/dom/quota -I. -Ic:/mozilla/objdir/ipc/ipdl/_ipdlheaders -Ic:/mozilla/mozilla-beta/ipc/chromium/src -Ic:/mozilla/mozilla-beta/ipc/glue -Ic:/mozilla/mozilla-beta/caps -I../../dist/include -Ic:/mozilla/objdir/dist/include/nspr -Ic:/mozilla/objdir/dist/include/nss -MD -FI ../../dist/include/mozilla-config.h -DMOZILLA_CLIENT -TP -nologo -D_HAS_EXCEPTIONS=0 -W3 -Gy -wd4251 -wd4244 -wd4267 -wd4345 -wd4351 -wd4482 -wd4800 -wd4819 -we4553 -GR- -DNDEBUG -DTRIMMED -Zi -UDEBUG -DNDEBUG -O2 -w -Oy -Fdgenerated.pdb c:/mozilla/mozilla-beta/dom/quota/QuotaManager.cpp
cd ../../../
cd mozilla-beta/
./mach build
./mach build
ls
cd /c/mozilla/objdir/dom/quota/
ls
cl -FoQuotaManager.obj -c -I../../dist/stl_wrappers -DWIN32_LEAN_AND_MEAN -D_WIN32 -DWIN32 -D_CRT_RAND_S -DCERT_CHAIN_PARA_HAS_EXTRA_FIELDS -DOS_WIN=1 -D_UNICODE -DCHROMIUM_BUILD -DU_STATIC_IMPLEMENTATION -DUNICODE -DNOMINMAX -D_WINDOWS -D_SECURE_ATL -DCOMPILER_MSVC -DSTATIC_EXPORTABLE_JS_API -DMOZILLA_INTERNAL_API -DIMPL_LIBXUL -DAB_CD=en-US -DNO_NSPR_10_SUPPORT -Ic:/mozilla/mozilla-beta/dom/quota -I. -Ic:/mozilla/objdir/ipc/ipdl/_ipdlheaders -Ic:/mozilla/mozilla-beta/ipc/chromium/src -Ic:/mozilla/mozilla-beta/ipc/glue -Ic:/mozilla/mozilla-beta/caps -I../../dist/include -Ic:/mozilla/objdir/dist/include/nspr -Ic:/mozilla/objdir/dist/include/nss -MD -FI ../../dist/include/mozilla-config.h -DMOZILLA_CLIENT -TP -nologo -D_HAS_EXCEPTIONS=0 -W3 -Gy -wd4251 -wd4244 -wd4267 -wd4345 -wd4351 -wd4482 -wd4800 -wd4819 -we4553 -GR- -DNDEBUG -DTRIMMED -Zi -UDEBUG -DNDEBUG -O2 -w -Oy -Fdgenerated.pdb c:/mozilla/mozilla-beta/dom/quota/QuotaManager.cpp
ls
ls
cd ../../
cd ../mozilla-beta/
ls
./mach build
cd /c/mozilla/objdir/dom/mobileconnection/
cl -FoAssertions.obj -c -I../../dist/stl_wrappers -DWIN32_LEAN_AND_MEAN -D_WIN32 -DWIN32 -D_CRT_RAND_S -DCERT_CHAIN_PARA_HAS_EXTRA_FIELDS -DOS_WIN=1 -D_UNICODE -DCHROMIUM_BUILD -DU_STATIC_IMPLEMENTATION -DUNICODE -DNOMINMAX -D_WINDOWS -D_SECURE_ATL -DCOMPILER_MSVC -DSTATIC_EXPORTABLE_JS_API -DMOZILLA_INTERNAL_API -DIMPL_LIBXUL -DAB_CD=en-US -DNO_NSPR_10_SUPPORT -Ic:/mozilla/mozilla-beta/dom/mobileconnection -I. -Ic:/mozilla/objdir/ipc/ipdl/_ipdlheaders -Ic:/mozilla/mozilla-beta/ipc/chromium/src -Ic:/mozilla/mozilla-beta/ipc/glue -I../../dist/include -Ic:/mozilla/objdir/dist/include/nspr -Ic:/mozilla/objdir/dist/include/nss -MD -FI../../dist/include/mozilla-config.h -DMOZILLA_CLIENT -TP -nologo -D_HAS_EXCEPTIONS=0 -W3 -Gy -wd4251 -wd4244 -wd4267 -wd4345 -wd4351 -wd4482 -wd4800 -wd4819 -we4553 -GR- -DNDEBUG -DTRIMMED -Zi -UDEBUG -DNDEBUG -O2 -w -Oy -Fdgenerated.pdb c:/mozilla/mozilla-beta/dom/mobileconnection/Assertions.cpp
exit
cd /c/mozilla/mozilla-beta/
./mach build
exit
