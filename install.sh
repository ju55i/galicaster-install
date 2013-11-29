#!/bin/bash

# Install and setup SSH server and firewall
apt-get -y install openssh-server
ufw enable
ufw allow from 130.234.166.192/26 to any app OpenSSH
ufw allow from 130.234.246.128/26 to any app OpenSSH

# Remove screensaver
apt-get -y remove gnome-screensaver

# Install support packages
apt-get -y install \
    python python-gtk2 python-gst0.10 libgtk2.0-0 libgstreamer0.10-0 \
    gstreamer0.10-ffmpeg gstreamer0.10-alsa gstreamer0.10-plugins-bad gstreamer0.10-plugins-bad-multiverse \
    gstreamer0.10-plugins-base gstreamer0.10-plugins-base-apps gstreamer0.10-plugins-good \
    gstreamer0.10-plugins-ugly
apt-get install python-pip python-setuptools
pip install icalendar
apt-get -y install python-pycurl
apt-get -y install v4l-conf v4l-utils guvcview ivtv-utils
apt-get -y install dkms

# Install Epiphan Drivers
#dpkg -i files/vga2pci-3.28.0.7-ubuntu-3.5.0-34-generic-x86_64.deb
#echo "options vga2pci v4l2_err_on_nosignal=0" > /etc/modprobe.d/vga2pci.conf
#echo "softdep vga2pci pre: videobuf-core videodev videobuf-vmalloc post:" >> /etc/modprobe.d/vga2pci.conf
#echo "vga2pci" >> /etc/modules

# Install Datapath Drivers
mkdir /tmp/datapath
tar zxf files/VisionInstall.tgz -C /tmp/datapath
cd /tmp/datapath
./scripts/install.kernel -s
cd -

# Install Blackmagic Drivers
apt-get -y install libqt4-core libqt4-gui libjpeg62 expat
dpkg -i files/desktopvideo-9.7.8-amd64.deb
apt-get -f -y install

# Calibrate touchdisplay
mkdir -p /etc/X11/xorg.conf.d
cp -f files/99-calibration.conf /etc/X11/xorg.conf.d

# Setup autologin and session
cp -f files/tty1.conf /etc/init
cp -f files/galicaster.session /usr/share/gnome-session/sessions
cp -f files/grub /etc/default
update-grub2
# cp -f files/galicaster.desktop /usr/share/xsessions
# cp -f files/lightdm.conf /etc/lightdm

# Install Galicaster
dpkg -i files/galicaster_1.3.1_all.deb
cp -f files/conf.ini /etc/galicaster/conf.ini
cp -f files/jyu.ini /etc/galicaster/profiles/jyu.ini

# Add Galicaster user
adduser --disabled-password --gecos "Galicast" galicast
adduser -a -G video galicast
cp -f files/.xinitrc /home/galicast
cp -f files/.profile /home/galicast

# Make partition and set ownership
echo -e "d\nn\np\n\n\n\nw\n" | fdisk /dev/sdb
mkfs.ext4 /dev/sdb1
mkdir -p /media/space
echo "/dev/sdb1 /media/space ext4 rw 0 0" >> /etc/fstab
mount /media/space
chown -R galicast /media/space

# Upgrade system
#apt-get -y update
#apt-get -y dist-upgrade

