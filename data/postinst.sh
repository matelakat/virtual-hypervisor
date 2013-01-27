#!/bin/sh
touch $1/tmp/postinst.sh.executed
cp /firstboot.sh $1/etc/firstboot.d/95-firstboot
chmod 777 $1/etc/firstboot.d/95-firstboot
