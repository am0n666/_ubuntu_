#!/data/data/com.termux/files/usr/bin/bash

unset LD_PRELOAD
command="proot"
command+=" --link2symlink"
command+=" -S ubuntu-fs"
command+=" -b /storage"
command+=" -b /dev/"
command+=" -b /proc/"
#uncomment the following line to have access to the home directory of termux
#command+=" -b /data/data/com.termux/files/home"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/bin:/usr/bin:/sbin:/usr/sbin"
command+=" TERM=xterm-256color"
command+=" /bin/bash --login"
export PROOT_NO_SECCOMP=1
com="$@"
if [ -z "$1" ];then
    exec $command
else
    $command -c "$com"
fi
