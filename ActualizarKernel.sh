#!/usr/bin/env bash
<<NOTE1 This script updates the linux KERNEL with the specified version.
				The version is pass it as a parameter
NOTE1

version=$1

clear

echo "Changing dir to tempKernel"
cd ~/Documents/tempKernel
echo "current dir is:" `pwd`
echo

echo "Hi, $USER"
echo
echo "Your current kernel is:" `uname -vr`
echo

echo "Already have the kernel files downloaded?"
read already

if [ "$already" != "y" ]; then
  if [ "$version" == "" ]; then
    echo "Please enter a kernel version for update"
  	exit 1
  fi

  echo "Do you really want to update it to $version: Answer y/n"
  read r
  if [ "$r" == "n" ]; then
	  exit 0
  fi

  #          http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.7/linux-headers-4.7.0-040700_4.7.0-040700.201607241632_all.deb
  kernelURL="http://kernel.ubuntu.com/~kernel-ppa/mainline/$version"

  if curl --output /dev/null --silent --head --fail "$kernelURL"; then
  	echo "Ready for update"
	  echo
  else
	  echo "Page doesn't exists"
	  exit 1
  fi 

  linux_headers=`curl -s -L --fail --metalink "$kernelURL"|grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d'|grep linux-headers|grep generic|grep amd64.deb`

  linux_image=`curl -s -L --fail --metalink "$kernelURL"|grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d'|grep linux-image|grep generic|grep amd64.deb`

  linux_deb=`curl -s -L --fail --metalink "$kernelURL"|grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d'|grep linux-headers|grep all.deb`

  echo "Deleting old files"
  rm *

  echo "Downloading files:"
  echo
  echo "$linux_headers"
  echo "$linux_image"
  echo "$linux_deb"
  echo
  
  wget "$kernelURL/$linux_headers"
  wget "$kernelURL/$linux_image"
  wget "$kernelURL/$linux_deb"

  clear
  echo "Files downloaded"
  ls -l
  echo
  echo "Do you want to continue with the instalation?"
  read r2
  if [ "$r2" != 'y' ];then
	echo "You choose exit, bye"
	exit 0
  fi
fi

sudo dpkg -i linux-*.deb
if [ $? -ge 1 ]; then
	exit 1
fi
sudo update-grub
sudo reboot
