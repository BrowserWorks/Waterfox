set -x
cd /c/projects/waterfox-win
export PATH=~/.cargo/bin:/c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/2017/Community\ /VC/Auxiliary/Build/:$PATH
./mach bootstrap --application-choice=browser --no-interactive
./mach -v build
./mach -v package
exit 0
