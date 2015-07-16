cd /c/gecko/objdir/gfx/qcms/
cl -Fotransform.obj -c -DAB_CD=en-US -DNO_NSPR_10_SUPPORT -Ic:/gecko/gfx/qcms -I. -I../../dist/include -Ic:/gecko/objdir/dist/include/nspr -Ic:/gecko/objdir/dist/include/nss -MD -FI ../../dist/include/mozilla-config.h -DMOZILLA_CLIENT -TC -nologo -D_HAS_EXCEPTIONS=0 -W3 -Gy -FS -wd4244 -wd4267 -wd4819 -we4553 -DNDEBUG -DTRIMMED -Zi -UDEBUG -DNDEBUG -D_ATL_XP_TARGETING -O2 -w -Oy -Fdgenerated.pdb c:/gecko/gfx/qcms/transform.c
EXIT
exit
