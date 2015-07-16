# Copyright (C)  Earnie Boyd  <earnie@users.sf.net>
# This file is a part of msysDVLPR.
#   http://www.mingw.org/msysdvlpr.shmtl
#

echo
echo    "This is a post install process that will try to normalize between"
echo    "your MinGW install if any as well as your previous MSYS installs "
echo    "if any.  I don't have any traps as aborts will not hurt anything."
echo -n "Do you wish to continue with the post install? [yn ] "; read ans
if [ $ans == 'n' ]; then exit 1; fi

. /etc/profile

echo
echo -n "Do you have MinGW installed? [yn ] "; read ans
if [ $ans == y ]
then
  echo
  echo    "Please answer the following in the form of c:/foo/bar."
  echo -n "Where is your MinGW installation? "; read ans
  if [ -f $ans/bin/gcc.exe ]
  then 
    mingwpath=$ans 
  else 
    mingwpath=
  fi
  if [ -z "$mingwpath" ]
  then
    echo
    echo    I could not find $ans/bin/gcc.exe.  You must have given an invalid
    echo    path to your MinGW environment.  I am reversing to no MinGW
    echo    installation.  If you do have MinGW installed then you can manually
    echo    bind the mount point /mingw to C:/mingw '('replace C: with the
    echo    drive of your choice')' by creating an /etc/fstab file with a line
    echo    that has a value similar to:
    echo    C:/mingw /mingw
    echo -n Press ENTER to continue; read ans
  fi
else
  mingwpath=
  echo
  echo    "When you install MinGW I suggest you install it to C:/mingw"
  echo    '(replace C: with the drive of your choice).  Then create an'
  echo    '/etc/fstab file with a line that has a value similar to:' 
  echo    'C:/mingw /mingw'
  echo -n 'Press ENTER to continue '; read ans
fi

if [ ! -z "$mingwpath" ]
then
  if [ -f /etc/fstab ]
  then
    echo
    echo    "I see that you already have an /etc/fstab file.  Do you wish for me"
    echo -n "to add mount bindings for $mingwpath to /mingw? [yn ]"; read ans
    if [ $ans == 'y' ]
    then
      cat <<EOF>>/etc/fstab
$mingwpath /mingw
EOF
    fi
  else
    echo
    echo -n "Creating /etc/fstab with mingw mount bindings."
    cat <<EOF>/etc/fstab
$mingwpath /mingw
EOF
  fi
fi

echo
echo    "        Normalizing your MSYS environment."
echo

for I in cmd rvi vi
do
  if [ -f /bin/$I. ]
  then
    echo You have script /bin/$I
    if [ -f /bin/$I.exe ]
    then
      echo Removing /bin/$I.exe
      rm -f /bin/$I.exe
    fi
  fi
done

for I in ftp ln make awk echo egrep fgrep printf pwd ex rview rvim view
do
  if [ -f /bin/$I.exe ] && [ -f /bin/$I. ]
  then
    echo You have both /bin/$I.exe and /bin/$I.
    echo Removing /bin/$I.
    rm -f /bin/$I.
  fi
done

if [ -z "$mingwpath" ]
then
    echo
    echo MinGW-1.1 has a version of make.exe within it\'s bin/ directory.  
    echo Please be sure to rename this file to mingw32-make.exe once you've
    echo installed MinGW-1.1 because it\'s very deficient in function.
    echo -n Press ENTER to continue. ; read ans
else
    if [ -f $mingwpath/bin/make.exe ]
    then
	echo
	echo Renaming $mingwpath/bin/make.exe to mingw32-make.exe.
	mv $mingwpath/bin/make.exe $mingwpath/bin/mingw32-make.exe
    else
	echo
	echo Oh joy, you do not have $mingwpath/bin/make.exe.  Keep it that way.
    fi
fi
