#!/bin/sh
touch $1/tmp/postinst.sh.executed
cp /firstboot.sh $1/tmp/firstboot.sh
chmod 777 $1/tmp/firstboot.sh
ln -s /tmp/firstboot.sh $1/etc/rc3.d/S99zzpostinstall

