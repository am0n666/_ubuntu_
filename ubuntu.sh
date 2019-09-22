#!/data/data/com.termux/files/usr/bin/bash
me="\e[38;5;196m"
hi="\e[38;5;82m"
no="\e[0m"
folder=ubuntu-fs
cur=$(pwd)
if [ -d "$folder" ]; then
	first=1
	echo "skipping downloading"
fi
while [[ $env != 0 ]]; do
echo -e "\nPlease select the Ubuntu version:

    1. Ubuntu Bionic 18.04
    2. Ubuntu Disco 19.04
    3. Ubuntu Xenial 16.04
"
read env;
case $env in
  1) echo -e "\nDowloading 18.04 Ubuntu Bionic\n"
      ubuntu_version="bionic"
      break;;
  2) echo -e "\nDowloading 19.04 Ubuntu Disco\n"
      ubuntu_version="disco"
      break;;
  3) echo -e "\nDowloading 16.04 Xenial\n"
      ubuntu_version="xenial"
      break;;
  *) echo -e "\nPlease enter the correct option\n";;
esac
done
tarball="ubuntu.tar.gz"
case `dpkg --print-architecture` in
				aarch64)
						archurl="arm64" ;;
				arm)
						archurl="armhf" ;;
                amd64)
                        archurl="amd64" ;;
				i*86)
                        archurl="i386" ;;
                *)
                        echo "unknown architecture"; exit 1 ;;                          esac
if [ "$first" != 1 ];then
	if [ ! -f $tarball ]; then
		curl -o $tarball "https://partner-images.canonical.com/core/${ubuntu_version}/current/ubuntu-${ubuntu_version}-core-cloudimg-${archurl}-root.tar.gz"
	fi
	cur=`pwd`
	mkdir -p "$folder"
	cd "$folder"
	echo -e "decompressing ubuntu image\n"
	proot --link2symlink tar -xf ${cur}/${tarball} --exclude='dev'||:
	echo "fixing nameserver, otherwise it can't connect to the internet"
	echo "nameserver 8.8.8.8" > etc/resolv.conf
	rm ${cur}/$tarball
#	rm sha256
	cd "$cur"
#	fi
fi
mkdir -p binds
bin=start-ubuntu.sh
echo -e "writing launch script\n"
cat > $bin <<- EOM
#!/data/data/com.termux/files/usr/bin/bash
cd \$(dirname \$0)
## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD
command="proot"
command+=" --link2symlink"
command+=" -S $folder"
if [ -n "\$(ls -A binds)" ]; then
    for f in binds/* ;do
      . \$f
    done
fi
command+=" -b /dev"
command+=" -b /proc"
## uncomment the following line to have access to the home directory of termux
#command+=" -b /data/data/com.termux/files/home:/root"
## uncomment the following line to mount /sdcard directly to / 
#command+=" -b /sdcard"
command+=" -b /storage"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\$TERM"
command+=" LANG=C.UTF-8"
command+=" /bin/bash --login"
export PROOT_NO_SECCOMP=1
com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOM
chmod 777 $bin
echo -e "fixing shebang of $bin\n"
termux-fix-shebang $bin
echo -e "making $bin executable\n"
chmod +x $bin
echo "You can now launch Ubuntu with the command <ubuntu>"
