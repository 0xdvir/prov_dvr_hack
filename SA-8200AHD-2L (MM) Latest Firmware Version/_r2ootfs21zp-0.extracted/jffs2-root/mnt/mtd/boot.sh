#!/bin/sh

UpdateStatus=/mnt/mtd/Update.dat
PreUpgradeSh=/upgrade/preupgrade.sh

rm /hitoe/gfs3521.tar.gz

rm /var/* -rf
mount -t tmpfs tmpfs /var
mkdir /var/run
mkdir /var/lock
rm /nfsdir -rf
mkdir /nfsdir
mount -t tmpfs tmpfs /nfsdir


# 检查文件是否存在和可读
if [ ! -e "$UpdateStatus" -o ! -r "$UpdateStatus" ] ; then
	#为空，表示刚才在升级时，进行了重启。所以需要在次升级
	echo 1 > ${UpdateStatus}
	chmod 666 ${UpdateStatus}
fi

RESULT=`cat "$UpdateStatus"`
if [ "$RESULT" = "1" ] ; then
	ls ${PreUpgradeSh}
	if [ "$?" != 0 ] ; then 
		echo 0 > ${UpdateStatus}
		sh /mnt/mtd/dep2.sh		
	else
		sh ${PreUpgradeSh}			
	fi		
else
	echo "No need to recovery program from USB"
	sh /mnt/mtd/dep2.sh
fi

