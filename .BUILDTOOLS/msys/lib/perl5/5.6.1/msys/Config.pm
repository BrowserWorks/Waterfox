package Config;
use Exporter ();
@EXPORT = qw(%Config);
@EXPORT_OK = qw(myconfig config_sh config_vars);

# Define our own import method to avoid pulling in the full Exporter:
sub import {
  my $pkg = shift;
  @_ = @EXPORT unless @_;
  my @func = grep {$_ ne '%Config'} @_;
  local $Exporter::ExportLevel = 1;
  Exporter::import('Config', @func) if @func;
  return if @func == @_;
  my $callpkg = caller(0);
  *{"$callpkg\::Config"} = \%Config;
}

die "Perl lib version (v5.6.1) doesn't match executable version ($])"
    unless $^V;

$^V eq v5.6.1
  or die "Perl lib version (v5.6.1) doesn't match executable version (" .
    (sprintf "v%vd",$^V) . ")";

# This file was created by configpm when Perl was built. Any changes
# made to this file will be lost the next time perl is built.

##
## This file was produced by running the Configure script. It holds all the
## definitions figured out by Configure. Should you modify one of these values,
## do not forget to propagate your changes by running "Configure -der". You may
## instead choose to run each of the .SH files by yourself, or "Configure -S".
##
#
## Package name      : perl5
## Source directory  : .
## Configuration time: Sat May 18 14:14:54 EDT 2002
## Configured by     : unknown
## Target system     : msys_nt-4.0 du216771 1.0.8(0.4632) 2002-05-13 09:50 i686 unknown 
#
## Configure command line arguments.

my $config_sh = <<'!END!';
archlibexp='/usr/lib/perl5/5.6.1/msys'
archname='msys'
cc='gcc'
ccflags='-DPERL_USE_SAFE_PUTENV -fno-strict-aliasing -fnative-struct'
cppflags='-DPERL_USE_SAFE_PUTENV -fno-strict-aliasing -fnative-struct'
dlsrc='dl_dlopen.xs'
dynamic_ext='B ByteLoader Data/Dumper Devel/DProf Devel/Peek Fcntl File/Glob GDBM_File IO Opcode POSIX SDBM_File Socket Sys/Hostname Sys/Syslog attrs re'
extensions='B ByteLoader Data/Dumper Devel/DProf Devel/Peek Fcntl File/Glob GDBM_File IO Opcode POSIX SDBM_File Socket Sys/Hostname Sys/Syslog attrs re Errno'
installarchlib='/usr/lib/perl5/5.6.1/msys'
installprivlib='/usr/lib/perl5/5.6.1'
libpth='/usr/lib /lib'
libs='-lgdbm'
osname='msys'
osvers='1.0.8(0.4632)'
prefix='/usr'
privlibexp='/usr/lib/perl5/5.6.1'
sharpbang='#!'
shsharp='true'
sig_name='ZERO HUP INT QUIT ILL TRAP ABRT EMT FPE KILL BUS SEGV SYS PIPE ALRM TERM URG STOP TSTP CONT CHLD TTIN TTOU IO XCPU XFSZ VTALRM PROF WINCH LOST USR1 USR2 CLD POLL '
sig_num='0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 20 23 '
so='dll'
startsh='#!/bin/sh'
static_ext=' '
Author=''
CONFIG='true'
Date='$Date'
Header=''
Id='$Id'
Locker=''
Log='$Log'
Mcc='Mcc'
PATCHLEVEL='6'
PERL_API_REVISION='5'
PERL_API_SUBVERSION='0'
PERL_API_VERSION='5'
PERL_CONFIG_SH='true'
PERL_REVISION='5'
PERL_SUBVERSION='1'
PERL_VERSION='6'
RCSfile='$RCSfile'
Revision='$Revision'
SUBVERSION='1'
Source=''
State=''
_a='.a'
_exe='.exe'
_o='.o'
afs='false'
alignbytes='8'
ansi2knr=''
aphostname='/c/WINNT/system32/hostname'
api_revision='5'
api_subversion='0'
api_version='5'
api_versionstring='5.005'
ar='ar'
archlib='/usr/lib/perl5/5.6.1/msys'
archname64=''
archobjs='msys.o'
awk='awk'
baserev='5.0'
bash=''
bin='/usr/bin'
bincompat5005='undef'
binexp='/usr/bin'
bison='bison'
byacc='byacc'
byteorder='1234'
c=''
castflags='0'
cat='cat'
cccdlflags=' '
ccdlflags=' -s'
ccflags_uselargefiles=''
ccname='gcc'
ccsymbols='_X86_=1 __GNUC_MINOR__=95 __GNUC__=2 __MSYS__=1 __cdecl=__attribute__((__cdecl__)) __declspec(x)=__attribute__((x)) __i386=1 __i386__=1 __stdcall=__attribute__((__stdcall__)) __unix=1 __unix__=1 _cdecl=__attribute__((__cdecl__)) _stdcall=__attribute__((__stdcall__)) _unix=1 cpu=i386 i386=1 machine=i386 system=winnt unix=1'
ccversion=''
cf_by='unknown'
cf_email='unknown@du216771.users'
cf_time='Sat May 18 14:14:54 EDT 2002'
charsize='1'
chgrp=''
chmod=''
chown=''
clocktype='clock_t'
comm='comm'
compress=''
config_arg0='./Configure'
config_argc='0'
config_args=''
contains='grep'
cp='cp'
cpio=''
cpp='cpp'
cpp_stuff='42'
cppccsymbols=''
cpplast='-'
cppminus='-'
cpprun='gcc -E'
cppstdin='gcc -E'
cppsymbols=''
crosscompile='undef'
cryptlib=''
csh='csh'
d_Gconvert='gcvt((x),(n),(b))'
d_PRIEUldbl='define'
d_PRIFUldbl='define'
d_PRIGUldbl='define'
d_PRIXU64='define'
d_PRId64='define'
d_PRIeldbl='define'
d_PRIfldbl='define'
d_PRIgldbl='define'
d_PRIi64='define'
d_PRIo64='define'
d_PRIu64='define'
d_PRIx64='define'
d_SCNfldbl='define'
d__fwalk='undef'
d_access='define'
d_accessx='undef'
d_alarm='define'
d_archlib='define'
d_atolf='undef'
d_atoll='undef'
d_attribut='define'
d_bcmp='define'
d_bcopy='define'
d_bincompat5005='undef'
d_bsd='define'
d_bsdgetpgrp='undef'
d_bsdsetpgrp='undef'
d_bzero='define'
d_casti32='undef'
d_castneg='define'
d_charvspr='undef'
d_chown='define'
d_chroot='define'
d_chsize='undef'
d_closedir='define'
d_const='define'
d_crypt='undef'
d_csh='undef'
d_cuserid='define'
d_dbl_dig='define'
d_difftime='define'
d_dirnamlen='undef'
d_dlerror='define'
d_dlopen='define'
d_dlsymun='undef'
d_dosuid='undef'
d_drand48proto='define'
d_dup2='define'
d_eaccess='undef'
d_endgrent='define'
d_endhent='define'
d_endnent='undef'
d_endpent='undef'
d_endpwent='define'
d_endsent='undef'
d_eofnblk='define'
d_eunice='undef'
d_fchmod='define'
d_fchown='define'
d_fcntl='define'
d_fcntl_can_lock='define'
d_fd_macros='define'
d_fd_set='define'
d_fds_bits='define'
d_fgetpos='define'
d_flexfnam='define'
d_flock='undef'
d_fork='define'
d_fpathconf='define'
d_fpos64_t='undef'
d_frexpl='undef'
d_fs_data_s='undef'
d_fseeko='undef'
d_fsetpos='define'
d_fstatfs='define'
d_fstatvfs='undef'
d_fsync='define'
d_ftello='undef'
d_ftime='undef'
d_getcwd='define'
d_getespwnam='undef'
d_getfsstat='undef'
d_getgrent='define'
d_getgrps='define'
d_gethbyaddr='define'
d_gethbyname='define'
d_gethent='undef'
d_gethname='define'
d_gethostprotos='define'
d_getlogin='define'
d_getmnt='undef'
d_getmntent='define'
d_getnbyaddr='undef'
d_getnbyname='undef'
d_getnent='undef'
d_getnetprotos='define'
d_getpagsz='define'
d_getpbyname='define'
d_getpbynumber='define'
d_getpent='undef'
d_getpgid='define'
d_getpgrp2='undef'
d_getpgrp='define'
d_getppid='define'
d_getprior='undef'
d_getprotoprotos='define'
d_getprpwnam='undef'
d_getpwent='define'
d_getsbyname='define'
d_getsbyport='define'
d_getsent='undef'
d_getservprotos='define'
d_getspnam='undef'
d_gettimeod='define'
d_gnulibc='undef'
d_grpasswd='define'
d_hasmntopt='undef'
d_htonl='define'
d_iconv='undef'
d_index='undef'
d_inetaton='define'
d_int64_t='define'
d_isascii='define'
d_isnan='define'
d_isnanl='undef'
d_killpg='define'
d_lchown='define'
d_ldbl_dig='define'
d_link='define'
d_locconv='define'
d_lockf='undef'
d_longdbl='define'
d_longlong='define'
d_lseekproto='define'
d_lstat='define'
d_madvise='undef'
d_mblen='define'
d_mbstowcs='define'
d_mbtowc='define'
d_memchr='define'
d_memcmp='define'
d_memcpy='define'
d_memmove='define'
d_memset='define'
d_mkdir='define'
d_mkdtemp='undef'
d_mkfifo='define'
d_mkstemp='define'
d_mkstemps='undef'
d_mktime='define'
d_mmap='define'
d_modfl='undef'
d_mprotect='define'
d_msg='undef'
d_msg_ctrunc='undef'
d_msg_dontroute='define'
d_msg_oob='define'
d_msg_peek='define'
d_msg_proxy='undef'
d_msgctl='undef'
d_msgget='undef'
d_msgrcv='undef'
d_msgsnd='undef'
d_msync='define'
d_munmap='define'
d_mymalloc='define'
d_nice='define'
d_nv_preserves_uv='define'
d_nv_preserves_uv_bits='32'
d_off64_t='undef'
d_old_pthread_create_joinable='undef'
d_oldpthreads='undef'
d_oldsock='undef'
d_open3='define'
d_pathconf='define'
d_pause='define'
d_perl_otherlibdirs='undef'
d_phostname='undef'
d_pipe='define'
d_poll='define'
d_portable='define'
d_pthread_yield='undef'
d_pwage='undef'
d_pwchange='undef'
d_pwclass='undef'
d_pwcomment='define'
d_pwexpire='undef'
d_pwgecos='define'
d_pwpasswd='define'
d_pwquota='undef'
d_qgcvt='undef'
d_quad='define'
d_readdir='define'
d_readlink='define'
d_rename='define'
d_rewinddir='define'
d_rmdir='define'
d_safebcpy='define'
d_safemcpy='undef'
d_sanemcmp='define'
d_sbrkproto='define'
d_sched_yield='define'
d_scm_rights='undef'
d_seekdir='define'
d_select='define'
d_sem='undef'
d_semctl='undef'
d_semctl_semid_ds='undef'
d_semctl_semun='undef'
d_semget='undef'
d_semop='undef'
d_setegid='define'
d_seteuid='define'
d_setgrent='define'
d_setgrps='undef'
d_sethent='define'
d_setlinebuf='undef'
d_setlocale='define'
d_setnent='undef'
d_setpent='undef'
d_setpgid='define'
d_setpgrp2='undef'
d_setpgrp='define'
d_setprior='undef'
d_setproctitle='undef'
d_setpwent='define'
d_setregid='undef'
d_setresgid='undef'
d_setresuid='undef'
d_setreuid='undef'
d_setrgid='undef'
d_setruid='undef'
d_setsent='undef'
d_setsid='define'
d_setvbuf='define'
d_sfio='undef'
d_shm='undef'
d_shmat='undef'
d_shmatprototype='undef'
d_shmctl='undef'
d_shmdt='undef'
d_shmget='undef'
d_sigaction='define'
d_sigsetjmp='define'
d_socket='define'
d_socklen_t='define'
d_sockpair='define'
d_socks5_init='undef'
d_sqrtl='undef'
d_statblks='define'
d_statfs_f_flags='undef'
d_statfs_s='define'
d_statvfs='undef'
d_stdio_cnt_lval='define'
d_stdio_ptr_lval='define'
d_stdio_ptr_lval_nochange_cnt='define'
d_stdio_ptr_lval_sets_cnt='undef'
d_stdio_stream_array='undef'
d_stdiobase='define'
d_stdstdio='define'
d_strchr='define'
d_strcoll='define'
d_strctcpy='define'
d_strerrm='strerror(e)'
d_strerror='define'
d_strtod='define'
d_strtol='define'
d_strtold='undef'
d_strtoll='undef'
d_strtoul='define'
d_strtoull='undef'
d_strtouq='undef'
d_strxfrm='define'
d_suidsafe='undef'
d_symlink='define'
d_syscall='undef'
d_sysconf='define'
d_sysernlst=''
d_syserrlst='define'
d_system='define'
d_tcgetpgrp='define'
d_tcsetpgrp='define'
d_telldir='define'
d_telldirproto='define'
d_time='define'
d_times='define'
d_truncate='define'
d_tzname='define'
d_umask='define'
d_uname='define'
d_union_semun='undef'
d_ustat='undef'
d_vendorarch='undef'
d_vendorbin='undef'
d_vendorlib='undef'
d_vfork='undef'
d_void_closedir='undef'
d_voidsig='define'
d_voidtty=''
d_volatile='define'
d_vprintf='define'
d_wait4='define'
d_waitpid='define'
d_wcstombs='define'
d_wctomb='define'
d_xenix='undef'
date='date'
db_hashtype='u_int32_t'
db_prefixtype='size_t'
defvoidused='15'
direntrytype='struct dirent'
dlext='dll'
doublesize='8'
drand01='drand48()'
eagain='EAGAIN'
ebcdic='undef'
echo='echo'
egrep='egrep'
emacs=''
eunicefix=':'
exe_ext='.exe'
expr='expr'
fflushNULL='define'
fflushall='undef'
find=''
firstmakefile='GNUmakefile'
flex=''
fpossize='4'
fpostype='fpos_t'
freetype='void'
full_ar='/bin/ar'
full_csh='csh'
full_sed='/bin/sed'
gccosandvers=''
gccversion='2.95.3-1'
gidformat='"hu"'
gidsign='1'
gidsize='2'
gidtype='gid_t'
glibpth='/usr/shlib  /lib /usr/lib /usr/lib/386 /lib/386 /usr/ccs/lib /usr/ucblib /usr/local/lib '
grep='grep'
groupcat=''
groupstype='gid_t'
gzip='gzip'
h_fcntl='false'
h_sysfile='true'
hint='recommended'
hostcat=''
i16size='2'
i16type='short'
i32size='4'
i32type='long'
i64size='8'
i64type='long long'
i8size='1'
i8type='char'
i_arpainet='define'
i_bsdioctl=''
i_db='undef'
i_dbm='undef'
i_dirent='define'
i_dld='undef'
i_dlfcn='define'
i_fcntl='undef'
i_float='define'
i_gdbm='define'
i_grp='define'
i_iconv='undef'
i_ieeefp='define'
i_inttypes='undef'
i_libutil='undef'
i_limits='define'
i_locale='define'
i_machcthr='undef'
i_malloc='define'
i_math='define'
i_memory='undef'
i_mntent='define'
i_ndbm='undef'
i_netdb='define'
i_neterrno='undef'
i_netinettcp='define'
i_niin='define'
i_poll='define'
i_prot='undef'
i_pthread='define'
i_pwd='define'
i_rpcsvcdbm='undef'
i_sfio='undef'
i_sgtty='undef'
i_shadow='undef'
i_socks='undef'
i_stdarg='define'
i_stddef='define'
i_stdlib='define'
i_string='define'
i_sunmath='undef'
i_sysaccess='undef'
i_sysdir='undef'
i_sysfile='define'
i_sysfilio='undef'
i_sysin='undef'
i_sysioctl='define'
i_syslog='define'
i_sysmman='define'
i_sysmode='undef'
i_sysmount='define'
i_sysndir='undef'
i_sysparam='define'
i_sysresrc='define'
i_syssecrt='undef'
i_sysselct='define'
i_syssockio=''
i_sysstat='define'
i_sysstatfs='undef'
i_sysstatvfs='undef'
i_systime='define'
i_systimek='undef'
i_systimes='define'
i_systypes='define'
i_sysuio='define'
i_sysun='define'
i_sysutsname='define'
i_sysvfs='define'
i_syswait='define'
i_termio='undef'
i_termios='define'
i_time='undef'
i_unistd='define'
i_ustat='undef'
i_utime='define'
i_values='undef'
i_varargs='undef'
i_varhdr='stdarg.h'
i_vfork='undef'
ignore_versioned_solibs=''
inc_version_list=' '
inc_version_list_init='0'
incpath=''
inews=''
installbin='/usr/bin'
installman1dir=''
installman3dir=''
installprefix='/usr'
installprefixexp='/usr'
installscript='/usr/bin'
installsitearch='/usr/lib/perl5/site_perl/5.6.1/msys'
installsitebin='/usr/bin'
installsitelib='/usr/lib/perl5/site_perl/5.6.1'
installstyle='lib/perl5'
installusrbinperl='undef'
installvendorarch=''
installvendorbin=''
installvendorlib=''
intsize='4'
issymlink='test -h'
ivdformat='"ld"'
ivsize='4'
ivtype='long'
known_extensions='B ByteLoader DB_File Data/Dumper Devel/DProf Devel/Peek Fcntl File/Glob GDBM_File IO IPC/SysV NDBM_File ODBM_File Opcode POSIX SDBM_File Socket Sys/Hostname Sys/Syslog Thread attrs re'
ksh=''
ld='ld2'
lddlflags=' -s'
ldflags=' -s'
ldflags_uselargefiles=''
ldlibpthname='PATH'
less='less'
lib_ext='.a'
libc='/usr/lib/libmsys-1.0.dll.a'
libperl='libperl.dll'
libsdirs=' /usr/lib'
libsfiles=' libgdbm.a'
libsfound=' /usr/lib/libgdbm.a'
libspath=' /usr/lib /lib'
libswanted='  sfio socket bind inet nsl nm ndbm gdbm dbm db malloc dl dld ld sun cposix posix ndir dir crypt sec ucb bsd BSD PW x iconv util   cygipc'
libswanted_uselargefiles=''
line=''
lint=''
lkflags=''
ln='ln'
lns='/bin/ln -s'
locincpth='/usr/local/include /opt/local/include /usr/gnu/include /opt/gnu/include /usr/GNU/include /opt/GNU/include'
loclibpth='/usr/local/lib /opt/local/lib /usr/gnu/lib /opt/gnu/lib /usr/GNU/lib /opt/GNU/lib'
longdblsize='12'
longlongsize='8'
longsize='4'
lp=''
lpr=''
ls='ls'
lseeksize='4'
lseektype='off_t'
mail=''
mailx=''
make='make'
make_set_make='#'
mallocobj='malloc.o'
mallocsrc='malloc.c'
malloctype='void *'
man1dir=' '
man1direxp=''
man1ext='0'
man3dir=' '
man3direxp=''
man3ext='0'
mips_type=''
mkdir='mkdir'
mmaptype='caddr_t'
modetype='mode_t'
more='more'
multiarch='undef'
mv=''
myarchname='i686-msys'
mydomain='.users'
myhostname='du216771'
myuname='msys_nt-4.0 du216771 1.0.8(0.4632) 2002-05-13 09:50 i686 unknown '
n='-n'
netdb_hlen_type='int'
netdb_host_type='const char *'
netdb_name_type='const char *'
netdb_net_type='long'
nm='nm'
nm_opt=''
nm_so_opt=''
nonxs_ext='Errno'
nroff='nroff'
nvEUformat='"E"'
nvFUformat='"F"'
nvGUformat='"G"'
nveformat='"e"'
nvfformat='"f"'
nvgformat='"g"'
nvsize='8'
nvtype='double'
o_nonblock='O_NONBLOCK'
obj_ext='.o'
old_pthread_create_joinable=''
optimize='-O3 -s -mcpu=pentium'
orderlib='false'
otherlibdirs=' '
package='perl5'
pager='/bin/less'
passcat=''
patchlevel='6'
path_sep=':'
perl5='/usr/bin/perl'
perl=''
perladmin='unknown@du216771.users'
perllibs=''
perlpath='/usr/bin/perl'
pg='pg'
phostname='hostname'
pidtype='pid_t'
plibpth='/usr/lib'
pm_apiversion='5.005'
pmake=''
pr=''
prefixexp='/usr'
privlib='/usr/lib/perl5/5.6.1'
prototype='define'
ptrsize='4'
quadkind='3'
quadtype='long long'
randbits='48'
randfunc='drand48'
randseedtype='long'
ranlib=':'
rd_nodata='-1'
revision='5'
rm='rm'
rmail=''
runnm='true'
sPRIEUldbl='"LE"'
sPRIFUldbl='"LF"'
sPRIGUldbl='"LG"'
sPRIXU64='"llX"'
sPRId64='"lld"'
sPRIeldbl='"Le"'
sPRIfldbl='"Lf"'
sPRIgldbl='"Lg"'
sPRIi64='"lli"'
sPRIo64='"llo"'
sPRIu64='"llu"'
sPRIx64='"llx"'
sSCNfldbl='"Lf"'
sched_yield='sched_yield()'
scriptdir='/usr/bin'
scriptdirexp='/usr/bin'
sed='sed'
seedfunc='srand48'
selectminbits='32'
selecttype='fd_set *'
sendmail=''
sh='/bin/sh'
shar=''
shmattype=''
shortsize='2'
shrpenv='env LD_RUN_PATH=/usr/lib/perl5/5.6.1/msys/CORE'
sig_count='32'
sig_name_init='"ZERO", "HUP", "INT", "QUIT", "ILL", "TRAP", "ABRT", "EMT", "FPE", "KILL", "BUS", "SEGV", "SYS", "PIPE", "ALRM", "TERM", "URG", "STOP", "TSTP", "CONT", "CHLD", "TTIN", "TTOU", "IO", "XCPU", "XFSZ", "VTALRM", "PROF", "WINCH", "LOST", "USR1", "USR2", "CLD", "POLL", 0'
sig_num_init='0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 20, 23, 0'
signal_t='void'
sitearch='/usr/lib/perl5/site_perl/5.6.1/msys'
sitearchexp='/usr/lib/perl5/site_perl/5.6.1/msys'
sitebin='/usr/bin'
sitebinexp='/usr/bin'
sitelib='/usr/lib/perl5/site_perl/5.6.1'
sitelib_stem='/usr/lib/perl5/site_perl'
sitelibexp='/usr/lib/perl5/site_perl/5.6.1'
siteprefix='/usr'
siteprefixexp='/usr'
sizesize='4'
sizetype='size_t'
sleep=''
smail=''
sockethdr=''
socketlib=''
socksizetype='socklen_t'
sort='sort'
spackage='Perl5'
spitshell='cat'
src='.'
ssizetype='ssize_t'
startperl='#!/usr/bin/perl'
stdchar='char'
stdio_base='((fp)->_ub._base ? (fp)->_ub._base : (fp)->_bf._base)'
stdio_bufsiz='((fp)->_ub._base ? (fp)->_ub._size : (fp)->_bf._size)'
stdio_cnt='((fp)->_r)'
stdio_filbuf=''
stdio_ptr='((fp)->_p)'
stdio_stream_array=''
strings='/usr/include/string.h'
submit=''
subversion='1'
sysman='/usr/man/man1'
tail=''
tar=''
tbl=''
tee=''
test='test'
timeincl='/usr/include/sys/time.h '
timetype='time_t'
touch='touch'
tr='tr'
trnl='\n'
troff=''
u16size='2'
u16type='unsigned short'
u32size='4'
u32type='unsigned long'
u64size='8'
u64type='unsigned long long'
u8size='1'
u8type='unsigned char'
uidformat='"hu"'
uidsign='1'
uidsize='2'
uidtype='uid_t'
uname='uname'
uniq='uniq'
uquadtype='unsigned long long'
use5005threads='undef'
use64bitall='undef'
use64bitint='undef'
usedl='define'
useithreads='undef'
uselargefiles='define'
uselongdouble='undef'
usemorebits='undef'
usemultiplicity='undef'
usemymalloc='y'
usenm='true'
useopcode='true'
useperlio='undef'
useposix='true'
usesfio='false'
useshrplib='true'
usesocks='undef'
usethreads='undef'
usevendorprefix='undef'
usevfork='false'
usrinc='/usr/include'
uuname=''
uvXUformat='"lX"'
uvoformat='"lo"'
uvsize='4'
uvtype='unsigned long'
uvuformat='"lu"'
uvxformat='"lx"'
vendorarch=''
vendorarchexp=''
vendorbin=''
vendorbinexp=''
vendorlib=''
vendorlib_stem=''
vendorlibexp=''
vendorprefix=''
vendorprefixexp=''
version='5.6.1'
versiononly='undef'
vi=''
voidflags='15'
xlibpth='/usr/lib/386 /lib/386'
xs_apiversion='5.6.1'
yacc='bison -y'
yaccflags=''
zcat=''
zip='zip'
!END!

my $summary = <<'!END!';
Summary of my $package (revision $baserev version $PERL_VERSION subversion $PERL_SUBVERSION) configuration:
  Platform:
    osname=$osname, osvers=$osvers, archname=$archname
    uname='$myuname'
    config_args='$config_args'
    hint=$hint, useposix=$useposix, d_sigaction=$d_sigaction
    usethreads=$usethreads use5005threads=$use5005threads useithreads=$useithreads usemultiplicity=$usemultiplicity
    useperlio=$useperlio d_sfio=$d_sfio uselargefiles=$uselargefiles usesocks=$usesocks
    use64bitint=$use64bitint use64bitall=$use64bitall uselongdouble=$uselongdouble
  Compiler:
    cc='$cc', ccflags ='$ccflags',
    optimize='$optimize',
    cppflags='$cppflags'
    ccversion='$ccversion', gccversion='$gccversion', gccosandvers='$gccosandvers'
    intsize=$intsize, longsize=$longsize, ptrsize=$ptrsize, doublesize=$doublesize, byteorder=$byteorder
    d_longlong=$d_longlong, longlongsize=$longlongsize, d_longdbl=$d_longdbl, longdblsize=$longdblsize
    ivtype='$ivtype', ivsize=$ivsize, nvtype='$nvtype', nvsize=$nvsize, Off_t='$lseektype', lseeksize=$lseeksize
    alignbytes=$alignbytes, usemymalloc=$usemymalloc, prototype=$prototype
  Linker and Libraries:
    ld='$ld', ldflags ='$ldflags'
    libpth=$libpth
    libs=$libs
    perllibs=$perllibs
    libc=$libc, so=$so, useshrplib=$useshrplib, libperl=$libperl
  Dynamic Linking:
    dlsrc=$dlsrc, dlext=$dlext, d_dlsymun=$d_dlsymun, ccdlflags='$ccdlflags'
    cccdlflags='$cccdlflags', lddlflags='$lddlflags'

!END!
my $summary_expanded = 0;

sub myconfig {
	return $summary if $summary_expanded;
	$summary =~ s{\$(\w+)}
		     { my $c = $Config{$1}; defined($c) ? $c : 'undef' }ge;
	$summary_expanded = 1;
	$summary;
}

sub FETCH { 
    # check for cached value (which may be undef so we use exists not defined)
    return $_[0]->{$_[1]} if (exists $_[0]->{$_[1]});

    # Search for it in the big string 
    my($value, $start, $marker, $quote_type);

    $quote_type = "'";
    # Virtual entries.
    if ($_[1] eq 'byteorder') {
	# byteorder does exist on its own but we overlay a virtual
	# dynamically recomputed value. 
        my $t = $Config{ivtype};
        my $s = $Config{ivsize};
        my $f = $t eq 'long' ? 'L!' : $s == 8 ? 'Q': 'I';
        if ($s == 4 || $s == 8) {
	    my $i = 0;
    	    foreach my $c (reverse(2..$s)) { $i |= ord($c); $i <<= 8 }
	    $i |= ord(1);
            $value = join('', unpack('a'x$s, pack($f, $i)));
        } else {
            $value = '?'x$s;
        }
    } elsif ($_[1] =~ /^((?:cc|ld)flags|libs(?:wanted)?)_nolargefiles/) {
	# These are purely virtual, they do not exist, but need to
	# be computed on demand for largefile-incapable extensions.
	my $key = "${1}_uselargefiles";
	$value = $Config{$1};
	my $withlargefiles = $Config{$key};
	if ($key =~ /^(?:cc|ld)flags_/) {
	    $value =~ s/\Q$withlargefiles\E\b//;
	} elsif ($key =~ /^libs/) {
	    my @lflibswanted = split(' ', $Config{libswanted_uselargefiles});
	    if (@lflibswanted) {
		my %lflibswanted;
		@lflibswanted{@lflibswanted} = ();
		if ($key =~ /^libs_/) {
		    my @libs = grep { /^-l(.+)/ &&
                                      not exists $lflibswanted{$1} }
		                    split(' ', $Config{libs});
		    $Config{libs} = join(' ', @libs);
		} elsif ($key =~ /^libswanted_/) {
		    my @libswanted = grep { not exists $lflibswanted{$_} }
		                          split(' ', $Config{libswanted});
		    $Config{libswanted} = join(' ', @libswanted);
		}
	    }
	}
    } else {
	$marker = "$_[1]=";
	# return undef unless (($value) = $config_sh =~ m/^$_[1]='(.*)'\s*$/m);
	# Check for the common case, ' delimeted
	$start = index($config_sh, "\n$marker$quote_type");
	# If that failed, check for " delimited
	if ($start == -1) {
	    $quote_type = '"';
	    $start = index($config_sh, "\n$marker$quote_type");
	}
	return undef if ( ($start == -1) &&  # in case it's first 
			  (substr($config_sh, 0, length($marker)) ne $marker) );
	if ($start == -1) { 
	    # It's the very first thing we found. Skip $start forward
	    # and figure out the quote mark after the =.
	    $start = length($marker) + 1;
	    $quote_type = substr($config_sh, $start - 1, 1);
	} 
	else { 
	    $start += length($marker) + 2;
	}
	$value = substr($config_sh, $start, 
			index($config_sh, "$quote_type\n", $start) - $start);
    }
    # If we had a double-quote, we'd better eval it so escape
    # sequences and such can be interpolated. Since the incoming
    # value is supposed to follow shell rules and not perl rules,
    # we escape any perl variable markers
    if ($quote_type eq '"') {
	$value =~ s/\$/\\\$/g;
	$value =~ s/\@/\\\@/g;
	eval "\$value = \"$value\"";
    }
    #$value = sprintf($value) if $quote_type eq '"';
    # So we can say "if $Config{'foo'}".
    $value = undef if $value eq 'undef';
    $_[0]->{$_[1]} = $value; # cache it
    return $value;
}
 
my $prevpos = 0;

sub FIRSTKEY {
    $prevpos = 0;
    # my($key) = $config_sh =~ m/^(.*?)=/;
    substr($config_sh, 0, index($config_sh, '=') );
    # $key;
}

sub NEXTKEY {
    # Find out how the current key's quoted so we can skip to its end.
    my $quote = substr($config_sh, index($config_sh, "=", $prevpos)+1, 1);
    my $pos = index($config_sh, qq($quote\n), $prevpos) + 2;
    my $len = index($config_sh, "=", $pos) - $pos;
    $prevpos = $pos;
    $len > 0 ? substr($config_sh, $pos, $len) : undef;
}

sub EXISTS { 
    # exists($_[0]->{$_[1]})  or  $config_sh =~ m/^$_[1]=/m;
    exists($_[0]->{$_[1]}) or
    index($config_sh, "\n$_[1]='") != -1 or
    substr($config_sh, 0, length($_[1])+2) eq "$_[1]='" or
    index($config_sh, "\n$_[1]=\"") != -1 or
    substr($config_sh, 0, length($_[1])+2) eq "$_[1]=\"" or
    $_[1] =~ /^(?:(?:cc|ld)flags|libs(?:wanted)?)_nolargefiles$/;
}

sub STORE  { die "\%Config::Config is read-only\n" }
sub DELETE { &STORE }
sub CLEAR  { &STORE }


sub config_sh {
    $config_sh
}

sub config_re {
    my $re = shift;
    my @matches = ($config_sh =~ /^$re=.*\n/mg);
    @matches ? (print @matches) : print "$re: not found\n";
}

sub config_vars {
    foreach(@_){
	config_re($_), next if /\W/;
	my $v=(exists $Config{$_}) ? $Config{$_} : 'UNKNOWN';
	$v='undef' unless defined $v;
	print "$_='$v';\n";
    }
}

sub TIEHASH { bless {} }

# avoid Config..Exporter..UNIVERSAL search for DESTROY then AUTOLOAD
sub DESTROY { }

tie %Config, 'Config';

1;
__END__

=head1 NAME

Config - access Perl configuration information

=head1 SYNOPSIS

    use Config;
    if ($Config{'cc'} =~ /gcc/) {
	print "built by gcc\n";
    } 

    use Config qw(myconfig config_sh config_vars);

    print myconfig();

    print config_sh();

    config_vars(qw(osname archname));


=head1 DESCRIPTION

The Config module contains all the information that was available to
the C<Configure> program at Perl build time (over 900 values).

Shell variables from the F<config.sh> file (written by Configure) are
stored in the readonly-variable C<%Config>, indexed by their names.

Values stored in config.sh as 'undef' are returned as undefined
values.  The perl C<exists> function can be used to check if a
named variable exists.

=over 4

=item myconfig()

Returns a textual summary of the major perl configuration values.
See also C<-V> in L<perlrun/Switches>.

=item config_sh()

Returns the entire perl configuration information in the form of the
original config.sh shell variable assignment script.

=item config_vars(@names)

Prints to STDOUT the values of the named configuration variable. Each is
printed on a separate line in the form:

  name='value';

Names which are unknown are output as C<name='UNKNOWN';>.
See also C<-V:name> in L<perlrun/Switches>.

=back

=head1 EXAMPLE

Here's a more sophisticated example of using %Config:

    use Config;
    use strict;

    my %sig_num;
    my @sig_name;
    unless($Config{sig_name} && $Config{sig_num}) {
	die "No sigs?";
    } else {
	my @names = split ' ', $Config{sig_name};
	@sig_num{@names} = split ' ', $Config{sig_num};
	foreach (@names) {
	    $sig_name[$sig_num{$_}] ||= $_;
	}   
    }

    print "signal #17 = $sig_name[17]\n";
    if ($sig_num{ALRM}) { 
	print "SIGALRM is $sig_num{ALRM}\n";
    }   

=head1 WARNING

Because this information is not stored within the perl executable
itself it is possible (but unlikely) that the information does not
relate to the actual perl binary which is being used to access it.

The Config module is installed into the architecture and version
specific library directory ($Config{installarchlib}) and it checks the
perl version number when loaded.

The values stored in config.sh may be either single-quoted or
double-quoted. Double-quoted strings are handy for those cases where you
need to include escape sequences in the strings. To avoid runtime variable
interpolation, any C<$> and C<@> characters are replaced by C<\$> and
C<\@>, respectively. This isn't foolproof, of course, so don't embed C<\$>
or C<\@> in double-quoted strings unless you're willing to deal with the
consequences. (The slashes will end up escaped and the C<$> or C<@> will
trigger variable interpolation)

=head1 GLOSSARY

Most C<Config> variables are determined by the C<Configure> script
on platforms supported by it (which is most UNIX platforms).  Some
platforms have custom-made C<Config> variables, and may thus not have
some of the variables described below, or may have extraneous variables
specific to that particular port.  See the port specific documentation
in such cases.

=head2 _

=over

=item C<_a>

From F<Unix.U>:

This variable defines the extension used for ordinary libraries.
For unix, it is F<.a>.  The F<.> is included.  Other possible
values include F<.lib>.

=item C<_exe>

From F<Unix.U>:

This variable defines the extension used for executable files.
For unix it is empty.  Other possible values include F<.exe>.

=item C<_o>

From F<Unix.U>:

This variable defines the extension used for object files.
For unix, it is F<.o>.  The F<.> is included.  Other possible
values include F<.obj>.

=back

=head2 a

=over

=item C<afs>

From F<afs.U>:

This variable is set to C<true> if C<AFS> (Andrew File System) is used
on the system, C<false> otherwise.  It is possible to override this
with a hint value or command line option, but you'd better know
what you are doing.

=item C<alignbytes>

From F<alignbytes.U>:

This variable holds the number of bytes required to align a
double-- or a long double when applicable. Usual values are
2, 4 and 8.  The default is eight, for safety.

=item C<ansi2knr>

From F<ansi2knr.U>:

This variable is set if the user needs to run ansi2knr.  
Currently, this is not supported, so we just abort.

=item C<aphostname>

From F<d_gethname.U>:

This variable contains the command which can be used to compute the
host name. The command is fully qualified by its absolute path, to make
it safe when used by a process with super-user privileges.

=item C<api_revision>

From F<patchlevel.U>:

The three variables, api_revision, api_version, and
api_subversion, specify the version of the oldest perl binary
compatible with the present perl.  In a full version string
such as F<5.6.1>, api_revision is the C<5>.
Prior to 5.5.640, the format was a floating point number,
like 5.00563.

	F<perl.c>:incpush() and F<lib/lib.pm> will automatically search in

	$F<sitelib/.>. for older directories back to the limit specified
by these api_ variables.  This is only useful if you have a
perl library directory tree structured like the default one.
See C<INSTALL> for how this works.  The versioned site_perl
directory was introduced in 5.005, so that is the lowest
possible value.  The version list appropriate for the current
system is determined in F<inc_version_list.U>.

	C<XXX> To do:  Since compatibility can depend on compile time

	options (such as bincompat, longlong, F<etc.>) it should
(perhaps) be set by Configure, but currently it isn't.
Currently, we read a hard-wired value from F<patchlevel.h>.
Perhaps what we ought to do is take the hard-wired value from
F<patchlevel.h> but then modify it if the current Configure
options warrant.  F<patchlevel.h> then would use an #ifdef guard.

=item C<api_subversion>

From F<patchlevel.U>:

The three variables, api_revision, api_version, and
api_subversion, specify the version of the oldest perl binary
compatible with the present perl.  In a full version string
such as F<5.6.1>, api_subversion is the C<1>.  See api_revision for
full details.

=item C<api_version>

From F<patchlevel.U>:

The three variables, api_revision, api_version, and
api_subversion, specify the version of the oldest perl binary
compatible with the present perl.  In a full version string
such as F<5.6.1>, api_version is the C<6>.  See api_revision for
full details.  As a special case, 5.5.0 is rendered in the
old-style as 5.005.  (In the 5.005_0x maintenance series,
this was the only versioned directory in $F<sitelib.>)

=item C<api_versionstring>

From F<patchlevel.U>:

This variable combines api_revision, api_version, and
api_subversion in a format such as 5.6.1 (or 5_6_1) suitable
for use as a directory name.  This is filesystem dependent.

=item C<ar>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the ar program.  After Configure runs,
the value is reset to a plain C<ar> and is not useful.

=item C<archlib>

From F<archlib.U>:

This variable holds the name of the directory in which the user wants
to put architecture-dependent public library files for $package.
It is most often a local directory such as F</usr/local/lib>.
Programs using this variable must be prepared to deal
with filename expansion.

=item C<archlibexp>

From F<archlib.U>:

This variable is the same as the archlib variable, but is
filename expanded at configuration time, for convenient use.

=item C<archname64>

From F<use64bits.U>:

This variable is used for the 64-bitness part of $archname.

=item C<archname>

From F<archname.U>:

This variable is a short name to characterize the current
architecture.  It is used mainly to construct the default archlib.

=item C<archobjs>

From F<Unix.U>:

This variable defines any additional objects that must be linked
in with the program on this architecture.  On unix, it is usually
empty.  It is typically used to include emulations of unix calls
or other facilities.  For perl on F<OS/2>, for example, this would
include F<os2/os2.obj>.

=item C<awk>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the awk program.  After Configure runs,
the value is reset to a plain C<awk> and is not useful.

=back

=head2 b

=over

=item C<baserev>

From F<baserev.U>:

The base revision level of this package, from the F<.package> file.

=item C<bash>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<bin>

From F<bin.U>:

This variable holds the name of the directory in which the user wants
to put publicly executable images for the package in question.  It
is most often a local directory such as F</usr/local/bin>. Programs using
this variable must be prepared to deal with F<~name> substitution.

=item C<bincompat5005>

From F<bincompat5005.U>:

This variable contains y if this version of Perl should be
binary-compatible with Perl 5.005.

=item C<binexp>

From F<bin.U>:

This is the same as the bin variable, but is filename expanded at
configuration time, for use in your makefiles.

=item C<bison>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<byacc>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the byacc program.  After Configure runs,
the value is reset to a plain C<byacc> and is not useful.

=item C<byteorder>

From F<byteorder.U>:

This variable holds the byte order. In the following, larger digits
indicate more significance.  The variable byteorder is either 4321
on a big-endian machine, or 1234 on a little-endian, or 87654321
on a Cray ... or 3412 with weird order !

=back

=head2 c

=over

=item C<c>

From F<n.U>:

This variable contains the \c string if that is what causes the echo
command to suppress newline.  Otherwise it is null.  Correct usage is
$echo $n "prompt for a question: $c".

=item C<castflags>

From F<d_castneg.U>:

This variable contains a flag that precise difficulties the
compiler has casting odd floating values to unsigned long:
0 = ok
1 = couldn't cast < 0
2 = couldn't cast >= 0x80000000
4 = couldn't cast in argument expression list

=item C<cat>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the cat program.  After Configure runs,
the value is reset to a plain C<cat> and is not useful.

=item C<cc>

From F<cc.U>:

This variable holds the name of a command to execute a C compiler which
can resolve multiple global references that happen to have the same
name.  Usual values are C<cc> and C<gcc>.
Fervent C<ANSI> compilers may be called C<c89>.  C<AIX> has xlc.

=item C<cccdlflags>

From F<dlsrc.U>:

This variable contains any special flags that might need to be
passed with C<cc -c> to compile modules to be used to create a shared
library that will be used for dynamic loading.  For hpux, this
should be +z.  It is up to the makefile to use it.

=item C<ccdlflags>

From F<dlsrc.U>:

This variable contains any special flags that might need to be
passed to cc to link with a shared library for dynamic loading.
It is up to the makefile to use it.  For sunos 4.1, it should
be empty.

=item C<ccflags>

From F<ccflags.U>:

This variable contains any additional C compiler flags desired by
the user.  It is up to the Makefile to use this.

=item C<ccflags_uselargefiles>

From F<uselfs.U>:

This variable contains the compiler flags needed by large file builds
and added to ccflags by hints files.

=item C<ccname>

From F<Checkcc.U>:

This can set either by hints files or by Configure.  If using
gcc, this is gcc, and if not, usually equal to cc, unimpressive, no?
Some platforms, however, make good use of this by storing the
flavor of the C compiler being used here.  For example if using
the Sun WorkShop suite, ccname will be C<workshop>.

=item C<ccsymbols>

From F<Cppsym.U>:

The variable contains the symbols defined by the C compiler alone.
The symbols defined by cpp or by cc when it calls cpp are not in
this list, see cppsymbols and cppccsymbols.
The list is a space-separated list of symbol=value tokens.

=item C<ccversion>

From F<Checkcc.U>:

This can set either by hints files or by Configure.  If using
a (non-gcc) vendor cc, this variable may contain a version for
the compiler.

=item C<cf_by>

From F<cf_who.U>:

Login name of the person who ran the Configure script and answered the
questions. This is used to tag both F<config.sh> and F<config_h.SH>.

=item C<cf_email>

From F<cf_email.U>:

Electronic mail address of the person who ran Configure. This can be
used by units that require the user's e-mail, like F<MailList.U>.

=item C<cf_time>

From F<cf_who.U>:

Holds the output of the C<date> command when the configuration file was
produced. This is used to tag both F<config.sh> and F<config_h.SH>.

=item C<charsize>

From F<charsize.U>:

This variable contains the value of the C<CHARSIZE> symbol, which
indicates to the C program how many bytes there are in a character.

=item C<chgrp>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<chmod>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<chown>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<clocktype>

From F<d_times.U>:

This variable holds the type returned by times(). It can be long,
or clock_t on C<BSD> sites (in which case <sys/types.h> should be
included).

=item C<comm>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the comm program.  After Configure runs,
the value is reset to a plain C<comm> and is not useful.

=item C<compress>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=back

=head2 C

=over

=item C<CONFIGDOTSH>

From F<Oldsyms.U>:

This is set to C<true> in F<config.sh> so that a shell script
sourcing F<config.sh> can tell if it has been sourced already.

=item C<contains>

From F<contains.U>:

This variable holds the command to do a grep with a proper return
status.  On most sane systems it is simply C<grep>.  On insane systems
it is a grep followed by a cat followed by a test.  This variable
is primarily for the use of other Configure units.

=item C<cp>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the cp program.  After Configure runs,
the value is reset to a plain C<cp> and is not useful.

=item C<cpio>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<cpp>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the cpp program.  After Configure runs,
the value is reset to a plain C<cpp> and is not useful.

=item C<cpp_stuff>

From F<cpp_stuff.U>:

This variable contains an identification of the catenation mechanism
used by the C preprocessor.

=item C<cppccsymbols>

From F<Cppsym.U>:

The variable contains the symbols defined by the C compiler
when it calls cpp.  The symbols defined by the cc alone or cpp
alone are not in this list, see ccsymbols and cppsymbols.
The list is a space-separated list of symbol=value tokens.

=item C<cppflags>

From F<ccflags.U>:

This variable holds the flags that will be passed to the C pre-
processor. It is up to the Makefile to use it.

=item C<cpplast>

From F<cppstdin.U>:

This variable has the same functionality as cppminus, only it applies
to cpprun and not cppstdin.

=item C<cppminus>

From F<cppstdin.U>:

This variable contains the second part of the string which will invoke
the C preprocessor on the standard input and produce to standard
output.  This variable will have the value C<-> if cppstdin needs
a minus to specify standard input, otherwise the value is "".

=item C<cpprun>

From F<cppstdin.U>:

This variable contains the command which will invoke a C preprocessor
on standard input and put the output to stdout. It is guaranteed not
to be a wrapper and may be a null string if no preprocessor can be
made directly available. This preprocessor might be different from the
one used by the C compiler. Don't forget to append cpplast after the
preprocessor options.

=item C<cppstdin>

From F<cppstdin.U>:

This variable contains the command which will invoke the C
preprocessor on standard input and put the output to stdout.
It is primarily used by other Configure units that ask about
preprocessor symbols.

=item C<cppsymbols>

From F<Cppsym.U>:

The variable contains the symbols defined by the C preprocessor
alone.  The symbols defined by cc or by cc when it calls cpp are
not in this list, see ccsymbols and cppccsymbols.
The list is a space-separated list of symbol=value tokens.

=item C<crosscompile>

From F<crosscompile.U>:

This variable conditionally defines the C<CROSSCOMPILE> symbol
which signifies that the build process is be a cross-compilation.
This is normally set by hints files or from Configure command line.

=item C<cryptlib>

From F<d_crypt.U>:

This variable holds -lcrypt or the path to a F<libcrypt.a> archive if
the crypt() function is not defined in the standard C library. It is
up to the Makefile to use this.

=item C<csh>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the csh program.  After Configure runs,
the value is reset to a plain C<csh> and is not useful.

=back

=head2 d

=over

=item C<d__fwalk>

From F<d__fwalk.U>:

This variable conditionally defines C<HAS__FWALK> if _fwalk() is
available to apply a function to all the file handles.

=item C<d_access>

From F<d_access.U>:

This variable conditionally defines C<HAS_ACCESS> if the access() system
call is available to check for access permissions using real IDs.

=item C<d_accessx>

From F<d_accessx.U>:

This variable conditionally defines the C<HAS_ACCESSX> symbol, which
indicates to the C program that the accessx() routine is available.

=item C<d_alarm>

From F<d_alarm.U>:

This variable conditionally defines the C<HAS_ALARM> symbol, which
indicates to the C program that the alarm() routine is available.

=item C<d_archlib>

From F<archlib.U>:

This variable conditionally defines C<ARCHLIB> to hold the pathname
of architecture-dependent library files for $package.  If
$archlib is the same as $privlib, then this is set to undef.

=item C<d_atolf>

From F<atolf.U>:

This variable conditionally defines the C<HAS_ATOLF> symbol, which
indicates to the C program that the atolf() routine is available.

=item C<d_atoll>

From F<atoll.U>:

This variable conditionally defines the C<HAS_ATOLL> symbol, which
indicates to the C program that the atoll() routine is available.

=item C<d_attribut>

From F<d_attribut.U>:

This variable conditionally defines C<HASATTRIBUTE>, which
indicates the C compiler can check for function attributes,
such as printf formats.

=item C<d_bcmp>

From F<d_bcmp.U>:

This variable conditionally defines the C<HAS_BCMP> symbol if
the bcmp() routine is available to compare strings.

=item C<d_bcopy>

From F<d_bcopy.U>:

This variable conditionally defines the C<HAS_BCOPY> symbol if
the bcopy() routine is available to copy strings.

=item C<d_bincompat5005>

From F<bincompat5005.U>:

This variable conditionally defines BINCOMPAT5005 so that F<embed.h>
can take special action if this version of Perl should be
binary-compatible with Perl 5.005.  This is impossible for builds
that use features like threads and multiplicity it is always $undef
for those versions.

=item C<d_bsd>

From F<Guess.U>:

This symbol conditionally defines the symbol C<BSD> when running on a
C<BSD> system.

=item C<d_bsdgetpgrp>

From F<d_getpgrp.U>:

This variable conditionally defines C<USE_BSD_GETPGRP> if
getpgrp needs one arguments whereas C<USG> one needs none.

=item C<d_bsdsetpgrp>

From F<d_setpgrp.U>:

This variable conditionally defines C<USE_BSD_SETPGRP> if
setpgrp needs two arguments whereas C<USG> one needs none.
See also d_setpgid for a C<POSIX> interface.

=item C<d_bzero>

From F<d_bzero.U>:

This variable conditionally defines the C<HAS_BZERO> symbol if
the bzero() routine is available to set memory to 0.

=item C<d_casti32>

From F<d_casti32.U>:

This variable conditionally defines CASTI32, which indicates
whether the C compiler can cast large floats to 32-bit ints.

=item C<d_castneg>

From F<d_castneg.U>:

This variable conditionally defines C<CASTNEG>, which indicates
wether the C compiler can cast negative float to unsigned.

=item C<d_charvspr>

From F<d_vprintf.U>:

This variable conditionally defines C<CHARVSPRINTF> if this system
has vsprintf returning type (char*).  The trend seems to be to
declare it as "int vsprintf()".

=item C<d_chown>

From F<d_chown.U>:

This variable conditionally defines the C<HAS_CHOWN> symbol, which
indicates to the C program that the chown() routine is available.

=item C<d_chroot>

From F<d_chroot.U>:

This variable conditionally defines the C<HAS_CHROOT> symbol, which
indicates to the C program that the chroot() routine is available.

=item C<d_chsize>

From F<d_chsize.U>:

This variable conditionally defines the C<CHSIZE> symbol, which
indicates to the C program that the chsize() routine is available
to truncate files.  You might need a -lx to get this routine.

=item C<d_closedir>

From F<d_closedir.U>:

This variable conditionally defines C<HAS_CLOSEDIR> if closedir() is
available.

=item C<d_const>

From F<d_const.U>:

This variable conditionally defines the C<HASCONST> symbol, which
indicates to the C program that this C compiler knows about the
const type.

=item C<d_crypt>

From F<d_crypt.U>:

This variable conditionally defines the C<CRYPT> symbol, which
indicates to the C program that the crypt() routine is available
to encrypt passwords and the like.

=item C<d_csh>

From F<d_csh.U>:

This variable conditionally defines the C<CSH> symbol, which
indicates to the C program that the C-shell exists.

=item C<d_cuserid>

From F<d_cuserid.U>:

This variable conditionally defines the C<HAS_CUSERID> symbol, which
indicates to the C program that the cuserid() routine is available
to get character login names.

=item C<d_dbl_dig>

From F<d_dbl_dig.U>:

This variable conditionally defines d_dbl_dig if this system's
header files provide C<DBL_DIG>, which is the number of significant
digits in a double precision number.

=item C<d_difftime>

From F<d_difftime.U>:

This variable conditionally defines the C<HAS_DIFFTIME> symbol, which
indicates to the C program that the difftime() routine is available.

=item C<d_dirnamlen>

From F<i_dirent.U>:

This variable conditionally defines C<DIRNAMLEN>, which indicates
to the C program that the length of directory entry names is
provided by a d_namelen field.

=item C<d_dlerror>

From F<d_dlerror.U>:

This variable conditionally defines the C<HAS_DLERROR> symbol, which
indicates to the C program that the dlerror() routine is available.

=item C<d_dlopen>

From F<d_dlopen.U>:

This variable conditionally defines the C<HAS_DLOPEN> symbol, which
indicates to the C program that the dlopen() routine is available.

=item C<d_dlsymun>

From F<d_dlsymun.U>:

This variable conditionally defines C<DLSYM_NEEDS_UNDERSCORE>, which
indicates that we need to prepend an underscore to the symbol
name before calling dlsym().

=item C<d_dosuid>

From F<d_dosuid.U>:

This variable conditionally defines the symbol C<DOSUID>, which
tells the C program that it should insert setuid emulation code
on hosts which have setuid #! scripts disabled.

=item C<d_drand48proto>

From F<d_drand48proto.U>:

This variable conditionally defines the HAS_DRAND48_PROTO symbol,
which indicates to the C program that the system provides
a prototype for the drand48() function.  Otherwise, it is
up to the program to supply one.

=item C<d_dup2>

From F<d_dup2.U>:

This variable conditionally defines HAS_DUP2 if dup2() is
available to duplicate file descriptors.

=item C<d_eaccess>

From F<d_eaccess.U>:

This variable conditionally defines the C<HAS_EACCESS> symbol, which
indicates to the C program that the eaccess() routine is available.

=item C<d_endgrent>

From F<d_endgrent.U>:

This variable conditionally defines the C<HAS_ENDGRENT> symbol, which
indicates to the C program that the endgrent() routine is available
for sequential access of the group database.

=item C<d_endhent>

From F<d_endhent.U>:

This variable conditionally defines C<HAS_ENDHOSTENT> if endhostent() is
available to close whatever was being used for host queries.

=item C<d_endnent>

From F<d_endnent.U>:

This variable conditionally defines C<HAS_ENDNETENT> if endnetent() is
available to close whatever was being used for network queries.

=item C<d_endpent>

From F<d_endpent.U>:

This variable conditionally defines C<HAS_ENDPROTOENT> if endprotoent() is
available to close whatever was being used for protocol queries.

=item C<d_endpwent>

From F<d_endpwent.U>:

This variable conditionally defines the C<HAS_ENDPWENT> symbol, which
indicates to the C program that the endpwent() routine is available
for sequential access of the passwd database.

=item C<d_endsent>

From F<d_endsent.U>:

This variable conditionally defines C<HAS_ENDSERVENT> if endservent() is
available to close whatever was being used for service queries.

=item C<d_eofnblk>

From F<nblock_io.U>:

This variable conditionally defines C<EOF_NONBLOCK> if C<EOF> can be seen
when reading from a non-blocking F<I/O> source.

=item C<d_eunice>

From F<Guess.U>:

This variable conditionally defines the symbols C<EUNICE> and C<VAX>, which
alerts the C program that it must deal with ideosyncracies of C<VMS>.

=item C<d_fchmod>

From F<d_fchmod.U>:

This variable conditionally defines the C<HAS_FCHMOD> symbol, which
indicates to the C program that the fchmod() routine is available
to change mode of opened files.

=item C<d_fchown>

From F<d_fchown.U>:

This variable conditionally defines the C<HAS_FCHOWN> symbol, which
indicates to the C program that the fchown() routine is available
to change ownership of opened files.

=item C<d_fcntl>

From F<d_fcntl.U>:

This variable conditionally defines the C<HAS_FCNTL> symbol, and indicates
whether the fcntl() function exists

=item C<d_fcntl_can_lock>

From F<d_fcntl_can_lock.U>:

This variable conditionally defines the C<FCNTL_CAN_LOCK> symbol
and indicates whether file locking with fcntl() works.

=item C<d_fd_macros>

From F<d_fd_set.U>:

This variable contains the eventual value of the C<HAS_FD_MACROS> symbol,
which indicates if your C compiler knows about the macros which
manipulate an fd_set.

=item C<d_fd_set>

From F<d_fd_set.U>:

This variable contains the eventual value of the C<HAS_FD_SET> symbol,
which indicates if your C compiler knows about the fd_set typedef.

=item C<d_fds_bits>

From F<d_fd_set.U>:

This variable contains the eventual value of the C<HAS_FDS_BITS> symbol,
which indicates if your fd_set typedef contains the fds_bits member.
If you have an fd_set typedef, but the dweebs who installed it did
a half-fast job and neglected to provide the macros to manipulate
an fd_set, C<HAS_FDS_BITS> will let us know how to fix the gaffe.

=item C<d_fgetpos>

From F<d_fgetpos.U>:

This variable conditionally defines C<HAS_FGETPOS> if fgetpos() is
available to get the file position indicator.

=item C<d_flexfnam>

From F<d_flexfnam.U>:

This variable conditionally defines the C<FLEXFILENAMES> symbol, which
indicates that the system supports filenames longer than 14 characters.

=item C<d_flock>

From F<d_flock.U>:

This variable conditionally defines C<HAS_FLOCK> if flock() is
available to do file locking.

=item C<d_fork>

From F<d_fork.U>:

This variable conditionally defines the C<HAS_FORK> symbol, which
indicates to the C program that the fork() routine is available.

=item C<d_fpathconf>

From F<d_pathconf.U>:

This variable conditionally defines the C<HAS_FPATHCONF> symbol, which
indicates to the C program that the pathconf() routine is available
to determine file-system related limits and options associated
with a given open file descriptor.

=item C<d_fpos64_t>

From F<d_fpos64_t.U>:

This symbol will be defined if the C compiler supports fpos64_t.

=item C<d_frexpl>

From F<d_frexpl.U>:

This variable conditionally defines the C<HAS_FREXPL> symbol, which
indicates to the C program that the frexpl() routine is available.

=item C<d_fs_data_s>

From F<d_fs_data_s.U>:

This variable conditionally defines the C<HAS_STRUCT_FS_DATA> symbol,
which indicates that the struct fs_data is supported.

=item C<d_fseeko>

From F<d_fseeko.U>:

This variable conditionally defines the C<HAS_FSEEKO> symbol, which
indicates to the C program that the fseeko() routine is available.

=item C<d_fsetpos>

From F<d_fsetpos.U>:

This variable conditionally defines C<HAS_FSETPOS> if fsetpos() is
available to set the file position indicator.

=item C<d_fstatfs>

From F<d_fstatfs.U>:

This variable conditionally defines the C<HAS_FSTATFS> symbol, which
indicates to the C program that the fstatfs() routine is available.

=item C<d_fstatvfs>

From F<d_statvfs.U>:

This variable conditionally defines the C<HAS_FSTATVFS> symbol, which
indicates to the C program that the fstatvfs() routine is available.

=item C<d_fsync>

From F<d_fsync.U>:

This variable conditionally defines the C<HAS_FSYNC> symbol, which
indicates to the C program that the fsync() routine is available.

=item C<d_ftello>

From F<d_ftello.U>:

This variable conditionally defines the C<HAS_FTELLO> symbol, which
indicates to the C program that the ftello() routine is available.

=item C<d_ftime>

From F<d_ftime.U>:

This variable conditionally defines the C<HAS_FTIME> symbol, which indicates
that the ftime() routine exists.  The ftime() routine is basically
a sub-second accuracy clock.

=item C<d_Gconvert>

From F<d_gconvert.U>:

This variable holds what Gconvert is defined as to convert
floating point numbers into strings. It could be C<gconvert>
or a more C<complex> macro emulating gconvert with gcvt() or sprintf.
Possible values are:
d_Gconvert=C<gconvert((x),(n),(t),(b))>
d_Gconvert=C<gcvt((x),(n),(b))>
d_Gconvert=C<sprintf((b),F<%F<.>*g>,(n),(x))>

=item C<d_getcwd>

From F<d_getcwd.U>:

This variable conditionally defines the C<HAS_GETCWD> symbol, which
indicates to the C program that the getcwd() routine is available
to get the current working directory.

=item C<d_getespwnam>

From F<d_getespwnam.U>:

This variable conditionally defines C<HAS_GETESPWNAM> if getespwnam() is
available to retrieve enchanced (shadow) password entries by name.

=item C<d_getfsstat>

From F<d_getfsstat.U>:

This variable conditionally defines the C<HAS_GETFSSTAT> symbol, which
indicates to the C program that the getfsstat() routine is available.

=item C<d_getgrent>

From F<d_getgrent.U>:

This variable conditionally defines the C<HAS_GETGRENT> symbol, which
indicates to the C program that the getgrent() routine is available
for sequential access of the group database.

=item C<d_getgrps>

From F<d_getgrps.U>:

This variable conditionally defines the C<HAS_GETGROUPS> symbol, which
indicates to the C program that the getgroups() routine is available
to get the list of process groups.

=item C<d_gethbyaddr>

From F<d_gethbyad.U>:

This variable conditionally defines the C<HAS_GETHOSTBYADDR> symbol, which
indicates to the C program that the gethostbyaddr() routine is available
to look up hosts by their C<IP> addresses.

=item C<d_gethbyname>

From F<d_gethbynm.U>:

This variable conditionally defines the C<HAS_GETHOSTBYNAME> symbol, which
indicates to the C program that the gethostbyname() routine is available
to look up host names in some data base or other.

=item C<d_gethent>

From F<d_gethent.U>:

This variable conditionally defines C<HAS_GETHOSTENT> if gethostent() is
available to look up host names in some data base or another.

=item C<d_gethname>

From F<d_gethname.U>:

This variable conditionally defines the C<HAS_GETHOSTNAME> symbol, which
indicates to the C program that the gethostname() routine may be
used to derive the host name.

=item C<d_gethostprotos>

From F<d_gethostprotos.U>:

This variable conditionally defines the C<HAS_GETHOST_PROTOS> symbol,
which indicates to the C program that <netdb.h> supplies
prototypes for the various gethost*() functions.  
See also F<netdbtype.U> for probing for various netdb types.

=item C<d_getlogin>

From F<d_getlogin.U>:

This variable conditionally defines the C<HAS_GETLOGIN> symbol, which
indicates to the C program that the getlogin() routine is available
to get the login name.

=item C<d_getmnt>

From F<d_getmnt.U>:

This variable conditionally defines the C<HAS_GETMNT> symbol, which
indicates to the C program that the getmnt() routine is available
to retrieve one or more mount info blocks by filename.

=item C<d_getmntent>

From F<d_getmntent.U>:

This variable conditionally defines the C<HAS_GETMNTENT> symbol, which
indicates to the C program that the getmntent() routine is available
to iterate through mounted files to get their mount info.

=item C<d_getnbyaddr>

From F<d_getnbyad.U>:

This variable conditionally defines the C<HAS_GETNETBYADDR> symbol, which
indicates to the C program that the getnetbyaddr() routine is available
to look up networks by their C<IP> addresses.

=item C<d_getnbyname>

From F<d_getnbynm.U>:

This variable conditionally defines the C<HAS_GETNETBYNAME> symbol, which
indicates to the C program that the getnetbyname() routine is available
to look up networks by their names.

=item C<d_getnent>

From F<d_getnent.U>:

This variable conditionally defines C<HAS_GETNETENT> if getnetent() is
available to look up network names in some data base or another.

=item C<d_getnetprotos>

From F<d_getnetprotos.U>:

This variable conditionally defines the C<HAS_GETNET_PROTOS> symbol,
which indicates to the C program that <netdb.h> supplies
prototypes for the various getnet*() functions.  
See also F<netdbtype.U> for probing for various netdb types.

=item C<d_getpagsz>

From F<d_getpagsz.U>:

This variable conditionally defines C<HAS_GETPAGESIZE> if getpagesize()
is available to get the system page size.

=item C<d_getpbyname>

From F<d_getprotby.U>:

This variable conditionally defines the C<HAS_GETPROTOBYNAME> 
symbol, which indicates to the C program that the 
getprotobyname() routine is available to look up protocols
by their name.

=item C<d_getpbynumber>

From F<d_getprotby.U>:

This variable conditionally defines the C<HAS_GETPROTOBYNUMBER> 
symbol, which indicates to the C program that the 
getprotobynumber() routine is available to look up protocols
by their number.

=item C<d_getpent>

From F<d_getpent.U>:

This variable conditionally defines C<HAS_GETPROTOENT> if getprotoent() is
available to look up protocols in some data base or another.

=item C<d_getpgid>

From F<d_getpgid.U>:

This variable conditionally defines the C<HAS_GETPGID> symbol, which
indicates to the C program that the getpgid(pid) function
is available to get the process group id.

=item C<d_getpgrp2>

From F<d_getpgrp2.U>:

This variable conditionally defines the HAS_GETPGRP2 symbol, which
indicates to the C program that the getpgrp2() (as in F<DG/C<UX>>) routine
is available to get the current process group.

=item C<d_getpgrp>

From F<d_getpgrp.U>:

This variable conditionally defines C<HAS_GETPGRP> if getpgrp() is
available to get the current process group.

=item C<d_getppid>

From F<d_getppid.U>:

This variable conditionally defines the C<HAS_GETPPID> symbol, which
indicates to the C program that the getppid() routine is available
to get the parent process C<ID>.

=item C<d_getprior>

From F<d_getprior.U>:

This variable conditionally defines C<HAS_GETPRIORITY> if getpriority()
is available to get a process's priority.

=item C<d_getprotoprotos>

From F<d_getprotoprotos.U>:

This variable conditionally defines the C<HAS_GETPROTO_PROTOS> symbol,
which indicates to the C program that <netdb.h> supplies
prototypes for the various getproto*() functions.  
See also F<netdbtype.U> for probing for various netdb types.

=item C<d_getprpwnam>

From F<d_getprpwnam.U>:

This variable conditionally defines C<HAS_GETPRPWNAM> if getprpwnam() is
available to retrieve protected (shadow) password entries by name.

=item C<d_getpwent>

From F<d_getpwent.U>:

This variable conditionally defines the C<HAS_GETPWENT> symbol, which
indicates to the C program that the getpwent() routine is available
for sequential access of the passwd database.

=item C<d_getsbyname>

From F<d_getsrvby.U>:

This variable conditionally defines the C<HAS_GETSERVBYNAME> 
symbol, which indicates to the C program that the 
getservbyname() routine is available to look up services
by their name.

=item C<d_getsbyport>

From F<d_getsrvby.U>:

This variable conditionally defines the C<HAS_GETSERVBYPORT> 
symbol, which indicates to the C program that the 
getservbyport() routine is available to look up services
by their port.

=item C<d_getsent>

From F<d_getsent.U>:

This variable conditionally defines C<HAS_GETSERVENT> if getservent() is
available to look up network services in some data base or another.

=item C<d_getservprotos>

From F<d_getservprotos.U>:

This variable conditionally defines the C<HAS_GETSERV_PROTOS> symbol,
which indicates to the C program that <netdb.h> supplies
prototypes for the various getserv*() functions.  
See also F<netdbtype.U> for probing for various netdb types.

=item C<d_getspnam>

From F<d_getspnam.U>:

This variable conditionally defines C<HAS_GETSPNAM> if getspnam() is
available to retrieve SysV shadow password entries by name.

=item C<d_gettimeod>

From F<d_ftime.U>:

This variable conditionally defines the C<HAS_GETTIMEOFDAY> symbol, which
indicates that the gettimeofday() system call exists (to obtain a
sub-second accuracy clock). You should probably include <sys/resource.h>.

=item C<d_gnulibc>

From F<d_gnulibc.U>:

Defined if we're dealing with the C<GNU> C Library.

=item C<d_grpasswd>

From F<i_grp.U>:

This variable conditionally defines C<GRPASSWD>, which indicates
that struct group in <grp.h> contains gr_passwd.

=item C<d_hasmntopt>

From F<d_hasmntopt.U>:

This variable conditionally defines the C<HAS_HASMNTOPT> symbol, which
indicates to the C program that the hasmntopt() routine is available
to query the mount options of file systems.

=item C<d_htonl>

From F<d_htonl.U>:

This variable conditionally defines C<HAS_HTONL> if htonl() and its
friends are available to do network order byte swapping.

=item C<d_iconv>

From F<d_iconv.U>:

This variable conditionally defines the C<HAS_ICONV> symbol, which
indicates to the C program that the iconv() routine is available.

=item C<d_index>

From F<d_strchr.U>:

This variable conditionally defines C<HAS_INDEX> if index() and
rindex() are available for string searching.

=item C<d_inetaton>

From F<d_inetaton.U>:

This variable conditionally defines the C<HAS_INET_ATON> symbol, which
indicates to the C program that the inet_aton() function is available
to parse C<IP> address C<dotted-quad> strings.

=item C<d_int64_t>

From F<d_int64_t.U>:

This symbol will be defined if the C compiler supports int64_t.

=item C<d_isascii>

From F<d_isascii.U>:

This variable conditionally defines the C<HAS_ISASCII> constant,
which indicates to the C program that isascii() is available.

=item C<d_isnan>

From F<d_isnan.U>:

This variable conditionally defines the C<HAS_ISNAN> symbol, which
indicates to the C program that the isnan() routine is available.

=item C<d_isnanl>

From F<d_isnanl.U>:

This variable conditionally defines the C<HAS_ISNANL> symbol, which
indicates to the C program that the isnanl() routine is available.

=item C<d_killpg>

From F<d_killpg.U>:

This variable conditionally defines the C<HAS_KILLPG> symbol, which
indicates to the C program that the killpg() routine is available
to kill process groups.

=item C<d_lchown>

From F<d_lchown.U>:

This variable conditionally defines the C<HAS_LCHOWN> symbol, which
indicates to the C program that the lchown() routine is available
to operate on a symbolic link (instead of following the link).

=item C<d_ldbl_dig>

From F<d_ldbl_dig.U>:

This variable conditionally defines d_ldbl_dig if this system's
header files provide C<LDBL_DIG>, which is the number of significant
digits in a long double precision number.

=item C<d_link>

From F<d_link.U>:

This variable conditionally defines C<HAS_LINK> if link() is
available to create hard links.

=item C<d_locconv>

From F<d_locconv.U>:

This variable conditionally defines C<HAS_LOCALECONV> if localeconv() is
available for numeric and monetary formatting conventions.

=item C<d_lockf>

From F<d_lockf.U>:

This variable conditionally defines C<HAS_LOCKF> if lockf() is
available to do file locking.

=item C<d_longdbl>

From F<d_longdbl.U>:

This variable conditionally defines C<HAS_LONG_DOUBLE> if 
the long double type is supported.

=item C<d_longlong>

From F<d_longlong.U>:

This variable conditionally defines C<HAS_LONG_LONG> if 
the long long type is supported.

=item C<d_lseekproto>

From F<d_lseekproto.U>:

This variable conditionally defines the C<HAS_LSEEK_PROTO> symbol,
which indicates to the C program that the system provides
a prototype for the lseek() function.  Otherwise, it is
up to the program to supply one.

=item C<d_lstat>

From F<d_lstat.U>:

This variable conditionally defines C<HAS_LSTAT> if lstat() is
available to do file stats on symbolic links.

=item C<d_madvise>

From F<d_madvise.U>:

This variable conditionally defines C<HAS_MADVISE> if madvise() is
available to map a file into memory.

=item C<d_mblen>

From F<d_mblen.U>:

This variable conditionally defines the C<HAS_MBLEN> symbol, which
indicates to the C program that the mblen() routine is available
to find the number of bytes in a multibye character.

=item C<d_mbstowcs>

From F<d_mbstowcs.U>:

This variable conditionally defines the C<HAS_MBSTOWCS> symbol, which
indicates to the C program that the mbstowcs() routine is available
to convert a multibyte string into a wide character string.

=item C<d_mbtowc>

From F<d_mbtowc.U>:

This variable conditionally defines the C<HAS_MBTOWC> symbol, which
indicates to the C program that the mbtowc() routine is available
to convert multibyte to a wide character.

=item C<d_memchr>

From F<d_memchr.U>:

This variable conditionally defines the C<HAS_MEMCHR> symbol, which
indicates to the C program that the memchr() routine is available
to locate characters within a C string.

=item C<d_memcmp>

From F<d_memcmp.U>:

This variable conditionally defines the C<HAS_MEMCMP> symbol, which
indicates to the C program that the memcmp() routine is available
to compare blocks of memory.

=item C<d_memcpy>

From F<d_memcpy.U>:

This variable conditionally defines the C<HAS_MEMCPY> symbol, which
indicates to the C program that the memcpy() routine is available
to copy blocks of memory.

=item C<d_memmove>

From F<d_memmove.U>:

This variable conditionally defines the C<HAS_MEMMOVE> symbol, which
indicates to the C program that the memmove() routine is available
to copy potentatially overlapping blocks of memory.

=item C<d_memset>

From F<d_memset.U>:

This variable conditionally defines the C<HAS_MEMSET> symbol, which
indicates to the C program that the memset() routine is available
to set blocks of memory.

=item C<d_mkdir>

From F<d_mkdir.U>:

This variable conditionally defines the C<HAS_MKDIR> symbol, which
indicates to the C program that the mkdir() routine is available
to create F<directories.>.

=item C<d_mkdtemp>

From F<d_mkdtemp.U>:

This variable conditionally defines the C<HAS_MKDTEMP> symbol, which
indicates to the C program that the mkdtemp() routine is available
to exclusively create a uniquely named temporary directory.

=item C<d_mkfifo>

From F<d_mkfifo.U>:

This variable conditionally defines the C<HAS_MKFIFO> symbol, which
indicates to the C program that the mkfifo() routine is available.

=item C<d_mkstemp>

From F<d_mkstemp.U>:

This variable conditionally defines the C<HAS_MKSTEMP> symbol, which
indicates to the C program that the mkstemp() routine is available
to exclusively create and open a uniquely named temporary file.

=item C<d_mkstemps>

From F<d_mkstemps.U>:

This variable conditionally defines the C<HAS_MKSTEMPS> symbol, which
indicates to the C program that the mkstemps() routine is available
to exclusively create and open a uniquely named (with a suffix)
temporary file.

=item C<d_mktime>

From F<d_mktime.U>:

This variable conditionally defines the C<HAS_MKTIME> symbol, which
indicates to the C program that the mktime() routine is available.

=item C<d_mmap>

From F<d_mmap.U>:

This variable conditionally defines C<HAS_MMAP> if mmap() is
available to map a file into memory.

=item C<d_modfl>

From F<d_modfl.U>:

This variable conditionally defines the C<HAS_MODFL> symbol, which
indicates to the C program that the modfl() routine is available.

=item C<d_mprotect>

From F<d_mprotect.U>:

This variable conditionally defines C<HAS_MPROTECT> if mprotect() is
available to modify the access protection of a memory mapped file.

=item C<d_msg>

From F<d_msg.U>:

This variable conditionally defines the C<HAS_MSG> symbol, which
indicates that the entire msg*(2) library is present.

=item C<d_msg_ctrunc>

From F<d_socket.U>:

This variable conditionally defines the C<HAS_MSG_CTRUNC> symbol,
which indicates that the C<MSG_CTRUNC> is available.  #ifdef is
not enough because it may be an enum, glibc has been known to do this.

=item C<d_msg_dontroute>

From F<d_socket.U>:

This variable conditionally defines the C<HAS_MSG_DONTROUTE> symbol,
which indicates that the C<MSG_DONTROUTE> is available.  #ifdef is
not enough because it may be an enum, glibc has been known to do this.

=item C<d_msg_oob>

From F<d_socket.U>:

This variable conditionally defines the C<HAS_MSG_OOB> symbol,
which indicates that the C<MSG_OOB> is available.  #ifdef is
not enough because it may be an enum, glibc has been known to do this.

=item C<d_msg_peek>

From F<d_socket.U>:

This variable conditionally defines the C<HAS_MSG_PEEK> symbol,
which indicates that the C<MSG_PEEK> is available.  #ifdef is
not enough because it may be an enum, glibc has been known to do this.

=item C<d_msg_proxy>

From F<d_socket.U>:

This variable conditionally defines the C<HAS_MSG_PROXY> symbol,
which indicates that the C<MSG_PROXY> is available.  #ifdef is
not enough because it may be an enum, glibc has been known to do this.

=item C<d_msgctl>

From F<d_msgctl.U>:

This variable conditionally defines the C<HAS_MSGCTL> symbol, which
indicates to the C program that the msgctl() routine is available.

=item C<d_msgget>

From F<d_msgget.U>:

This variable conditionally defines the C<HAS_MSGGET> symbol, which
indicates to the C program that the msgget() routine is available.

=item C<d_msgrcv>

From F<d_msgrcv.U>:

This variable conditionally defines the C<HAS_MSGRCV> symbol, which
indicates to the C program that the msgrcv() routine is available.

=item C<d_msgsnd>

From F<d_msgsnd.U>:

This variable conditionally defines the C<HAS_MSGSND> symbol, which
indicates to the C program that the msgsnd() routine is available.

=item C<d_msync>

From F<d_msync.U>:

This variable conditionally defines C<HAS_MSYNC> if msync() is
available to synchronize a mapped file.

=item C<d_munmap>

From F<d_munmap.U>:

This variable conditionally defines C<HAS_MUNMAP> if munmap() is
available to unmap a region mapped by mmap().

=item C<d_mymalloc>

From F<mallocsrc.U>:

This variable conditionally defines C<MYMALLOC> in case other parts
of the source want to take special action if C<MYMALLOC> is used.
This may include different sorts of profiling or error detection.

=item C<d_nice>

From F<d_nice.U>:

This variable conditionally defines the C<HAS_NICE> symbol, which
indicates to the C program that the nice() routine is available.

=item C<d_nv_preserves_uv>

From F<perlxv.U>:

This variable indicates whether a variable of type nvtype
can preserve all the bits a variable of type uvtype.

=item C<d_nv_preserves_uv_bits>

From F<perlxv.U>:

This variable indicates how many of bits type uvtype
a variable nvtype can preserve.

=item C<d_off64_t>

From F<d_off64_t.U>:

This symbol will be defined if the C compiler supports off64_t.

=item C<d_old_pthread_create_joinable>

From F<d_pthrattrj.U>:

This variable conditionally defines pthread_create_joinable.
undef if F<pthread.h> defines C<PTHREAD_CREATE_JOINABLE>.

=item C<d_oldpthreads>

From F<usethreads.U>:

This variable conditionally defines the C<OLD_PTHREADS_API> symbol,
and indicates that Perl should be built to use the old
draft C<POSIX> threads C<API>.  This is only potentially meaningful if
usethreads is set.

=item C<d_oldsock>

From F<d_socket.U>:

This variable conditionally defines the C<OLDSOCKET> symbol, which
indicates that the C<BSD> socket interface is based on 4.1c and not 4.2.

=item C<d_open3>

From F<d_open3.U>:

This variable conditionally defines the HAS_OPEN3 manifest constant,
which indicates to the C program that the 3 argument version of
the open(2) function is available.

=item C<d_pathconf>

From F<d_pathconf.U>:

This variable conditionally defines the C<HAS_PATHCONF> symbol, which
indicates to the C program that the pathconf() routine is available
to determine file-system related limits and options associated
with a given filename.

=item C<d_pause>

From F<d_pause.U>:

This variable conditionally defines the C<HAS_PAUSE> symbol, which
indicates to the C program that the pause() routine is available
to suspend a process until a signal is received.

=item C<d_perl_otherlibdirs>

From F<otherlibdirs.U>:

This variable conditionally defines C<PERL_OTHERLIBDIRS>, which
contains a colon-separated set of paths for the perl binary to
include in @C<INC>.  See also otherlibdirs.

=item C<d_phostname>

From F<d_gethname.U>:

This variable conditionally defines the C<HAS_PHOSTNAME> symbol, which
contains the shell command which, when fed to popen(), may be
used to derive the host name.

=item C<d_pipe>

From F<d_pipe.U>:

This variable conditionally defines the C<HAS_PIPE> symbol, which
indicates to the C program that the pipe() routine is available
to create an inter-process channel.

=item C<d_poll>

From F<d_poll.U>:

This variable conditionally defines the C<HAS_POLL> symbol, which
indicates to the C program that the poll() routine is available
to poll active file descriptors.

=item C<d_portable>

From F<d_portable.U>:

This variable conditionally defines the C<PORTABLE> symbol, which
indicates to the C program that it should not assume that it is
running on the machine it was compiled on.

=item C<d_PRId64>

From F<quadfio.U>:

This variable conditionally defines the PERL_PRId64 symbol, which
indiciates that stdio has a symbol to print 64-bit decimal numbers.

=item C<d_PRIeldbl>

From F<longdblfio.U>:

This variable conditionally defines the PERL_PRIfldbl symbol, which
indiciates that stdio has a symbol to print long doubles.

=item C<d_PRIEUldbl>

From F<longdblfio.U>:

This variable conditionally defines the PERL_PRIfldbl symbol, which
indiciates that stdio has a symbol to print long doubles.
The C<U> in the name is to separate this from d_PRIeldbl so that even
case-blind systems can see the difference.

=item C<d_PRIfldbl>

From F<longdblfio.U>:

This variable conditionally defines the PERL_PRIfldbl symbol, which
indiciates that stdio has a symbol to print long doubles.

=item C<d_PRIFUldbl>

From F<longdblfio.U>:

This variable conditionally defines the PERL_PRIfldbl symbol, which
indiciates that stdio has a symbol to print long doubles.
The C<U> in the name is to separate this from d_PRIfldbl so that even
case-blind systems can see the difference.

=item C<d_PRIgldbl>

From F<longdblfio.U>:

This variable conditionally defines the PERL_PRIfldbl symbol, which
indiciates that stdio has a symbol to print long doubles.

=item C<d_PRIGUldbl>

From F<longdblfio.U>:

This variable conditionally defines the PERL_PRIfldbl symbol, which
indiciates that stdio has a symbol to print long doubles.
The C<U> in the name is to separate this from d_PRIgldbl so that even
case-blind systems can see the difference.

=item C<d_PRIi64>

From F<quadfio.U>:

This variable conditionally defines the PERL_PRIi64 symbol, which
indiciates that stdio has a symbol to print 64-bit decimal numbers.

=item C<d_PRIo64>

From F<quadfio.U>:

This variable conditionally defines the PERL_PRIo64 symbol, which
indiciates that stdio has a symbol to print 64-bit octal numbers.

=item C<d_PRIu64>

From F<quadfio.U>:

This variable conditionally defines the PERL_PRIu64 symbol, which
indiciates that stdio has a symbol to print 64-bit unsigned decimal
numbers.

=item C<d_PRIx64>

From F<quadfio.U>:

This variable conditionally defines the PERL_PRIx64 symbol, which
indiciates that stdio has a symbol to print 64-bit hexadecimal numbers.

=item C<d_PRIXU64>

From F<quadfio.U>:

This variable conditionally defines the PERL_PRIXU64 symbol, which
indiciates that stdio has a symbol to print 64-bit hExADECimAl numbers.
The C<U> in the name is to separate this from d_PRIx64 so that even
case-blind systems can see the difference.

=item C<d_pthread_yield>

From F<d_pthread_y.U>:

This variable conditionally defines the C<HAS_PTHREAD_YIELD>
symbol if the pthread_yield routine is available to yield
the execution of the current thread.

=item C<d_pwage>

From F<i_pwd.U>:

This variable conditionally defines C<PWAGE>, which indicates
that struct passwd contains pw_age.

=item C<d_pwchange>

From F<i_pwd.U>:

This variable conditionally defines C<PWCHANGE>, which indicates
that struct passwd contains pw_change.

=item C<d_pwclass>

From F<i_pwd.U>:

This variable conditionally defines C<PWCLASS>, which indicates
that struct passwd contains pw_class.

=item C<d_pwcomment>

From F<i_pwd.U>:

This variable conditionally defines C<PWCOMMENT>, which indicates
that struct passwd contains pw_comment.

=item C<d_pwexpire>

From F<i_pwd.U>:

This variable conditionally defines C<PWEXPIRE>, which indicates
that struct passwd contains pw_expire.

=item C<d_pwgecos>

From F<i_pwd.U>:

This variable conditionally defines C<PWGECOS>, which indicates
that struct passwd contains pw_gecos.

=item C<d_pwpasswd>

From F<i_pwd.U>:

This variable conditionally defines C<PWPASSWD>, which indicates
that struct passwd contains pw_passwd.

=item C<d_pwquota>

From F<i_pwd.U>:

This variable conditionally defines C<PWQUOTA>, which indicates
that struct passwd contains pw_quota.

=item C<d_qgcvt>

From F<d_qgcvt.U>:

This variable conditionally defines the C<HAS_QGCVT> symbol, which
indicates to the C program that the qgcvt() routine is available.

=item C<d_quad>

From F<quadtype.U>:

This variable, if defined, tells that there's a 64-bit integer type,
quadtype.

=item C<d_readdir>

From F<d_readdir.U>:

This variable conditionally defines C<HAS_READDIR> if readdir() is
available to read directory entries.

=item C<d_readlink>

From F<d_readlink.U>:

This variable conditionally defines the C<HAS_READLINK> symbol, which
indicates to the C program that the readlink() routine is available
to read the value of a symbolic link.

=item C<d_rename>

From F<d_rename.U>:

This variable conditionally defines the C<HAS_RENAME> symbol, which
indicates to the C program that the rename() routine is available
to rename files.

=item C<d_rewinddir>

From F<d_readdir.U>:

This variable conditionally defines C<HAS_REWINDDIR> if rewinddir() is
available.

=item C<d_rmdir>

From F<d_rmdir.U>:

This variable conditionally defines C<HAS_RMDIR> if rmdir() is
available to remove directories.

=item C<d_safebcpy>

From F<d_safebcpy.U>:

This variable conditionally defines the C<HAS_SAFE_BCOPY> symbol if
the bcopy() routine can do overlapping copies.

=item C<d_safemcpy>

From F<d_safemcpy.U>:

This variable conditionally defines the C<HAS_SAFE_MEMCPY> symbol if
the memcpy() routine can do overlapping copies.

=item C<d_sanemcmp>

From F<d_sanemcmp.U>:

This variable conditionally defines the C<HAS_SANE_MEMCMP> symbol if
the memcpy() routine is available and can be used to compare relative
magnitudes of chars with their high bits set.

=item C<d_sbrkproto>

From F<d_sbrkproto.U>:

This variable conditionally defines the C<HAS_SBRK_PROTO> symbol,
which indicates to the C program that the system provides
a prototype for the sbrk() function.  Otherwise, it is
up to the program to supply one.

=item C<d_sched_yield>

From F<d_pthread_y.U>:

This variable conditionally defines the C<HAS_SCHED_YIELD>
symbol if the sched_yield routine is available to yield
the execution of the current thread.

=item C<d_scm_rights>

From F<d_socket.U>:

This variable conditionally defines the C<HAS_SCM_RIGHTS> symbol,
which indicates that the C<SCM_RIGHTS> is available.  #ifdef is
not enough because it may be an enum, glibc has been known to do this.

=item C<d_SCNfldbl>

From F<longdblfio.U>:

This variable conditionally defines the PERL_PRIfldbl symbol, which
indiciates that stdio has a symbol to scan long doubles.

=item C<d_seekdir>

From F<d_readdir.U>:

This variable conditionally defines C<HAS_SEEKDIR> if seekdir() is
available.

=item C<d_select>

From F<d_select.U>:

This variable conditionally defines C<HAS_SELECT> if select() is
available to select active file descriptors. A <sys/time.h>
inclusion may be necessary for the timeout field.

=item C<d_sem>

From F<d_sem.U>:

This variable conditionally defines the C<HAS_SEM> symbol, which
indicates that the entire sem*(2) library is present.

=item C<d_semctl>

From F<d_semctl.U>:

This variable conditionally defines the C<HAS_SEMCTL> symbol, which
indicates to the C program that the semctl() routine is available.

=item C<d_semctl_semid_ds>

From F<d_union_semun.U>:

This variable conditionally defines C<USE_SEMCTL_SEMID_DS>, which
indicates that struct semid_ds * is to be used for semctl C<IPC_STAT>.

=item C<d_semctl_semun>

From F<d_union_semun.U>:

This variable conditionally defines C<USE_SEMCTL_SEMUN>, which
indicates that union semun is to be used for semctl C<IPC_STAT>.

=item C<d_semget>

From F<d_semget.U>:

This variable conditionally defines the C<HAS_SEMGET> symbol, which
indicates to the C program that the semget() routine is available.

=item C<d_semop>

From F<d_semop.U>:

This variable conditionally defines the C<HAS_SEMOP> symbol, which
indicates to the C program that the semop() routine is available.

=item C<d_setegid>

From F<d_setegid.U>:

This variable conditionally defines the C<HAS_SETEGID> symbol, which
indicates to the C program that the setegid() routine is available
to change the effective gid of the current program.

=item C<d_seteuid>

From F<d_seteuid.U>:

This variable conditionally defines the C<HAS_SETEUID> symbol, which
indicates to the C program that the seteuid() routine is available
to change the effective uid of the current program.

=item C<d_setgrent>

From F<d_setgrent.U>:

This variable conditionally defines the C<HAS_SETGRENT> symbol, which
indicates to the C program that the setgrent() routine is available
for initializing sequential access to the group database.

=item C<d_setgrps>

From F<d_setgrps.U>:

This variable conditionally defines the C<HAS_SETGROUPS> symbol, which
indicates to the C program that the setgroups() routine is available
to set the list of process groups.

=item C<d_sethent>

From F<d_sethent.U>:

This variable conditionally defines C<HAS_SETHOSTENT> if sethostent() is
available.

=item C<d_setlinebuf>

From F<d_setlnbuf.U>:

This variable conditionally defines the C<HAS_SETLINEBUF> symbol, which
indicates to the C program that the setlinebuf() routine is available
to change stderr or stdout from block-buffered or unbuffered to a
line-buffered mode.

=item C<d_setlocale>

From F<d_setlocale.U>:

This variable conditionally defines C<HAS_SETLOCALE> if setlocale() is
available to handle locale-specific ctype implementations.

=item C<d_setnent>

From F<d_setnent.U>:

This variable conditionally defines C<HAS_SETNETENT> if setnetent() is
available.

=item C<d_setpent>

From F<d_setpent.U>:

This variable conditionally defines C<HAS_SETPROTOENT> if setprotoent() is
available.

=item C<d_setpgid>

From F<d_setpgid.U>:

This variable conditionally defines the C<HAS_SETPGID> symbol if the
setpgid(pid, gpid) function is available to set process group C<ID>.

=item C<d_setpgrp2>

From F<d_setpgrp2.U>:

This variable conditionally defines the HAS_SETPGRP2 symbol, which
indicates to the C program that the setpgrp2() (as in F<DG/C<UX>>) routine
is available to set the current process group.

=item C<d_setpgrp>

From F<d_setpgrp.U>:

This variable conditionally defines C<HAS_SETPGRP> if setpgrp() is
available to set the current process group.

=item C<d_setprior>

From F<d_setprior.U>:

This variable conditionally defines C<HAS_SETPRIORITY> if setpriority()
is available to set a process's priority.

=item C<d_setproctitle>

From F<d_setproctitle.U>:

This variable conditionally defines the C<HAS_SETPROCTITLE> symbol,
which indicates to the C program that the setproctitle() routine
is available.

=item C<d_setpwent>

From F<d_setpwent.U>:

This variable conditionally defines the C<HAS_SETPWENT> symbol, which
indicates to the C program that the setpwent() routine is available
for initializing sequential access to the passwd database.

=item C<d_setregid>

From F<d_setregid.U>:

This variable conditionally defines C<HAS_SETREGID> if setregid() is
available to change the real and effective gid of the current
process.

=item C<d_setresgid>

From F<d_setregid.U>:

This variable conditionally defines C<HAS_SETRESGID> if setresgid() is
available to change the real, effective and saved gid of the current
process.

=item C<d_setresuid>

From F<d_setreuid.U>:

This variable conditionally defines C<HAS_SETREUID> if setresuid() is
available to change the real, effective and saved uid of the current
process.

=item C<d_setreuid>

From F<d_setreuid.U>:

This variable conditionally defines C<HAS_SETREUID> if setreuid() is
available to change the real and effective uid of the current
process.

=item C<d_setrgid>

From F<d_setrgid.U>:

This variable conditionally defines the C<HAS_SETRGID> symbol, which
indicates to the C program that the setrgid() routine is available
to change the real gid of the current program.

=item C<d_setruid>

From F<d_setruid.U>:

This variable conditionally defines the C<HAS_SETRUID> symbol, which
indicates to the C program that the setruid() routine is available
to change the real uid of the current program.

=item C<d_setsent>

From F<d_setsent.U>:

This variable conditionally defines C<HAS_SETSERVENT> if setservent() is
available.

=item C<d_setsid>

From F<d_setsid.U>:

This variable conditionally defines C<HAS_SETSID> if setsid() is
available to set the process group C<ID>.

=item C<d_setvbuf>

From F<d_setvbuf.U>:

This variable conditionally defines the C<HAS_SETVBUF> symbol, which
indicates to the C program that the setvbuf() routine is available
to change buffering on an open stdio stream.

=item C<d_sfio>

From F<d_sfio.U>:

This variable conditionally defines the C<USE_SFIO> symbol,
and indicates whether sfio is available (and should be used).

=item C<d_shm>

From F<d_shm.U>:

This variable conditionally defines the C<HAS_SHM> symbol, which
indicates that the entire shm*(2) library is present.

=item C<d_shmat>

From F<d_shmat.U>:

This variable conditionally defines the C<HAS_SHMAT> symbol, which
indicates to the C program that the shmat() routine is available.

=item C<d_shmatprototype>

From F<d_shmat.U>:

This variable conditionally defines the C<HAS_SHMAT_PROTOTYPE> 
symbol, which indicates that F<sys/shm.h> has a prototype for
shmat.

=item C<d_shmctl>

From F<d_shmctl.U>:

This variable conditionally defines the C<HAS_SHMCTL> symbol, which
indicates to the C program that the shmctl() routine is available.

=item C<d_shmdt>

From F<d_shmdt.U>:

This variable conditionally defines the C<HAS_SHMDT> symbol, which
indicates to the C program that the shmdt() routine is available.

=item C<d_shmget>

From F<d_shmget.U>:

This variable conditionally defines the C<HAS_SHMGET> symbol, which
indicates to the C program that the shmget() routine is available.

=item C<d_sigaction>

From F<d_sigaction.U>:

This variable conditionally defines the C<HAS_SIGACTION> symbol, which
indicates that the Vr4 sigaction() routine is available.

=item C<d_sigprocmask>

From F<d_sigprocmask.U>:

This variable conditionally defines C<HAS_SIGPROCMASK>
if sigprocmask() is available to examine or change the signal mask
of the calling process.

=item C<d_sigsetjmp>

From F<d_sigsetjmp.U>:

This variable conditionally defines the C<HAS_SIGSETJMP> symbol,
which indicates that the sigsetjmp() routine is available to
call setjmp() and optionally save the process's signal mask.

=item C<d_socket>

From F<d_socket.U>:

This variable conditionally defines C<HAS_SOCKET>, which indicates
that the C<BSD> socket interface is supported.

=item C<d_socklen_t>

From F<d_socklen_t.U>:

This symbol will be defined if the C compiler supports socklen_t.

=item C<d_sockpair>

From F<d_socket.U>:

This variable conditionally defines the C<HAS_SOCKETPAIR> symbol, which
indicates that the C<BSD> socketpair() is supported.

=item C<d_socks5_init>

From F<d_socks5_init.U>:

This variable conditionally defines the HAS_SOCKS5_INIT symbol, which
indicates to the C program that the socks5_init() routine is available.

=item C<d_sqrtl>

From F<d_sqrtl.U>:

This variable conditionally defines the C<HAS_SQRTL> symbol, which
indicates to the C program that the sqrtl() routine is available.

=item C<d_statblks>

From F<d_statblks.U>:

This variable conditionally defines C<USE_STAT_BLOCKS>
if this system has a stat structure declaring
st_blksize and st_blocks.

=item C<d_statfs_f_flags>

From F<d_statfs_f_flags.U>:

This variable conditionally defines the C<HAS_STRUCT_STATFS_F_FLAGS>
symbol, which indicates to struct statfs from has f_flags member.
This kind of struct statfs is coming from F<sys/mount.h> (C<BSD>),
not from F<sys/statfs.h> (C<SYSV>).

=item C<d_statfs_s>

From F<d_statfs_s.U>:

This variable conditionally defines the C<HAS_STRUCT_STATFS> symbol,
which indicates that the struct statfs is supported.

=item C<d_statvfs>

From F<d_statvfs.U>:

This variable conditionally defines the C<HAS_STATVFS> symbol, which
indicates to the C program that the statvfs() routine is available.

=item C<d_stdio_cnt_lval>

From F<d_stdstdio.U>:

This variable conditionally defines C<STDIO_CNT_LVALUE> if the
C<FILE_cnt> macro can be used as an lvalue.

=item C<d_stdio_ptr_lval>

From F<d_stdstdio.U>:

This variable conditionally defines C<STDIO_PTR_LVALUE> if the
C<FILE_ptr> macro can be used as an lvalue.

=item C<d_stdio_ptr_lval_nochange_cnt>

From F<d_stdstdio.U>:

This symbol is defined if using the C<FILE_ptr> macro as an lvalue
to increase the pointer by n leaves File_cnt(fp) unchanged.

=item C<d_stdio_ptr_lval_sets_cnt>

From F<d_stdstdio.U>:

This symbol is defined if using the C<FILE_ptr> macro as an lvalue
to increase the pointer by n has the side effect of decreasing the
value of File_cnt(fp) by n.

=item C<d_stdio_stream_array>

From F<stdio_streams.U>:

This variable tells whether there is an array holding
the stdio streams.

=item C<d_stdiobase>

From F<d_stdstdio.U>:

This variable conditionally defines C<USE_STDIO_BASE> if this system
has a C<FILE> structure declaring a usable _base field (or equivalent)
in F<stdio.h>.

=item C<d_stdstdio>

From F<d_stdstdio.U>:

This variable conditionally defines C<USE_STDIO_PTR> if this system
has a C<FILE> structure declaring usable _ptr and _cnt fields (or
equivalent) in F<stdio.h>.

=item C<d_strchr>

From F<d_strchr.U>:

This variable conditionally defines C<HAS_STRCHR> if strchr() and
strrchr() are available for string searching.

=item C<d_strcoll>

From F<d_strcoll.U>:

This variable conditionally defines C<HAS_STRCOLL> if strcoll() is
available to compare strings using collating information.

=item C<d_strctcpy>

From F<d_strctcpy.U>:

This variable conditionally defines the C<USE_STRUCT_COPY> symbol, which
indicates to the C program that this C compiler knows how to copy
structures.

=item C<d_strerrm>

From F<d_strerror.U>:

This variable holds what Strerrr is defined as to translate an error
code condition into an error message string. It could be C<strerror>
or a more C<complex> macro emulating strrror with sys_errlist[], or the
C<unknown> string when both strerror and sys_errlist are missing.

=item C<d_strerror>

From F<d_strerror.U>:

This variable conditionally defines C<HAS_STRERROR> if strerror() is
available to translate error numbers to strings.

=item C<d_strtod>

From F<d_strtod.U>:

This variable conditionally defines the C<HAS_STRTOD> symbol, which
indicates to the C program that the strtod() routine is available
to provide better numeric string conversion than atof().

=item C<d_strtol>

From F<d_strtol.U>:

This variable conditionally defines the C<HAS_STRTOL> symbol, which
indicates to the C program that the strtol() routine is available
to provide better numeric string conversion than atoi() and friends.

=item C<d_strtold>

From F<d_strtold.U>:

This variable conditionally defines the C<HAS_STRTOLD> symbol, which
indicates to the C program that the strtold() routine is available.

=item C<d_strtoll>

From F<d_strtoll.U>:

This variable conditionally defines the C<HAS_STRTOLL> symbol, which
indicates to the C program that the strtoll() routine is available.

=item C<d_strtoq>

From F<d_strtoq.U>:

This variable conditionally defines the C<HAS_STRTOQ> symbol, which
indicates to the C program that the strtoq() routine is available.

=item C<d_strtoul>

From F<d_strtoul.U>:

This variable conditionally defines the C<HAS_STRTOUL> symbol, which
indicates to the C program that the strtoul() routine is available
to provide conversion of strings to unsigned long.

=item C<d_strtoull>

From F<d_strtoull.U>:

This variable conditionally defines the C<HAS_STRTOULL> symbol, which
indicates to the C program that the strtoull() routine is available.

=item C<d_strtouq>

From F<d_strtouq.U>:

This variable conditionally defines the C<HAS_STRTOUQ> symbol, which
indicates to the C program that the strtouq() routine is available.

=item C<d_strxfrm>

From F<d_strxfrm.U>:

This variable conditionally defines C<HAS_STRXFRM> if strxfrm() is
available to transform strings.

=item C<d_suidsafe>

From F<d_dosuid.U>:

This variable conditionally defines C<SETUID_SCRIPTS_ARE_SECURE_NOW>
if setuid scripts can be secure.  This test looks in F</dev/fd/>.

=item C<d_symlink>

From F<d_symlink.U>:

This variable conditionally defines the C<HAS_SYMLINK> symbol, which
indicates to the C program that the symlink() routine is available
to create symbolic links.

=item C<d_syscall>

From F<d_syscall.U>:

This variable conditionally defines C<HAS_SYSCALL> if syscall() is
available call arbitrary system calls.

=item C<d_sysconf>

From F<d_sysconf.U>:

This variable conditionally defines the C<HAS_SYSCONF> symbol, which
indicates to the C program that the sysconf() routine is available
to determine system related limits and options.

=item C<d_sysernlst>

From F<d_strerror.U>:

This variable conditionally defines C<HAS_SYS_ERRNOLIST> if sys_errnolist[]
is available to translate error numbers to the symbolic name.

=item C<d_syserrlst>

From F<d_strerror.U>:

This variable conditionally defines C<HAS_SYS_ERRLIST> if sys_errlist[] is
available to translate error numbers to strings.

=item C<d_system>

From F<d_system.U>:

This variable conditionally defines C<HAS_SYSTEM> if system() is
available to issue a shell command.

=item C<d_tcgetpgrp>

From F<d_tcgtpgrp.U>:

This variable conditionally defines the C<HAS_TCGETPGRP> symbol, which
indicates to the C program that the tcgetpgrp() routine is available.
to get foreground process group C<ID>.

=item C<d_tcsetpgrp>

From F<d_tcstpgrp.U>:

This variable conditionally defines the C<HAS_TCSETPGRP> symbol, which
indicates to the C program that the tcsetpgrp() routine is available
to set foreground process group C<ID>.

=item C<d_telldir>

From F<d_readdir.U>:

This variable conditionally defines C<HAS_TELLDIR> if telldir() is
available.

=item C<d_telldirproto>

From F<d_telldirproto.U>:

This variable conditionally defines the C<HAS_TELLDIR_PROTO> symbol,
which indicates to the C program that the system provides
a prototype for the telldir() function.  Otherwise, it is
up to the program to supply one.

=item C<d_time>

From F<d_time.U>:

This variable conditionally defines the C<HAS_TIME> symbol, which indicates
that the time() routine exists.  The time() routine is normaly
provided on C<UNIX> systems.

=item C<d_times>

From F<d_times.U>:

This variable conditionally defines the C<HAS_TIMES> symbol, which indicates
that the times() routine exists.  The times() routine is normaly
provided on C<UNIX> systems. You may have to include <sys/times.h>.

=item C<d_truncate>

From F<d_truncate.U>:

This variable conditionally defines C<HAS_TRUNCATE> if truncate() is
available to truncate files.

=item C<d_tzname>

From F<d_tzname.U>:

This variable conditionally defines C<HAS_TZNAME> if tzname[] is
available to access timezone names.

=item C<d_umask>

From F<d_umask.U>:

This variable conditionally defines the C<HAS_UMASK> symbol, which
indicates to the C program that the umask() routine is available.
to set and get the value of the file creation mask.

=item C<d_uname>

From F<d_gethname.U>:

This variable conditionally defines the C<HAS_UNAME> symbol, which
indicates to the C program that the uname() routine may be
used to derive the host name.

=item C<d_union_semun>

From F<d_union_semun.U>:

This variable conditionally defines C<HAS_UNION_SEMUN> if the
union semun is defined by including <sys/sem.h>.

=item C<d_ustat>

From F<d_ustat.U>:

This variable conditionally defines C<HAS_USTAT> if ustat() is
available to query file system statistics by dev_t.

=item C<d_vendorarch>

From F<vendorarch.U>:

This variable conditionally defined C<PERL_VENDORARCH>.

=item C<d_vendorbin>

From F<vendorbin.U>:

This variable conditionally defines C<PERL_VENDORBIN>.

=item C<d_vendorlib>

From F<vendorlib.U>:

This variable conditionally defines C<PERL_VENDORLIB>.

=item C<d_vfork>

From F<d_vfork.U>:

This variable conditionally defines the C<HAS_VFORK> symbol, which
indicates the vfork() routine is available.

=item C<d_void_closedir>

From F<d_closedir.U>:

This variable conditionally defines C<VOID_CLOSEDIR> if closedir()
does not return a value.

=item C<d_voidsig>

From F<d_voidsig.U>:

This variable conditionally defines C<VOIDSIG> if this system
declares "void (*signal(...))()" in F<signal.h>.  The old way was to
declare it as "int (*signal(...))()".

=item C<d_voidtty>

From F<i_sysioctl.U>:

This variable conditionally defines C<USE_IOCNOTTY> to indicate that the
ioctl() call with C<TIOCNOTTY> should be used to void tty association.
Otherwise (on C<USG> probably), it is enough to close the standard file
decriptors and do a setpgrp().

=item C<d_volatile>

From F<d_volatile.U>:

This variable conditionally defines the C<HASVOLATILE> symbol, which
indicates to the C program that this C compiler knows about the
volatile declaration.

=item C<d_vprintf>

From F<d_vprintf.U>:

This variable conditionally defines the C<HAS_VPRINTF> symbol, which
indicates to the C program that the vprintf() routine is available
to printf with a pointer to an argument list.

=item C<d_wait4>

From F<d_wait4.U>:

This variable conditionally defines the HAS_WAIT4 symbol, which
indicates the wait4() routine is available.

=item C<d_waitpid>

From F<d_waitpid.U>:

This variable conditionally defines C<HAS_WAITPID> if waitpid() is
available to wait for child process.

=item C<d_wcstombs>

From F<d_wcstombs.U>:

This variable conditionally defines the C<HAS_WCSTOMBS> symbol, which
indicates to the C program that the wcstombs() routine is available
to convert wide character strings to multibyte strings.

=item C<d_wctomb>

From F<d_wctomb.U>:

This variable conditionally defines the C<HAS_WCTOMB> symbol, which
indicates to the C program that the wctomb() routine is available
to convert a wide character to a multibyte.

=item C<d_xenix>

From F<Guess.U>:

This variable conditionally defines the symbol C<XENIX>, which alerts
the C program that it runs under Xenix.

=item C<date>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the date program.  After Configure runs,
the value is reset to a plain C<date> and is not useful.

=item C<db_hashtype>

From F<i_db.U>:

This variable contains the type of the hash structure element
in the <db.h> header file.  In older versions of C<DB>, it was
int, while in newer ones it is u_int32_t.

=item C<db_prefixtype>

From F<i_db.U>:

This variable contains the type of the prefix structure element
in the <db.h> header file.  In older versions of C<DB>, it was
int, while in newer ones it is size_t.

=item C<defvoidused>

From F<voidflags.U>:

This variable contains the default value of the C<VOIDUSED> symbol (15).

=item C<direntrytype>

From F<i_dirent.U>:

This symbol is set to C<struct direct> or C<struct dirent> depending on
whether dirent is available or not. You should use this pseudo type to
portably declare your directory entries.

=item C<dlext>

From F<dlext.U>:

This variable contains the extension that is to be used for the
dynamically loaded modules that perl generaties.

=item C<dlsrc>

From F<dlsrc.U>:

This variable contains the name of the dynamic loading file that
will be used with the package.

=item C<doublesize>

From F<doublesize.U>:

This variable contains the value of the C<DOUBLESIZE> symbol, which
indicates to the C program how many bytes there are in a double.

=item C<drand01>

From F<randfunc.U>:

Indicates the macro to be used to generate normalized
random numbers.  Uses randfunc, often divided by
(double) (((unsigned long) 1 << randbits)) in order to
normalize the result.
In C programs, the macro C<Drand01> is mapped to drand01.

=item C<dynamic_ext>

From F<Extensions.U>:

This variable holds a list of C<XS> extension files we want to
link dynamically into the package.  It is used by Makefile.

=back

=head2 e

=over

=item C<eagain>

From F<nblock_io.U>:

This variable bears the symbolic errno code set by read() when no
data is present on the file and non-blocking F<I/O> was enabled (otherwise,
read() blocks naturally).

=item C<ebcdic>

From F<ebcdic.U>:

This variable conditionally defines C<EBCDIC> if this
system uses C<EBCDIC> encoding.  Among other things, this
means that the character ranges are not contiguous.
See F<trnl.U>

=item C<echo>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the echo program.  After Configure runs,
the value is reset to a plain C<echo> and is not useful.

=item C<egrep>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the egrep program.  After Configure runs,
the value is reset to a plain C<egrep> and is not useful.

=item C<emacs>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<eunicefix>

From F<Init.U>:

When running under Eunice this variable contains a command which will
convert a shell script to the proper form of text file for it to be
executable by the shell.  On other systems it is a no-op.

=item C<exe_ext>

From F<Unix.U>:

This is an old synonym for _exe.

=item C<expr>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the expr program.  After Configure runs,
the value is reset to a plain C<expr> and is not useful.

=item C<extensions>

From F<Extensions.U>:

This variable holds a list of all extension files (both C<XS> and
non-xs linked into the package.  It is propagated to F<Config.pm>
and is typically used to test whether a particular extesion 
is available.

=back

=head2 f

=over

=item C<fflushall>

From F<fflushall.U>:

This symbol, if defined, tells that to flush
all pending stdio output one must loop through all
the stdio file handles stored in an array and fflush them.
Note that if fflushNULL is defined, fflushall will not
even be probed for and will be left undefined.

=item C<fflushNULL>

From F<fflushall.U>:

This symbol, if defined, tells that fflush(C<NULL>) does flush
all pending stdio output.

=item C<find>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<firstmakefile>

From F<Unix.U>:

This variable defines the first file searched by make.  On unix,
it is makefile (then Makefile).  On case-insensitive systems,
it might be something else.  This is only used to deal with
convoluted make depend tricks.

=item C<flex>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<fpossize>

From F<fpossize.U>:

This variable contains the size of a fpostype in bytes.

=item C<fpostype>

From F<fpostype.U>:

This variable defines Fpos_t to be something like fpos_t, long, 
uint, or whatever type is used to declare file positions in libc.

=item C<freetype>

From F<mallocsrc.U>:

This variable contains the return type of free().  It is usually
void, but occasionally int.

=item C<full_ar>

From F<Loc_ar.U>:

This variable contains the full pathname to C<ar>, whether or
not the user has specified C<portability>.  This is only used
in the F<Makefile.SH>.

=item C<full_csh>

From F<d_csh.U>:

This variable contains the full pathname to C<csh>, whether or
not the user has specified C<portability>.  This is only used
in the compiled C program, and we assume that all systems which
can share this executable will have the same full pathname to
F<csh.>

=item C<full_sed>

From F<Loc_sed.U>:

This variable contains the full pathname to C<sed>, whether or
not the user has specified C<portability>.  This is only used
in the compiled C program, and we assume that all systems which
can share this executable will have the same full pathname to
F<sed.>

=back

=head2 g

=over

=item C<gccosandvers>

From F<gccvers.U>:

If C<GNU> cc (gcc) is used, this variable the operating system and
version used to compile the gcc.  It is set to '' if not gcc,
or if nothing useful can be parsed as the os version.

=item C<gccversion>

From F<gccvers.U>:

If C<GNU> cc (gcc) is used, this variable holds C<1> or C<2> to 
indicate whether the compiler is version 1 or 2.  This is used in
setting some of the default cflags.  It is set to '' if not gcc.

=item C<gidformat>

From F<gidf.U>:

This variable contains the format string used for printing a Gid_t.

=item C<gidsign>

From F<gidsign.U>:

This variable contains the signedness of a gidtype.
1 for unsigned, -1 for signed.

=item C<gidsize>

From F<gidsize.U>:

This variable contains the size of a gidtype in bytes.

=item C<gidtype>

From F<gidtype.U>:

This variable defines Gid_t to be something like gid_t, int,
ushort, or whatever type is used to declare the return type
of getgid().  Typically, it is the type of group ids in the kernel.

=item C<glibpth>

From F<libpth.U>:

This variable holds the general path (space-separated) used to
find libraries.  It may contain directories that do not exist on
this platform, libpth is the cleaned-up version.

=item C<grep>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the grep program.  After Configure runs,
the value is reset to a plain C<grep> and is not useful.

=item C<groupcat>

From F<nis.U>:

This variable contains a command that produces the text of the
F</etc/group> file.  This is normally "cat F</etc/group>", but can be
"ypcat group" when C<NIS> is used.
On some systems, such as os390, there may be no equivalent
command, in which case this variable is unset.

=item C<groupstype>

From F<groupstype.U>:

This variable defines Groups_t to be something like gid_t, int, 
ushort, or whatever type is used for the second argument to
getgroups() and setgroups().  Usually, this is the same as
gidtype (gid_t), but sometimes it isn't.

=item C<gzip>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the gzip program.  After Configure runs,
the value is reset to a plain C<gzip> and is not useful.

=back

=head2 h

=over

=item C<h_fcntl>

From F<h_fcntl.U>:

This is variable gets set in various places to tell i_fcntl that
<fcntl.h> should be included.

=item C<h_sysfile>

From F<h_sysfile.U>:

This is variable gets set in various places to tell i_sys_file that
<sys/file.h> should be included.

=item C<hint>

From F<Oldconfig.U>:

Gives the type of hints used for previous answers. May be one of
C<default>, C<recommended> or C<previous>.

=item C<hostcat>

From F<nis.U>:

This variable contains a command that produces the text of the
F</etc/hosts> file.  This is normally "cat F</etc/hosts>", but can be
"ypcat hosts" when C<NIS> is used.
On some systems, such as os390, there may be no equivalent
command, in which case this variable is unset.

=back

=head2 i

=over

=item C<i16size>

From F<perlxv.U>:

This variable is the size of an I16 in bytes.

=item C<i16type>

From F<perlxv.U>:

This variable contains the C type used for Perl's I16.

=item C<i32size>

From F<perlxv.U>:

This variable is the size of an I32 in bytes.

=item C<i32type>

From F<perlxv.U>:

This variable contains the C type used for Perl's I32.

=item C<i64size>

From F<perlxv.U>:

This variable is the size of an I64 in bytes.

=item C<i64type>

From F<perlxv.U>:

This variable contains the C type used for Perl's I64.

=item C<i8size>

From F<perlxv.U>:

This variable is the size of an I8 in bytes.

=item C<i8type>

From F<perlxv.U>:

This variable contains the C type used for Perl's I8.

=item C<i_arpainet>

From F<i_arpainet.U>:

This variable conditionally defines the C<I_ARPA_INET> symbol,
and indicates whether a C program should include <arpa/inet.h>.

=item C<i_bsdioctl>

From F<i_sysioctl.U>:

This variable conditionally defines the C<I_SYS_BSDIOCTL> symbol, which
indicates to the C program that <sys/bsdioctl.h> exists and should
be included.

=item C<i_db>

From F<i_db.U>:

This variable conditionally defines the C<I_DB> symbol, and indicates
whether a C program may include Berkeley's C<DB> include file <db.h>.

=item C<i_dbm>

From F<i_dbm.U>:

This variable conditionally defines the C<I_DBM> symbol, which
indicates to the C program that <dbm.h> exists and should
be included.

=item C<i_dirent>

From F<i_dirent.U>:

This variable conditionally defines C<I_DIRENT>, which indicates
to the C program that it should include <dirent.h>.

=item C<i_dld>

From F<i_dld.U>:

This variable conditionally defines the C<I_DLD> symbol, which
indicates to the C program that <dld.h> (C<GNU> dynamic loading)
exists and should be included.

=item C<i_dlfcn>

From F<i_dlfcn.U>:

This variable conditionally defines the C<I_DLFCN> symbol, which
indicates to the C program that <dlfcn.h> exists and should
be included.

=item C<i_fcntl>

From F<i_fcntl.U>:

This variable controls the value of C<I_FCNTL> (which tells
the C program to include <fcntl.h>).

=item C<i_float>

From F<i_float.U>:

This variable conditionally defines the C<I_FLOAT> symbol, and indicates
whether a C program may include <float.h> to get symbols like C<DBL_MAX>
or C<DBL_MIN>, F<i.e>. machine dependent floating point values.

=item C<i_gdbm>

From F<i_gdbm.U>:

This variable conditionally defines the C<I_GDBM> symbol, which
indicates to the C program that <gdbm.h> exists and should
be included.

=item C<i_grp>

From F<i_grp.U>:

This variable conditionally defines the C<I_GRP> symbol, and indicates
whether a C program should include <grp.h>.

=item C<i_iconv>

From F<i_iconv.U>:

This variable conditionally defines the C<I_ICONV> symbol, and indicates
whether a C program should include <iconv.h>.

=item C<i_ieeefp>

From F<i_ieeefp.U>:

This variable conditionally defines the C<I_IEEEFP> symbol, and indicates
whether a C program should include <ieeefp.h>.

=item C<i_inttypes>

From F<i_inttypes.U>:

This variable conditionally defines the C<I_INTTYPES> symbol,
and indicates whether a C program should include <inttypes.h>.

=item C<i_libutil>

From F<i_libutil.U>:

This variable conditionally defines the C<I_LIBUTIL> symbol, and indicates
whether a C program should include <libutil.h>.

=item C<i_limits>

From F<i_limits.U>:

This variable conditionally defines the C<I_LIMITS> symbol, and indicates
whether a C program may include <limits.h> to get symbols like C<WORD_BIT>
and friends.

=item C<i_locale>

From F<i_locale.U>:

This variable conditionally defines the C<I_LOCALE> symbol,
and indicates whether a C program should include <locale.h>.

=item C<i_machcthr>

From F<i_machcthr.U>:

This variable conditionally defines the C<I_MACH_CTHREADS> symbol,
and indicates whether a C program should include <mach/cthreads.h>.

=item C<i_malloc>

From F<i_malloc.U>:

This variable conditionally defines the C<I_MALLOC> symbol, and indicates
whether a C program should include <malloc.h>.

=item C<i_math>

From F<i_math.U>:

This variable conditionally defines the C<I_MATH> symbol, and indicates
whether a C program may include <math.h>.

=item C<i_memory>

From F<i_memory.U>:

This variable conditionally defines the C<I_MEMORY> symbol, and indicates
whether a C program should include <memory.h>.

=item C<i_mntent>

From F<i_mntent.U>:

This variable conditionally defines the C<I_MNTENT> symbol, and indicates
whether a C program should include <mntent.h>.

=item C<i_ndbm>

From F<i_ndbm.U>:

This variable conditionally defines the C<I_NDBM> symbol, which
indicates to the C program that <ndbm.h> exists and should
be included.

=item C<i_netdb>

From F<i_netdb.U>:

This variable conditionally defines the C<I_NETDB> symbol, and indicates
whether a C program should include <netdb.h>.

=item C<i_neterrno>

From F<i_neterrno.U>:

This variable conditionally defines the C<I_NET_ERRNO> symbol, which
indicates to the C program that <net/errno.h> exists and should
be included.

=item C<i_netinettcp>

From F<i_netinettcp.U>:

This variable conditionally defines the C<I_NETINET_TCP> symbol,
and indicates whether a C program should include <netinet/tcp.h>.

=item C<i_niin>

From F<i_niin.U>:

This variable conditionally defines C<I_NETINET_IN>, which indicates
to the C program that it should include <netinet/in.h>. Otherwise,
you may try <sys/in.h>.

=item C<i_poll>

From F<i_poll.U>:

This variable conditionally defines the C<I_POLL> symbol, and indicates
whether a C program should include <poll.h>.

=item C<i_prot>

From F<i_prot.U>:

This variable conditionally defines the C<I_PROT> symbol, and indicates
whether a C program should include <prot.h>.

=item C<i_pthread>

From F<i_pthread.U>:

This variable conditionally defines the C<I_PTHREAD> symbol,
and indicates whether a C program should include <pthread.h>.

=item C<i_pwd>

From F<i_pwd.U>:

This variable conditionally defines C<I_PWD>, which indicates
to the C program that it should include <pwd.h>.

=item C<i_rpcsvcdbm>

From F<i_dbm.U>:

This variable conditionally defines the C<I_RPCSVC_DBM> symbol, which
indicates to the C program that <rpcsvc/dbm.h> exists and should
be included.  Some System V systems might need this instead of <dbm.h>.

=item C<i_sfio>

From F<i_sfio.U>:

This variable conditionally defines the C<I_SFIO> symbol,
and indicates whether a C program should include <sfio.h>.

=item C<i_sgtty>

From F<i_termio.U>:

This variable conditionally defines the C<I_SGTTY> symbol, which
indicates to the C program that it should include <sgtty.h> rather
than <termio.h>.

=item C<i_shadow>

From F<i_shadow.U>:

This variable conditionally defines the C<I_SHADOW> symbol, and indicates
whether a C program should include <shadow.h>.

=item C<i_socks>

From F<i_socks.U>:

This variable conditionally defines the C<I_SOCKS> symbol, and indicates
whether a C program should include <socks.h>.

=item C<i_stdarg>

From F<i_varhdr.U>:

This variable conditionally defines the C<I_STDARG> symbol, which
indicates to the C program that <stdarg.h> exists and should
be included.

=item C<i_stddef>

From F<i_stddef.U>:

This variable conditionally defines the C<I_STDDEF> symbol, which
indicates to the C program that <stddef.h> exists and should
be included.

=item C<i_stdlib>

From F<i_stdlib.U>:

This variable conditionally defines the C<I_STDLIB> symbol, which
indicates to the C program that <stdlib.h> exists and should
be included.

=item C<i_string>

From F<i_string.U>:

This variable conditionally defines the C<I_STRING> symbol, which
indicates that <string.h> should be included rather than <strings.h>.

=item C<i_sunmath>

From F<i_sunmath.U>:

This variable conditionally defines the C<I_SUNMATH> symbol, and indicates
whether a C program should include <sunmath.h>.

=item C<i_sysaccess>

From F<i_sysaccess.U>:

This variable conditionally defines the C<I_SYS_ACCESS> symbol,
and indicates whether a C program should include <sys/access.h>.

=item C<i_sysdir>

From F<i_sysdir.U>:

This variable conditionally defines the C<I_SYS_DIR> symbol, and indicates
whether a C program should include <sys/dir.h>.

=item C<i_sysfile>

From F<i_sysfile.U>:

This variable conditionally defines the C<I_SYS_FILE> symbol, and indicates
whether a C program should include <sys/file.h> to get C<R_OK> and friends.

=item C<i_sysfilio>

From F<i_sysioctl.U>:

This variable conditionally defines the C<I_SYS_FILIO> symbol, which
indicates to the C program that <sys/filio.h> exists and should
be included in preference to <sys/ioctl.h>.

=item C<i_sysin>

From F<i_niin.U>:

This variable conditionally defines C<I_SYS_IN>, which indicates
to the C program that it should include <sys/in.h> instead of
<netinet/in.h>.

=item C<i_sysioctl>

From F<i_sysioctl.U>:

This variable conditionally defines the C<I_SYS_IOCTL> symbol, which
indicates to the C program that <sys/ioctl.h> exists and should
be included.

=item C<i_syslog>

From F<i_syslog.U>:

This variable conditionally defines the C<I_SYSLOG> symbol,
and indicates whether a C program should include <syslog.h>.

=item C<i_sysmman>

From F<i_sysmman.U>:

This variable conditionally defines the C<I_SYS_MMAN> symbol, and
indicates whether a C program should include <sys/mman.h>.

=item C<i_sysmode>

From F<i_sysmode.U>:

This variable conditionally defines the C<I_SYSMODE> symbol,
and indicates whether a C program should include <sys/mode.h>.

=item C<i_sysmount>

From F<i_sysmount.U>:

This variable conditionally defines the C<I_SYSMOUNT> symbol,
and indicates whether a C program should include <sys/mount.h>.

=item C<i_sysndir>

From F<i_sysndir.U>:

This variable conditionally defines the C<I_SYS_NDIR> symbol, and indicates
whether a C program should include <sys/ndir.h>.

=item C<i_sysparam>

From F<i_sysparam.U>:

This variable conditionally defines the C<I_SYS_PARAM> symbol, and indicates
whether a C program should include <sys/param.h>.

=item C<i_sysresrc>

From F<i_sysresrc.U>:

This variable conditionally defines the C<I_SYS_RESOURCE> symbol,
and indicates whether a C program should include <sys/resource.h>.

=item C<i_syssecrt>

From F<i_syssecrt.U>:

This variable conditionally defines the C<I_SYS_SECURITY> symbol,
and indicates whether a C program should include <sys/security.h>.

=item C<i_sysselct>

From F<i_sysselct.U>:

This variable conditionally defines C<I_SYS_SELECT>, which indicates
to the C program that it should include <sys/select.h> in order to
get the definition of struct timeval.

=item C<i_syssockio>

From F<i_sysioctl.U>:

This variable conditionally defines C<I_SYS_SOCKIO> to indicate to the
C program that socket ioctl codes may be found in <sys/sockio.h>
instead of <sys/ioctl.h>.

=item C<i_sysstat>

From F<i_sysstat.U>:

This variable conditionally defines the C<I_SYS_STAT> symbol,
and indicates whether a C program should include <sys/stat.h>.

=item C<i_sysstatfs>

From F<i_sysstatfs.U>:

This variable conditionally defines the C<I_SYSSTATFS> symbol,
and indicates whether a C program should include <sys/statfs.h>.

=item C<i_sysstatvfs>

From F<i_sysstatvfs.U>:

This variable conditionally defines the C<I_SYSSTATVFS> symbol,
and indicates whether a C program should include <sys/statvfs.h>.

=item C<i_systime>

From F<i_time.U>:

This variable conditionally defines C<I_SYS_TIME>, which indicates
to the C program that it should include <sys/time.h>.

=item C<i_systimek>

From F<i_time.U>:

This variable conditionally defines C<I_SYS_TIME_KERNEL>, which
indicates to the C program that it should include <sys/time.h>
with C<KERNEL> defined.

=item C<i_systimes>

From F<i_systimes.U>:

This variable conditionally defines the C<I_SYS_TIMES> symbol, and indicates
whether a C program should include <sys/times.h>.

=item C<i_systypes>

From F<i_systypes.U>:

This variable conditionally defines the C<I_SYS_TYPES> symbol,
and indicates whether a C program should include <sys/types.h>.

=item C<i_sysuio>

From F<i_sysuio.U>:

This variable conditionally defines the C<I_SYSUIO> symbol, and indicates
whether a C program should include <sys/uio.h>.

=item C<i_sysun>

From F<i_sysun.U>:

This variable conditionally defines C<I_SYS_UN>, which indicates
to the C program that it should include <sys/un.h> to get C<UNIX>
domain socket definitions.

=item C<i_sysutsname>

From F<i_sysutsname.U>:

This variable conditionally defines the C<I_SYSUTSNAME> symbol,
and indicates whether a C program should include <sys/utsname.h>.

=item C<i_sysvfs>

From F<i_sysvfs.U>:

This variable conditionally defines the C<I_SYSVFS> symbol,
and indicates whether a C program should include <sys/vfs.h>.

=item C<i_syswait>

From F<i_syswait.U>:

This variable conditionally defines C<I_SYS_WAIT>, which indicates
to the C program that it should include <sys/wait.h>.

=item C<i_termio>

From F<i_termio.U>:

This variable conditionally defines the C<I_TERMIO> symbol, which
indicates to the C program that it should include <termio.h> rather
than <sgtty.h>.

=item C<i_termios>

From F<i_termio.U>:

This variable conditionally defines the C<I_TERMIOS> symbol, which
indicates to the C program that the C<POSIX> <termios.h> file is
to be included.

=item C<i_time>

From F<i_time.U>:

This variable conditionally defines C<I_TIME>, which indicates
to the C program that it should include <time.h>.

=item C<i_unistd>

From F<i_unistd.U>:

This variable conditionally defines the C<I_UNISTD> symbol, and indicates
whether a C program should include <unistd.h>.

=item C<i_ustat>

From F<i_ustat.U>:

This variable conditionally defines the C<I_USTAT> symbol, and indicates
whether a C program should include <ustat.h>.

=item C<i_utime>

From F<i_utime.U>:

This variable conditionally defines the C<I_UTIME> symbol, and indicates
whether a C program should include <utime.h>.

=item C<i_values>

From F<i_values.U>:

This variable conditionally defines the C<I_VALUES> symbol, and indicates
whether a C program may include <values.h> to get symbols like C<MAXLONG>
and friends.

=item C<i_varargs>

From F<i_varhdr.U>:

This variable conditionally defines C<I_VARARGS>, which indicates
to the C program that it should include <varargs.h>.

=item C<i_varhdr>

From F<i_varhdr.U>:

Contains the name of the header to be included to get va_dcl definition.
Typically one of F<varargs.h> or F<stdarg.h>.

=item C<i_vfork>

From F<i_vfork.U>:

This variable conditionally defines the C<I_VFORK> symbol, and indicates
whether a C program should include F<vfork.h>.

=item C<ignore_versioned_solibs>

From F<libs.U>:

This variable should be non-empty if non-versioned shared
libraries (F<libfoo.so.x.y>) are to be ignored (because they
cannot be linked against).

=item C<inc_version_list>

From F<inc_version_list.U>:

This variable specifies the list of subdirectories in over
which F<perl.c>:incpush() and F<lib/lib.pm> will automatically
search when adding directories to @C<INC>.  The elements in
the list are separated by spaces.  This is only useful
if you have a perl library directory tree structured like the
default one.  See C<INSTALL> for how this works.  The versioned
site_perl directory was introduced in 5.005, so that is the
lowest possible value.

=item C<inc_version_list_init>

From F<inc_version_list.U>:

This variable holds the same list as inc_version_list, but
each item is enclosed in double quotes and separated by commas, 
suitable for use in the C<PERL_INC_VERSION_LIST> initialization.

=item C<incpath>

From F<usrinc.U>:

This variable must preceed the normal include path to get hte
right one, as in F<$F<incpath/usr/include>> or F<$F<incpath/usr/lib>>.
Value can be "" or F</bsd43> on mips.

=item C<inews>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<installarchlib>

From F<archlib.U>:

This variable is really the same as archlibexp but may differ on
those systems using C<AFS>. For extra portability, only this variable
should be used in makefiles.

=item C<installbin>

From F<bin.U>:

This variable is the same as binexp unless C<AFS> is running in which case
the user is explicitely prompted for it. This variable should always
be used in your makefiles for maximum portability.

=item C<installman1dir>

From F<man1dir.U>:

This variable is really the same as man1direxp, unless you are using
C<AFS> in which case it points to the F<read/write> location whereas
man1direxp only points to the read-only access location. For extra
portability, you should only use this variable within your makefiles.

=item C<installman3dir>

From F<man3dir.U>:

This variable is really the same as man3direxp, unless you are using
C<AFS> in which case it points to the F<read/write> location whereas
man3direxp only points to the read-only access location. For extra
portability, you should only use this variable within your makefiles.

=item C<installprefix>

From F<installprefix.U>:

This variable holds the name of the directory below which 
"make install" will install the package.  For most users, this
is the same as prefix.  However, it is useful for
installing the software into a different (usually temporary)
location after which it can be bundled up and moved somehow
to the final location specified by prefix.

=item C<installprefixexp>

From F<installprefix.U>:

This variable holds the full absolute path of installprefix
with all F<~>-expansion done.

=item C<installprivlib>

From F<privlib.U>:

This variable is really the same as privlibexp but may differ on
those systems using C<AFS>. For extra portability, only this variable
should be used in makefiles.

=item C<installscript>

From F<scriptdir.U>:

This variable is usually the same as scriptdirexp, unless you are on
a system running C<AFS>, in which case they may differ slightly. You
should always use this variable within your makefiles for portability.

=item C<installsitearch>

From F<sitearch.U>:

This variable is really the same as sitearchexp but may differ on
those systems using C<AFS>. For extra portability, only this variable
should be used in makefiles.

=item C<installsitebin>

From F<sitebin.U>:

This variable is usually the same as sitebinexp, unless you are on
a system running C<AFS>, in which case they may differ slightly. You
should always use this variable within your makefiles for portability.

=item C<installsitelib>

From F<sitelib.U>:

This variable is really the same as sitelibexp but may differ on
those systems using C<AFS>. For extra portability, only this variable
should be used in makefiles.

=item C<installstyle>

From F<installstyle.U>:

This variable describes the C<style> of the perl installation.
This is intended to be useful for tools that need to
manipulate entire perl distributions.  Perl itself doesn't use
this to find its libraries -- the library directories are
stored directly in F<Config.pm>.  Currently, there are only two
styles:  C<lib> and F<lib/perl5>.  The default library locations
(e.g. privlib, sitelib) are either $F<prefix/lib> or
$F<prefix/lib/perl5>.  The former is useful if $prefix is a
directory dedicated to perl (e.g. F</opt/perl>), while the latter
is useful if $prefix is shared by many packages, e.g. if
$prefix=F</usr/local>.

	This may later be extended to include other information, so

	be careful with pattern-matching on the results.

	For compatibility with F<perl5.005> and earlier, the default

	setting is based on whether or not $prefix contains the string
C<perl>.

=item C<installusrbinperl>

From F<instubperl.U>:

This variable tells whether Perl should be installed also as
F</usr/bin/perl> in addition to
$F<installbin/perl>

=item C<installvendorarch>

From F<vendorarch.U>:

This variable is really the same as vendorarchexp but may differ on
those systems using C<AFS>. For extra portability, only this variable
should be used in makefiles.

=item C<installvendorbin>

From F<vendorbin.U>:

This variable is really the same as vendorbinexp but may differ on
those systems using C<AFS>. For extra portability, only this variable
should be used in makefiles.

=item C<installvendorlib>

From F<vendorlib.U>:

This variable is really the same as vendorlibexp but may differ on
those systems using C<AFS>. For extra portability, only this variable
should be used in makefiles.

=item C<intsize>

From F<intsize.U>:

This variable contains the value of the C<INTSIZE> symbol, which
indicates to the C program how many bytes there are in an int.

=item C<issymlink>

From F<issymlink.U>:

This variable holds the test command to test for a symbolic link
(if they are supported).  Typical values include C<test -h> and
C<test -L>.

=item C<ivdformat>

From F<perlxvf.U>:

This variable contains the format string used for printing
a Perl C<IV> as a signed decimal integer. 

=item C<ivsize>

From F<perlxv.U>:

This variable is the size of an C<IV> in bytes.

=item C<ivtype>

From F<perlxv.U>:

This variable contains the C type used for Perl's C<IV>.

=back

=head2 k

=over

=item C<known_extensions>

From F<Extensions.U>:

This variable holds a list of all C<XS> extensions included in 
the package.

=item C<ksh>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=back

=head2 l

=over

=item C<ld>

From F<dlsrc.U>:

This variable indicates the program to be used to link
libraries for dynamic loading.  On some systems, it is C<ld>.
On C<ELF> systems, it should be $cc.  Mostly, we'll try to respect
the hint file setting.

=item C<lddlflags>

From F<dlsrc.U>:

This variable contains any special flags that might need to be
passed to $ld to create a shared library suitable for dynamic
loading.  It is up to the makefile to use it.  For hpux, it
should be C<-b>.  For sunos 4.1, it is empty.

=item C<ldflags>

From F<ccflags.U>:

This variable contains any additional C loader flags desired by
the user.  It is up to the Makefile to use this.

=item C<ldflags_uselargefiles>

From F<uselfs.U>:

This variable contains the loader flags needed by large file builds
and added to ldflags by hints files.

=item C<ldlibpthname>

From F<libperl.U>:

This variable holds the name of the shared library
search path, often C<LD_LIBRARY_PATH>.  To get an empty
string, the hints file must set this to C<none>.

=item C<less>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the less program.  After Configure runs,
the value is reset to a plain C<less> and is not useful.

=item C<lib_ext>

From F<Unix.U>:

This is an old synonym for _a.

=item C<libc>

From F<libc.U>:

This variable contains the location of the C library.

=item C<libperl>

From F<libperl.U>:

The perl executable is obtained by linking F<perlmain.c> with
libperl, any static extensions (usually just DynaLoader),
and any other libraries needed on this system.  libperl
is usually F<libperl.a>, but can also be F<libperl.so.xxx> if
the user wishes to build a perl executable with a shared
library.

=item C<libpth>

From F<libpth.U>:

This variable holds the general path (space-separated) used to find
libraries. It is intended to be used by other units.

=item C<libs>

From F<libs.U>:

This variable holds the additional libraries we want to use.
It is up to the Makefile to deal with it.

=item C<libsdirs>

From F<libs.U>:

This variable holds the directory names aka dirnames of the libraries
we found and accepted, duplicates are removed.

=item C<libsfiles>

From F<libs.U>:

This variable holds the filenames aka basenames of the libraries
we found and accepted.

=item C<libsfound>

From F<libs.U>:

This variable holds the full pathnames of the libraries
we found and accepted.

=item C<libspath>

From F<libs.U>:

This variable holds the directory names probed for libraries.

=item C<libswanted>

From F<Myinit.U>:

This variable holds a list of all the libraries we want to
search.  The order is chosen to pick up the c library
ahead of ucb or bsd libraries for SVR4.

=item C<libswanted_uselargefiles>

From F<uselfs.U>:

This variable contains the libraries needed by large file builds
and added to ldflags by hints files.  It is a space separated list
of the library names without the C<lib> prefix or any suffix, just
like F<libswanted.>.

=item C<line>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<lint>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<lkflags>

From F<ccflags.U>:

This variable contains any additional C partial linker flags desired by
the user.  It is up to the Makefile to use this.

=item C<ln>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the ln program.  After Configure runs,
the value is reset to a plain C<ln> and is not useful.

=item C<lns>

From F<lns.U>:

This variable holds the name of the command to make 
symbolic links (if they are supported).  It can be used
in the Makefile. It is either C<ln -s> or C<ln>

=item C<locincpth>

From F<ccflags.U>:

This variable contains a list of additional directories to be
searched by the compiler.  The appropriate C<-I> directives will
be added to ccflags.  This is intended to simplify setting
local directories from the Configure command line.
It's not much, but it parallels the loclibpth stuff in F<libpth.U>.

=item C<loclibpth>

From F<libpth.U>:

This variable holds the paths (space-separated) used to find local
libraries.  It is prepended to libpth, and is intended to be easily
set from the command line.

=item C<longdblsize>

From F<d_longdbl.U>:

This variable contains the value of the C<LONG_DOUBLESIZE> symbol, which
indicates to the C program how many bytes there are in a long double,
if this system supports long doubles.

=item C<longlongsize>

From F<d_longlong.U>:

This variable contains the value of the C<LONGLONGSIZE> symbol, which
indicates to the C program how many bytes there are in a long long,
if this system supports long long.

=item C<longsize>

From F<intsize.U>:

This variable contains the value of the C<LONGSIZE> symbol, which
indicates to the C program how many bytes there are in a long.

=item C<lp>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<lpr>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<ls>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the ls program.  After Configure runs,
the value is reset to a plain C<ls> and is not useful.

=item C<lseeksize>

From F<lseektype.U>:

This variable defines lseektype to be something like off_t, long, 
or whatever type is used to declare lseek offset's type in the
kernel (which also appears to be lseek's return type).

=item C<lseektype>

From F<lseektype.U>:

This variable defines lseektype to be something like off_t, long, 
or whatever type is used to declare lseek offset's type in the
kernel (which also appears to be lseek's return type).

=back

=head2 m

=over

=item C<mail>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<mailx>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<make>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the make program.  After Configure runs,
the value is reset to a plain C<make> and is not useful.

=item C<make_set_make>

From F<make.U>:

Some versions of C<make> set the variable C<MAKE>.  Others do not.
This variable contains the string to be included in F<Makefile.SH>
so that C<MAKE> is set if needed, and not if not needed.
Possible values are:
make_set_make=C<#>		# If your make program handles this for you,
make_set_make=C<MAKE=$make>	# if it doesn't.
I used a comment character so that we can distinguish a
C<set> value (from a previous F<config.sh> or Configure C<-D> option)
from an uncomputed value.

=item C<mallocobj>

From F<mallocsrc.U>:

This variable contains the name of the F<malloc.o> that this package
generates, if that F<malloc.o> is preferred over the system malloc.
Otherwise the value is null.  This variable is intended for generating
Makefiles.  See mallocsrc.

=item C<mallocsrc>

From F<mallocsrc.U>:

This variable contains the name of the F<malloc.c> that comes with
the package, if that F<malloc.c> is preferred over the system malloc.
Otherwise the value is null.  This variable is intended for generating
Makefiles.

=item C<malloctype>

From F<mallocsrc.U>:

This variable contains the kind of ptr returned by malloc and realloc.

=item C<man1dir>

From F<man1dir.U>:

This variable contains the name of the directory in which manual
source pages are to be put.  It is the responsibility of the
F<Makefile.SH> to get the value of this into the proper command.
You must be prepared to do the F<~name> expansion yourself.

=item C<man1direxp>

From F<man1dir.U>:

This variable is the same as the man1dir variable, but is filename
expanded at configuration time, for convenient use in makefiles.

=item C<man1ext>

From F<man1dir.U>:

This variable contains the extension that the manual page should
have: one of C<n>, C<l>, or C<1>.  The Makefile must supply the F<.>.
See man1dir.

=item C<man3dir>

From F<man3dir.U>:

This variable contains the name of the directory in which manual
source pages are to be put.  It is the responsibility of the
F<Makefile.SH> to get the value of this into the proper command.
You must be prepared to do the F<~name> expansion yourself.

=item C<man3direxp>

From F<man3dir.U>:

This variable is the same as the man3dir variable, but is filename
expanded at configuration time, for convenient use in makefiles.

=item C<man3ext>

From F<man3dir.U>:

This variable contains the extension that the manual page should
have: one of C<n>, C<l>, or C<3>.  The Makefile must supply the F<.>.
See man3dir.

=back

=head2 M

=over

=item C<Mcc>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the Mcc program.  After Configure runs,
the value is reset to a plain C<Mcc> and is not useful.

=item C<mips_type>

From F<usrinc.U>:

This variable holds the environment type for the mips system.
Possible values are "BSD 4.3" and "System V".

=item C<mkdir>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the mkdir program.  After Configure runs,
the value is reset to a plain C<mkdir> and is not useful.

=item C<mmaptype>

From F<d_mmap.U>:

This symbol contains the type of pointer returned by mmap()
(and simultaneously the type of the first argument).
It can be C<void *> or C<caddr_t>.

=item C<modetype>

From F<modetype.U>:

This variable defines modetype to be something like mode_t, 
int, unsigned short, or whatever type is used to declare file 
modes for system calls.

=item C<more>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the more program.  After Configure runs,
the value is reset to a plain C<more> and is not useful.

=item C<multiarch>

From F<multiarch.U>:

This variable conditionally defines the C<MULTIARCH> symbol
which signifies the presence of multiplatform files.
This is normally set by hints files.

=item C<mv>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<myarchname>

From F<archname.U>:

This variable holds the architecture name computed by Configure in
a previous run. It is not intended to be perused by any user and
should never be set in a hint file.

=item C<mydomain>

From F<myhostname.U>:

This variable contains the eventual value of the C<MYDOMAIN> symbol,
which is the domain of the host the program is going to run on.
The domain must be appended to myhostname to form a complete host name.
The dot comes with mydomain, and need not be supplied by the program.

=item C<myhostname>

From F<myhostname.U>:

This variable contains the eventual value of the C<MYHOSTNAME> symbol,
which is the name of the host the program is going to run on.
The domain is not kept with hostname, but must be gotten from mydomain.
The dot comes with mydomain, and need not be supplied by the program.

=item C<myuname>

From F<Oldconfig.U>:

The output of C<uname -a> if available, otherwise the hostname. On Xenix,
pseudo variables assignments in the output are stripped, thank you. The
whole thing is then lower-cased.

=back

=head2 n

=over

=item C<n>

From F<n.U>:

This variable contains the C<-n> flag if that is what causes the echo
command to suppress newline.  Otherwise it is null.  Correct usage is
$echo $n "prompt for a question: $c".

=item C<need_va_copy>

From F<need_va_copy.U>:

This symbol, if defined, indicates that the system stores
the variable argument list datatype, va_list, in a format
that cannot be copied by simple assignment, so that some
other means must be used when copying is required.
As such systems vary in their provision (or non-provision)
of copying mechanisms, F<handy.h> defines a platform-
C<independent> macro, Perl_va_copy(src, dst), to do the job.

=item C<netdb_hlen_type>

From F<netdbtype.U>:

This variable holds the type used for the 2nd argument to
gethostbyaddr().  Usually, this is int or size_t or unsigned.
This is only useful if you have gethostbyaddr(), naturally.

=item C<netdb_host_type>

From F<netdbtype.U>:

This variable holds the type used for the 1st argument to
gethostbyaddr().  Usually, this is char * or void *,  possibly
with or without a const prefix.
This is only useful if you have gethostbyaddr(), naturally.

=item C<netdb_name_type>

From F<netdbtype.U>:

This variable holds the type used for the argument to
gethostbyname().  Usually, this is char * or const char *.
This is only useful if you have gethostbyname(), naturally.

=item C<netdb_net_type>

From F<netdbtype.U>:

This variable holds the type used for the 1st argument to
getnetbyaddr().  Usually, this is int or long.
This is only useful if you have getnetbyaddr(), naturally.

=item C<nm>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the nm program.  After Configure runs,
the value is reset to a plain C<nm> and is not useful.

=item C<nm_opt>

From F<usenm.U>:

This variable holds the options that may be necessary for nm.

=item C<nm_so_opt>

From F<usenm.U>:

This variable holds the options that may be necessary for nm
to work on a shared library but that can not be used on an
archive library.  Currently, this is only used by Linux, where
nm --dynamic is *required* to get symbols from an C<ELF> library which
has been stripped, but nm --dynamic is *fatal* on an archive library.
Maybe Linux should just always set usenm=false.

=item C<nonxs_ext>

From F<Extensions.U>:

This variable holds a list of all non-xs extensions included
in the package.  All of them will be built.

=item C<nroff>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the nroff program.  After Configure runs,
the value is reset to a plain C<nroff> and is not useful.

=item C<nveformat>

From F<perlxvf.U>:

This variable contains the format string used for printing
a Perl C<NV> using %e-ish floating point format.

=item C<nvEUformat>

From F<perlxvf.U>:

This variable contains the format string used for printing
a Perl C<NV> using %E-ish floating point format.

=item C<nvfformat>

From F<perlxvf.U>:

This variable confains the format string used for printing
a Perl C<NV> using %f-ish floating point format.

=item C<nvFUformat>

From F<perlxvf.U>:

This variable confains the format string used for printing
a Perl C<NV> using %F-ish floating point format.

=item C<nvgformat>

From F<perlxvf.U>:

This variable contains the format string used for printing
a Perl C<NV> using %g-ish floating point format.

=item C<nvGUformat>

From F<perlxvf.U>:

This variable contains the format string used for printing
a Perl C<NV> using %G-ish floating point format.

=item C<nvsize>

From F<perlxv.U>:

This variable is the size of an C<NV> in bytes.

=item C<nvtype>

From F<perlxv.U>:

This variable contains the C type used for Perl's C<NV>.

=back

=head2 o

=over

=item C<o_nonblock>

From F<nblock_io.U>:

This variable bears the symbol value to be used during open() or fcntl()
to turn on non-blocking F<I/O> for a file descriptor. If you wish to switch
between blocking and non-blocking, you may try ioctl(C<FIOSNBIO>) instead,
but that is only supported by some devices.

=item C<obj_ext>

From F<Unix.U>:

This is an old synonym for _o.

=item C<old_pthread_create_joinable>

From F<d_pthrattrj.U>:

This variable defines the constant to use for creating joinable
(aka undetached) pthreads.  Unused if F<pthread.h> defines
C<PTHREAD_CREATE_JOINABLE>.  If used, possible values are
C<PTHREAD_CREATE_UNDETACHED> and C<__UNDETACHED>.

=item C<optimize>

From F<ccflags.U>:

This variable contains any F<optimizer/debugger> flag that should be used.
It is up to the Makefile to use it.

=item C<orderlib>

From F<orderlib.U>:

This variable is C<true> if the components of libraries must be ordered
(with `lorder $* | tsort`) before placing them in an archive.  Set to
C<false> if ranlib or ar can generate random libraries.

=item C<osname>

From F<Oldconfig.U>:

This variable contains the operating system name (e.g. sunos,
solaris, hpux, F<etc.>).  It can be useful later on for setting
defaults.  Any spaces are replaced with underscores.  It is set
to a null string if we can't figure it out.

=item C<osvers>

From F<Oldconfig.U>:

This variable contains the operating system version (e.g.
4.1.3, 5.2, F<etc.>).  It is primarily used for helping select
an appropriate hints file, but might be useful elsewhere for
setting defaults.  It is set to '' if we can't figure it out.
We try to be flexible about how much of the version number
to keep, e.g. if 4.1.1, 4.1.2, and 4.1.3 are essentially the
same for this package, hints files might just be F<os_4.0> or
F<os_4.1>, F<etc.>, not keeping separate files for each little release.

=item C<otherlibdirs>

From F<otherlibdirs.U>:

This variable contains a colon-separated set of paths for the perl
binary to search for additional library files or modules.
These directories will be tacked to the end of @C<INC>.
Perl will automatically search below each path for version-
and architecture-specific directories.  See inc_version_list
for more details.
A value of C< > means C<none> and is used to preserve this value
for the next run through Configure.

=back

=head2 p

=over

=item C<package>

From F<package.U>:

This variable contains the name of the package being constructed.
It is primarily intended for the use of later Configure units.

=item C<pager>

From F<pager.U>:

This variable contains the name of the preferred pager on the system.
Usual values are (the full pathnames of) more, less, pg, or cat.

=item C<passcat>

From F<nis.U>:

This variable contains a command that produces the text of the
F</etc/passwd> file.  This is normally "cat F</etc/passwd>", but can be
"ypcat passwd" when C<NIS> is used.
On some systems, such as os390, there may be no equivalent
command, in which case this variable is unset.

=item C<patchlevel>

From F<patchlevel.U>:

The patchlevel level of this package.
The value of patchlevel comes from the F<patchlevel.h> file.
In a version number such as 5.6.1, this is the C<6>.
In F<patchlevel.h>, this is referred to as C<PERL_VERSION>.

=item C<path_sep>

From F<Unix.U>:

This is an old synonym for p_ in F<Head.U>, the character
used to separate elements in the command shell search C<PATH>.

=item C<perl5>

From F<perl5.U>:

This variable contains the full path (if any) to a previously
installed F<perl5.005> or later suitable for running the script
to determine inc_version_list.

=item C<perl>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=back

=head2 P

=over

=item C<PERL_REVISION>

From F<Oldsyms.U>:

In a Perl version number such as 5.6.2, this is the 5.
This value is manually set in F<patchlevel.h>

=item C<PERL_SUBVERSION>

From F<Oldsyms.U>:

In a Perl version number such as 5.6.2, this is the 2.
Values greater than 50 represent potentially unstable
development subversions.
This value is manually set in F<patchlevel.h>

=item C<PERL_VERSION>

From F<Oldsyms.U>:

In a Perl version number such as 5.6.2, this is the 6.
This value is manually set in F<patchlevel.h>

=item C<perladmin>

From F<perladmin.U>:

Electronic mail address of the perl5 administrator.

=item C<perllibs>

From F<End.U>:

The list of libraries needed by Perl only (any libraries needed
by extensions only will by dropped, if using dynamic loading).

=item C<perlpath>

From F<perlpath.U>:

This variable contains the eventual value of the C<PERLPATH> symbol,
which contains the name of the perl interpreter to be used in
shell scripts and in the "eval C<exec>" idiom.

=item C<pg>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the pg program.  After Configure runs,
the value is reset to a plain C<pg> and is not useful.

=item C<phostname>

From F<myhostname.U>:

This variable contains the eventual value of the C<PHOSTNAME> symbol,
which is a command that can be fed to popen() to get the host name.
The program should probably not presume that the domain is or isn't
there already.

=item C<pidtype>

From F<pidtype.U>:

This variable defines C<PIDTYPE> to be something like pid_t, int, 
ushort, or whatever type is used to declare process ids in the kernel.

=item C<plibpth>

From F<libpth.U>:

Holds the private path used by Configure to find out the libraries.
Its value is prepend to libpth. This variable takes care of special
machines, like the mips.  Usually, it should be empty.

=item C<pm_apiversion>

From F<xs_apiversion.U>:

This variable contains the version of the oldest perl
compatible with the present perl.  (That is, pure perl modules
written for $pm_apiversion will still work for the current
version).  F<perl.c>:incpush() and F<lib/lib.pm> will automatically
search in $sitelib for older directories across major versions
back to pm_apiversion.  This is only useful if you have a perl
library directory tree structured like the default one.  The
versioned site_perl library was introduced in 5.005, so that's
the default setting for this variable.  It's hard to imagine
it changing before Perl6.  It is included here for symmetry
with xs_apiveprsion -- the searching algorithms will
(presumably) be similar.
See the C<INSTALL> file for how this works.

=item C<pmake>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<pr>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<prefix>

From F<prefix.U>:

This variable holds the name of the directory below which the
user will install the package.  Usually, this is F</usr/local>, and
executables go in F</usr/local/bin>, library stuff in F</usr/local/lib>,
man pages in F</usr/local/man>, etc.  It is only used to set defaults
for things in F<bin.U>, F<mansrc.U>, F<privlib.U>, or F<scriptdir.U>.

=item C<prefixexp>

From F<prefix.U>:

This variable holds the full absolute path of the directory below
which the user will install the package.  Derived from prefix.

=item C<privlib>

From F<privlib.U>:

This variable contains the eventual value of the C<PRIVLIB> symbol,
which is the name of the private library for this package.  It may
have a F<~> on the front. It is up to the makefile to eventually create
this directory while performing installation (with F<~> substitution).

=item C<privlibexp>

From F<privlib.U>:

This variable is the F<~name> expanded version of privlib, so that you
may use it directly in Makefiles or shell scripts.

=item C<prototype>

From F<prototype.U>:

This variable holds the eventual value of C<CAN_PROTOTYPE>, which
indicates the C compiler can handle funciton prototypes.

=item C<ptrsize>

From F<ptrsize.U>:

This variable contains the value of the C<PTRSIZE> symbol, which
indicates to the C program how many bytes there are in a pointer.

=back

=head2 q

=over

=item C<quadkind>

From F<quadtype.U>:

This variable, if defined, encodes the type of a quad:
1 = int, 2 = long, 3 = long long, 4 = int64_t.

=item C<quadtype>

From F<quadtype.U>:

This variable defines Quad_t to be something like long, int, 
long long, int64_t, or whatever type is used for 64-bit integers.

=back

=head2 r

=over

=item C<randbits>

From F<randfunc.U>:

Indicates how many bits are produced by the function used to
generate normalized random numbers.

=item C<randfunc>

From F<randfunc.U>:

Indicates the name of the random number function to use.
Values include drand48, random, and rand. In C programs,
the C<Drand01> macro is defined to generate uniformly distributed
random numbers over the range [0., 1.[ (see drand01 and nrand).

=item C<randseedtype>

From F<randfunc.U>:

Indicates the type of the argument of the seedfunc.

=item C<ranlib>

From F<orderlib.U>:

This variable is set to the pathname of the ranlib program, if it is
needed to generate random libraries.  Set to C<:> if ar can generate
random libraries or if random libraries are not supported

=item C<rd_nodata>

From F<nblock_io.U>:

This variable holds the return code from read() when no data is
present. It should be -1, but some systems return 0 when C<O_NDELAY> is
used, which is a shame because you cannot make the difference between
no data and an F<EOF.>. Sigh!

=item C<revision>

From F<patchlevel.U>:

The value of revision comes from the F<patchlevel.h> file.
In a version number such as 5.6.1, this is the C<5>.
In F<patchlevel.h>, this is referred to as C<PERL_REVISION>.

=item C<rm>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the rm program.  After Configure runs,
the value is reset to a plain C<rm> and is not useful.

=item C<rmail>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<runnm>

From F<usenm.U>:

This variable contains C<true> or C<false> depending whether the
nm extraction should be performed or not, according to the value
of usenm and the flags on the Configure command line.

=back

=head2 s

=over

=item C<sched_yield>

From F<d_pthread_y.U>:

This variable defines the way to yield the execution
of the current thread.

=item C<scriptdir>

From F<scriptdir.U>:

This variable holds the name of the directory in which the user wants
to put publicly scripts for the package in question.  It is either
the same directory as for binaries, or a special one that can be
mounted across different architectures, like F</usr/share>. Programs
must be prepared to deal with F<~name> expansion.

=item C<scriptdirexp>

From F<scriptdir.U>:

This variable is the same as scriptdir, but is filename expanded
at configuration time, for programs not wanting to bother with it.

=item C<sed>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the sed program.  After Configure runs,
the value is reset to a plain C<sed> and is not useful.

=item C<seedfunc>

From F<randfunc.U>:

Indicates the random number generating seed function.
Values include srand48, srandom, and srand.

=item C<selectminbits>

From F<selectminbits.U>:

This variable holds the minimum number of bits operated by select.
That is, if you do select(n, ...), how many bits at least will be
cleared in the masks if some activity is detected.  Usually this
is either n or 32*ceil(F<n/32>), especially many little-endians do
the latter.  This is only useful if you have select(), naturally.

=item C<selecttype>

From F<selecttype.U>:

This variable holds the type used for the 2nd, 3rd, and 4th
arguments to select.  Usually, this is C<fd_set *>, if C<HAS_FD_SET>
is defined, and C<int *> otherwise.  This is only useful if you 
have select(), naturally.

=item C<sendmail>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<sh>

From F<sh.U>:

This variable contains the full pathname of the shell used
on this system to execute Bourne shell scripts.  Usually, this will be
F</bin/sh>, though it's possible that some systems will have F</bin/ksh>,
F</bin/pdksh>, F</bin/ash>, F</bin/bash>, or even something such as
D:F</bin/sh.exe>.
This unit comes before F<Options.U>, so you can't set sh with a C<-D>
option, though you can override this (and startsh)
with C<-O -Dsh=F</bin/whatever> -Dstartsh=whatever>

=item C<shar>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<sharpbang>

From F<spitshell.U>:

This variable contains the string #! if this system supports that
construct.

=item C<shmattype>

From F<d_shmat.U>:

This symbol contains the type of pointer returned by shmat().
It can be C<void *> or C<char *>.

=item C<shortsize>

From F<intsize.U>:

This variable contains the value of the C<SHORTSIZE> symbol which
indicates to the C program how many bytes there are in a short.

=item C<shrpenv>

From F<libperl.U>:

If the user builds a shared F<libperl.so>, then we need to tell the
C<perl> executable where it will be able to find the installed F<libperl.so>. 
One way to do this on some systems is to set the environment variable
C<LD_RUN_PATH> to the directory that will be the final location of the
shared F<libperl.so>.  The makefile can use this with something like
$shrpenv $(C<CC>) -o perl F<perlmain.o> $libperl $libs
Typical values are
shrpenv="env C<LD_RUN_PATH>=$F<archlibexp/C<CORE>>"
or
shrpenv=''
See the main perl F<Makefile.SH> for actual working usage.
Alternatively, we might be able to use a command line option such
as -R $F<archlibexp/C<CORE>> (Solaris, NetBSD) or -Wl,-rpath
$F<archlibexp/C<CORE>> (Linux).

=item C<shsharp>

From F<spitshell.U>:

This variable tells further Configure units whether your sh can
handle # comments.

=item C<sig_count>

From F<sig_name.U>:

This variable holds a number larger than the largest valid
signal number.  This is usually the same as the C<NSIG> macro.

=item C<sig_name>

From F<sig_name.U>:

This variable holds the signal names, space separated. The leading
C<SIG> in signal name is removed.  A C<ZERO> is prepended to the
list.  This is currently not used.

=item C<sig_name_init>

From F<sig_name.U>:

This variable holds the signal names, enclosed in double quotes and
separated by commas, suitable for use in the C<SIG_NAME> definition 
below.  A C<ZERO> is prepended to the list, and the list is 
terminated with a plain 0.  The leading C<SIG> in signal names
is removed. See sig_num.

=item C<sig_num>

From F<sig_name.U>:

This variable holds the signal numbers, space separated. A C<ZERO> is
prepended to the list (corresponding to the fake C<SIGZERO>), and 
the list is terminated with a 0.  Those numbers correspond to 
the value of the signal listed in the same place within the
sig_name list.

=item C<sig_num_init>

From F<sig_name.U>:

This variable holds the signal numbers, enclosed in double quotes and
separated by commas, suitable for use in the C<SIG_NUM> definition 
below.  A C<ZERO> is prepended to the list, and the list is 
terminated with a plain 0.

=item C<sig_size>

From F<sig_name.U>:

This variable contains the number of elements of the sig_name
and sig_num arrays, excluding the final C<NULL> entry.

=item C<signal_t>

From F<d_voidsig.U>:

This variable holds the type of the signal handler (void or int).

=item C<sitearch>

From F<sitearch.U>:

This variable contains the eventual value of the C<SITEARCH> symbol,
which is the name of the private library for this package.  It may
have a F<~> on the front. It is up to the makefile to eventually create
this directory while performing installation (with F<~> substitution).
The standard distribution will put nothing in this directory.
After perl has been installed, users may install their own local
architecture-dependent modules in this directory with
MakeMaker F<Makefile.PL>
or equivalent.  See C<INSTALL> for details.

=item C<sitearchexp>

From F<sitearch.U>:

This variable is the F<~name> expanded version of sitearch, so that you
may use it directly in Makefiles or shell scripts.

=item C<sitebin>

From F<sitebin.U>:

This variable holds the name of the directory in which the user wants
to put add-on publicly executable files for the package in question.  It
is most often a local directory such as F</usr/local/bin>. Programs using
this variable must be prepared to deal with F<~name> substitution.
The standard distribution will put nothing in this directory.
After perl has been installed, users may install their own local
executables in this directory with
MakeMaker F<Makefile.PL>
or equivalent.  See C<INSTALL> for details.

=item C<sitebinexp>

From F<sitebin.U>:

This is the same as the sitebin variable, but is filename expanded at
configuration time, for use in your makefiles.

=item C<sitelib>

From F<sitelib.U>:

This variable contains the eventual value of the C<SITELIB> symbol,
which is the name of the private library for this package.  It may
have a F<~> on the front. It is up to the makefile to eventually create
this directory while performing installation (with F<~> substitution).
The standard distribution will put nothing in this directory.
After perl has been installed, users may install their own local
architecture-independent modules in this directory with
MakeMaker F<Makefile.PL>
or equivalent.  See C<INSTALL> for details.

=item C<sitelib_stem>

From F<sitelib.U>:

This variable is $sitelibexp with any trailing version-specific component
removed.  The elements in inc_version_list (F<inc_version_list.U>) can
be tacked onto this variable to generate a list of directories to search.

=item C<sitelibexp>

From F<sitelib.U>:

This variable is the F<~name> expanded version of sitelib, so that you
may use it directly in Makefiles or shell scripts.

=item C<siteprefix>

From F<siteprefix.U>:

This variable holds the full absolute path of the directory below
which the user will install add-on packages.
See C<INSTALL> for usage and examples.

=item C<siteprefixexp>

From F<siteprefix.U>:

This variable holds the full absolute path of the directory below
which the user will install add-on packages.  Derived from siteprefix.

=item C<sizesize>

From F<sizesize.U>:

This variable contains the size of a sizetype in bytes.

=item C<sizetype>

From F<sizetype.U>:

This variable defines sizetype to be something like size_t, 
unsigned long, or whatever type is used to declare length 
parameters for string functions.

=item C<sleep>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<smail>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<so>

From F<so.U>:

This variable holds the extension used to identify shared libraries
(also known as shared objects) on the system. Usually set to C<so>.

=item C<sockethdr>

From F<d_socket.U>:

This variable has any cpp C<-I> flags needed for socket support.

=item C<socketlib>

From F<d_socket.U>:

This variable has the names of any libraries needed for socket support.

=item C<socksizetype>

From F<socksizetype.U>:

This variable holds the type used for the size argument
for various socket calls like accept.  Usual values include
socklen_t, size_t, and int.

=item C<sort>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the sort program.  After Configure runs,
the value is reset to a plain C<sort> and is not useful.

=item C<spackage>

From F<package.U>:

This variable contains the name of the package being constructed,
with the first letter uppercased, F<i.e>. suitable for starting
sentences.

=item C<spitshell>

From F<spitshell.U>:

This variable contains the command necessary to spit out a runnable
shell on this system.  It is either cat or a grep C<-v> for # comments.

=item C<sPRId64>

From F<quadfio.U>:

This variable, if defined, contains the string used by stdio to
format 64-bit decimal numbers (format C<d>) for output.

=item C<sPRIeldbl>

From F<longdblfio.U>:

This variable, if defined, contains the string used by stdio to
format long doubles (format C<e>) for output.

=item C<sPRIEUldbl>

From F<longdblfio.U>:

This variable, if defined, contains the string used by stdio to
format long doubles (format C<E>) for output.
The C<U> in the name is to separate this from sPRIeldbl so that even
case-blind systems can see the difference.

=item C<sPRIfldbl>

From F<longdblfio.U>:

This variable, if defined, contains the string used by stdio to
format long doubles (format C<f>) for output.

=item C<sPRIFUldbl>

From F<longdblfio.U>:

This variable, if defined, contains the string used by stdio to
format long doubles (format C<F>) for output.
The C<U> in the name is to separate this from sPRIfldbl so that even
case-blind systems can see the difference.

=item C<sPRIgldbl>

From F<longdblfio.U>:

This variable, if defined, contains the string used by stdio to
format long doubles (format C<g>) for output.

=item C<sPRIGUldbl>

From F<longdblfio.U>:

This variable, if defined, contains the string used by stdio to
format long doubles (format C<G>) for output.
The C<U> in the name is to separate this from sPRIgldbl so that even
case-blind systems can see the difference.

=item C<sPRIi64>

From F<quadfio.U>:

This variable, if defined, contains the string used by stdio to
format 64-bit decimal numbers (format C<i>) for output.

=item C<sPRIo64>

From F<quadfio.U>:

This variable, if defined, contains the string used by stdio to
format 64-bit octal numbers (format C<o>) for output.

=item C<sPRIu64>

From F<quadfio.U>:

This variable, if defined, contains the string used by stdio to
format 64-bit unsigned decimal numbers (format C<u>) for output.

=item C<sPRIx64>

From F<quadfio.U>:

This variable, if defined, contains the string used by stdio to
format 64-bit hexadecimal numbers (format C<x>) for output.

=item C<sPRIXU64>

From F<quadfio.U>:

This variable, if defined, contains the string used by stdio to
format 64-bit hExADECimAl numbers (format C<X>) for output.
The C<U> in the name is to separate this from sPRIx64 so that even
case-blind systems can see the difference.

=item C<src>

From F<src.U>:

This variable holds the path to the package source. It is up to
the Makefile to use this variable and set C<VPATH> accordingly to
find the sources remotely.

=item C<sSCNfldbl>

From F<longdblfio.U>:

This variable, if defined, contains the string used by stdio to
format long doubles (format C<f>) for input.

=item C<ssizetype>

From F<ssizetype.U>:

This variable defines ssizetype to be something like ssize_t, 
long or int.  It is used by functions that return a count 
of bytes or an error condition.  It must be a signed type.
We will pick a type such that sizeof(SSize_t) == sizeof(Size_t).

=item C<startperl>

From F<startperl.U>:

This variable contains the string to put on the front of a perl
script to make sure (hopefully) that it runs with perl and not some
shell. Of course, that leading line must be followed by the classical
perl idiom:
eval 'exec perl -S $0 ${1+C<$@>}'
if $running_under_some_shell;
to guarantee perl startup should the shell execute the script. Note
that this magic incatation is not understood by csh.

=item C<startsh>

From F<startsh.U>:

This variable contains the string to put on the front of a shell
script to make sure (hopefully) that it runs with sh and not some
other shell.

=item C<static_ext>

From F<Extensions.U>:

This variable holds a list of C<XS> extension files we want to
link statically into the package.  It is used by Makefile.

=item C<stdchar>

From F<stdchar.U>:

This variable conditionally defines C<STDCHAR> to be the type of char
used in F<stdio.h>.  It has the values "unsigned char" or C<char>.

=item C<stdio_base>

From F<d_stdstdio.U>:

This variable defines how, given a C<FILE> pointer, fp, to access the
_base field (or equivalent) of F<stdio.h>'s C<FILE> structure.  This will
be used to define the macro FILE_base(fp).

=item C<stdio_bufsiz>

From F<d_stdstdio.U>:

This variable defines how, given a C<FILE> pointer, fp, to determine
the number of bytes store in the F<I/O> buffer pointer to by the
_base field (or equivalent) of F<stdio.h>'s C<FILE> structure.  This will
be used to define the macro FILE_bufsiz(fp).

=item C<stdio_cnt>

From F<d_stdstdio.U>:

This variable defines how, given a C<FILE> pointer, fp, to access the
_cnt field (or equivalent) of F<stdio.h>'s C<FILE> structure.  This will
be used to define the macro FILE_cnt(fp).

=item C<stdio_filbuf>

From F<d_stdstdio.U>:

This variable defines how, given a C<FILE> pointer, fp, to tell
stdio to refill it's internal buffers (?).  This will
be used to define the macro FILE_filbuf(fp).

=item C<stdio_ptr>

From F<d_stdstdio.U>:

This variable defines how, given a C<FILE> pointer, fp, to access the
_ptr field (or equivalent) of F<stdio.h>'s C<FILE> structure.  This will
be used to define the macro FILE_ptr(fp).

=item C<stdio_stream_array>

From F<stdio_streams.U>:

This variable tells the name of the array holding the stdio streams.
Usual values include _iob, __iob, and __sF.

=item C<strings>

From F<i_string.U>:

This variable holds the full path of the string header that will be
used. Typically F</usr/include/string.h> or F</usr/include/strings.h>.

=item C<submit>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<subversion>

From F<patchlevel.U>:

The subversion level of this package.
The value of subversion comes from the F<patchlevel.h> file.
In a version number such as 5.6.1, this is the C<1>.
In F<patchlevel.h>, this is referred to as C<PERL_SUBVERSION>.
This is unique to perl.

=item C<sysman>

From F<sysman.U>:

This variable holds the place where the manual is located on this
system. It is not the place where the user wants to put his manual
pages. Rather it is the place where Configure may look to find manual
for unix commands (section 1 of the manual usually). See mansrc.

=back

=head2 t

=over

=item C<tail>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<tar>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<tbl>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<tee>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<test>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the test program.  After Configure runs,
the value is reset to a plain C<test> and is not useful.

=item C<timeincl>

From F<i_time.U>:

This variable holds the full path of the included time header(s).

=item C<timetype>

From F<d_time.U>:

This variable holds the type returned by time(). It can be long,
or time_t on C<BSD> sites (in which case <sys/types.h> should be
included). Anyway, the type Time_t should be used.

=item C<touch>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the touch program.  After Configure runs,
the value is reset to a plain C<touch> and is not useful.

=item C<tr>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the tr program.  After Configure runs,
the value is reset to a plain C<tr> and is not useful.

=item C<trnl>

From F<trnl.U>:

This variable contains the value to be passed to the tr(1)
command to transliterate a newline.  Typical values are
C<\012> and C<\n>.  This is needed for C<EBCDIC> systems where
newline is not necessarily C<\012>.

=item C<troff>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=back

=head2 u

=over

=item C<u16size>

From F<perlxv.U>:

This variable is the size of an U16 in bytes.

=item C<u16type>

From F<perlxv.U>:

This variable contains the C type used for Perl's U16.

=item C<u32size>

From F<perlxv.U>:

This variable is the size of an U32 in bytes.

=item C<u32type>

From F<perlxv.U>:

This variable contains the C type used for Perl's U32.

=item C<u64size>

From F<perlxv.U>:

This variable is the size of an U64 in bytes.

=item C<u64type>

From F<perlxv.U>:

This variable contains the C type used for Perl's U64.

=item C<u8size>

From F<perlxv.U>:

This variable is the size of an U8 in bytes.

=item C<u8type>

From F<perlxv.U>:

This variable contains the C type used for Perl's U8.

=item C<uidformat>

From F<uidf.U>:

This variable contains the format string used for printing a Uid_t.

=item C<uidsign>

From F<uidsign.U>:

This variable contains the signedness of a uidtype.
1 for unsigned, -1 for signed.

=item C<uidsize>

From F<uidsize.U>:

This variable contains the size of a uidtype in bytes.

=item C<uidtype>

From F<uidtype.U>:

This variable defines Uid_t to be something like uid_t, int, 
ushort, or whatever type is used to declare user ids in the kernel.

=item C<uname>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the uname program.  After Configure runs,
the value is reset to a plain C<uname> and is not useful.

=item C<uniq>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the uniq program.  After Configure runs,
the value is reset to a plain C<uniq> and is not useful.

=item C<uquadtype>

From F<quadtype.U>:

This variable defines Uquad_t to be something like unsigned long,
unsigned int, unsigned long long, uint64_t, or whatever type is
used for 64-bit integers.

=item C<use5005threads>

From F<usethreads.U>:

This variable conditionally defines the USE_5005THREADS symbol,
and indicates that Perl should be built to use the 5.005-based
threading implementation.

=item C<use64bitall>

From F<use64bits.U>:

This variable conditionally defines the USE_64_BIT_ALL symbol,
and indicates that 64-bit integer types should be used
when available.  The maximal possible
64-bitness is employed: LP64 or ILP64, meaning that you will
be able to use more than 2 gigabytes of memory.  This mode is
even more binary incompatible than USE_64_BIT_INT. You may not
be able to run the resulting executable in a 32-bit C<CPU> at all or
you may need at least to reboot your C<OS> to 64-bit mode.

=item C<use64bitint>

From F<use64bits.U>:

This variable conditionally defines the USE_64_BIT_INT symbol,
and indicates that 64-bit integer types should be used
when available.  The minimal possible 64-bitness
is employed, just enough to get 64-bit integers into Perl.
This may mean using for example "long longs", while your memory
may still be limited to 2 gigabytes.

=item C<usedl>

From F<dlsrc.U>:

This variable indicates if the system supports dynamic
loading of some sort.  See also dlsrc and dlobj.

=item C<useithreads>

From F<usethreads.U>:

This variable conditionally defines the C<USE_ITHREADS> symbol,
and indicates that Perl should be built to use the interpreter-based
threading implementation.

=item C<uselargefiles>

From F<uselfs.U>:

This variable conditionally defines the C<USE_LARGE_FILES> symbol,
and indicates that large file interfaces should be used when
available.

=item C<uselongdouble>

From F<uselongdbl.U>:

This variable conditionally defines the C<USE_LONG_DOUBLE> symbol,
and indicates that long doubles should be used when available.

=item C<usemorebits>

From F<usemorebits.U>:

This variable conditionally defines the C<USE_MORE_BITS> symbol,
and indicates that explicit 64-bit interfaces and long doubles
should be used when available.

=item C<usemultiplicity>

From F<usemultiplicity.U>:

This variable conditionally defines the C<MULTIPLICITY> symbol,
and indicates that Perl should be built to use multiplicity.

=item C<usemymalloc>

From F<mallocsrc.U>:

This variable contains y if the malloc that comes with this package
is desired over the system's version of malloc.  People often include
special versions of malloc for effiency, but such versions are often
less portable.  See also mallocsrc and mallocobj.
If this is C<y>, then -lmalloc is removed from $libs.

=item C<usenm>

From F<usenm.U>:

This variable contains C<true> or C<false> depending whether the
nm extraction is wanted or not.

=item C<useopcode>

From F<Extensions.U>:

This variable holds either C<true> or C<false> to indicate
whether the Opcode extension should be used.  The sole
use for this currently is to allow an easy mechanism
for users to skip the Opcode extension from the Configure
command line.

=item C<useperlio>

From F<useperlio.U>:

This variable conditionally defines the C<USE_PERLIO> symbol,
and indicates that the PerlIO abstraction should be
used throughout.

=item C<useposix>

From F<Extensions.U>:

This variable holds either C<true> or C<false> to indicate
whether the C<POSIX> extension should be used.  The sole
use for this currently is to allow an easy mechanism
for hints files to indicate that C<POSIX> will not compile
on a particular system.

=item C<usesfio>

From F<d_sfio.U>:

This variable is set to true when the user agrees to use sfio.
It is set to false when sfio is not available or when the user
explicitely requests not to use sfio.  It is here primarily so
that command-line settings can override the auto-detection of
d_sfio without running into a "WHOA THERE".

=item C<useshrplib>

From F<libperl.U>:

This variable is set to C<yes> if the user wishes
to build a shared libperl, and C<no> otherwise.

=item C<usesocks>

From F<usesocks.U>:

This variable conditionally defines the C<USE_SOCKS> symbol,
and indicates that Perl should be built to use C<SOCKS>.

=item C<usethreads>

From F<usethreads.U>:

This variable conditionally defines the C<USE_THREADS> symbol,
and indicates that Perl should be built to use threads.

=item C<usevendorprefix>

From F<vendorprefix.U>:

This variable tells whether the vendorprefix
and consequently other vendor* paths are in use.

=item C<usevfork>

From F<d_vfork.U>:

This variable is set to true when the user accepts to use vfork.
It is set to false when no vfork is available or when the user
explicitely requests not to use vfork.

=item C<usrinc>

From F<usrinc.U>:

This variable holds the path of the include files, which is
usually F</usr/include>. It is mainly used by other Configure units.

=item C<uuname>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<uvoformat>

From F<perlxvf.U>:

This variable contains the format string used for printing
a Perl C<UV> as an unsigned octal integer. 

=item C<uvsize>

From F<perlxv.U>:

This variable is the size of a C<UV> in bytes.

=item C<uvtype>

From F<perlxv.U>:

This variable contains the C type used for Perl's C<UV>.

=item C<uvuformat>

From F<perlxvf.U>:

This variable contains the format string used for printing
a Perl C<UV> as an unsigned decimal integer. 

=item C<uvxformat>

From F<perlxvf.U>:

This variable contains the format string used for printing
a Perl C<UV> as an unsigned hexadecimal integer in lowercase abcdef.

=item C<uvXUformat>

From F<perlxvf.U>:

This variable contains the format string used for printing
a Perl C<UV> as an unsigned hexadecimal integer in uppercase C<ABCDEF>.

=back

=head2 v

=over

=item C<vendorarch>

From F<vendorarch.U>:

This variable contains the value of the C<PERL_VENDORARCH> symbol.
It may have a F<~> on the front. 
The standard distribution will put nothing in this directory.
Vendors who distribute perl may wish to place their own
architecture-dependent modules and extensions in this directory with
MakeMaker F<Makefile.PL> C<INSTALLDIRS>=vendor 
or equivalent.  See C<INSTALL> for details.

=item C<vendorarchexp>

From F<vendorarch.U>:

This variable is the F<~name> expanded version of vendorarch, so that you
may use it directly in Makefiles or shell scripts.

=item C<vendorbin>

From F<vendorbin.U>:

This variable contains the eventual value of the C<VENDORBIN> symbol.
It may have a F<~> on the front.
The standard distribution will put nothing in this directory.
Vendors who distribute perl may wish to place additional
binaries in this directory with
MakeMaker F<Makefile.PL> C<INSTALLDIRS>=vendor 
or equivalent.  See C<INSTALL> for details.

=item C<vendorbinexp>

From F<vendorbin.U>:

This variable is the F<~name> expanded version of vendorbin, so that you
may use it directly in Makefiles or shell scripts.

=item C<vendorlib>

From F<vendorlib.U>:

This variable contains the eventual value of the C<VENDORLIB> symbol,
which is the name of the private library for this package.
The standard distribution will put nothing in this directory.
Vendors who distribute perl may wish to place their own
modules in this directory with
MakeMaker F<Makefile.PL> C<INSTALLDIRS>=vendor 
or equivalent.  See C<INSTALL> for details.

=item C<vendorlib_stem>

From F<vendorlib.U>:

This variable is $vendorlibexp with any trailing version-specific component
removed.  The elements in inc_version_list (F<inc_version_list.U>) can
be tacked onto this variable to generate a list of directories to search.

=item C<vendorlibexp>

From F<vendorlib.U>:

This variable is the F<~name> expanded version of vendorlib, so that you
may use it directly in Makefiles or shell scripts.

=item C<vendorprefix>

From F<vendorprefix.U>:

This variable holds the full absolute path of the directory below
which the vendor will install add-on packages.
See C<INSTALL> for usage and examples.

=item C<vendorprefixexp>

From F<vendorprefix.U>:

This variable holds the full absolute path of the directory below
which the vendor will install add-on packages.  Derived from vendorprefix.

=item C<version>

From F<patchlevel.U>:

The full version number of this package, such as 5.6.1 (or 5_6_1).
This combines revision, patchlevel, and subversion to get the
full version number, including any possible subversions.
This is suitable for use as a directory name, and hence is
filesystem dependent.

=item C<versiononly>

From F<versiononly.U>:

If set, this symbol indicates that only the version-specific
components of a perl installation should be installed.
This may be useful for making a test installation of a new
version without disturbing the existing installation.
Setting versiononly is equivalent to setting installperl's -v option.
In particular, the non-versioned scripts and programs such as
a2p, c2ph, h2xs, pod2*, and perldoc are not installed
(see C<INSTALL> for a more complete list).  Nor are the man
pages installed.
Usually, this is undef.

=item C<vi>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<voidflags>

From F<voidflags.U>:

This variable contains the eventual value of the C<VOIDFLAGS> symbol,
which indicates how much support of the void type is given by this
compiler.  See C<VOIDFLAGS> for more info.

=back

=head2 x

=over

=item C<xlibpth>

From F<libpth.U>:

This variable holds extra path (space-separated) used to find
libraries on this platform, for example C<CPU>-specific libraries
(on multi-C<CPU> platforms) may be listed here.

=item C<xs_apiversion>

From F<xs_apiversion.U>:

This variable contains the version of the oldest perl binary
compatible with the present perl.  F<perl.c>:incpush() and
F<lib/lib.pm> will automatically search in $sitearch for older
directories across major versions back to xs_apiversion.
This is only useful if you have a perl library directory tree
structured like the default one.
See C<INSTALL> for how this works.
The versioned site_perl directory was introduced in 5.005,
so that is the lowest possible value.
Since this can depend on compile time options (such as
bincompat) it is set by Configure.  Other non-default sources
of potential incompatibility, such as multiplicity, threads,
debugging, 64bits, sfio, F<etc.>, are not checked for currently,
though in principle we could go snooping around in old
F<Config.pm> files.

=back

=head2 z

=over

=item C<zcat>

From F<Loc.U>:

This variable is defined but not used by Configure.
The value is a plain '' and is not useful.

=item C<zip>

From F<Loc.U>:

This variable is used internally by Configure to determine the
full pathname (if any) of the zip program.  After Configure runs,
the value is reset to a plain C<zip> and is not useful.


=back

=head1 NOTE

This module contains a good example of how to use tie to implement a
cache and an example of how to make a tied variable readonly to those
outside of it.

=cut

