#!/bin/sh

UpdateStatus=/mnt/mtd/Update.dat
UpdateFileName=/mnt/mtd/UpFile.dat
PreProductCheck=/upgrade/


Update()
{
	#检查是否存在UpdateFileName=/mnt/mtd/UpFile.dat
	ls ${UpdateFileName}
	if [ "$?" != 0 ] ; then			
		echo 0 > ${UpdateStatus}		
		rm -rf ${UpdateFileName}
	else		
		DEVNAME=$(cat ${UpdateFileName})
		echo ${DEVNAME}
		
		#mount 设备到 /mnt/usbdir 目录下
		umount /mnt/usbdir
		rm -rf /mnt/usbdir
		mkdir /mnt/usbdir
		mount -t vfat ${DEVNAME} /mnt/usbdir > /dev/null 
		
		PACKAGEFILEPATH=/mnt/usbdir/upfile.tar
		echo ${PACKAGEFILEPATH}
		
		#检查打包文件是否存在 
		if [ ! -e "${PACKAGEFILEPATH}" ] ; then			
			umount /mnt/usbdir
			rm -rf /mnt/usbdir
			echo "Do not exists *.tar file or exists much than one *.tar files  in USB disk, please check"
			echo 0 > ${UpdateStatus}		
			rm -rf ${UpdateFileName}		
		else
			echo "=================================================================================="
			echo "Begin Upgrate!"
			rm -rf /usr/local/bin/top
			rm -rf /usr/sbin/mkdosfs
			cd /mnt/mtd
			#mkdir /mnt/Bkconfig
			#cp -f /mnt/mtd/config/* /mnt/Bkconfig/
			ls /mnt/mtd | sed "s:^:"/mnt/mtd"/:" | grep -v "UpFile.dat" | grep -v "boot.sh"  > tempfile
			rm -rf `cat tempfile`
			rm -rf `cat tempfile`
			rm -rf `cat tempfile`
			rm tempfile
			tar -xzvf ${PACKAGEFILEPATH} -C /mnt/mtd
			if [ "$?" = "0" ] ; then
				rm -rf /lib/libhi3520.so
				rm -rf /lib/libhi3515.so
				rm -rf /lib/libtsnetdevice.so
				rm -rf /mnt/mtd/productcheck
				rm -rf /upgrade/productcheck
				rm -rf /upgrade/check.dat
				rm -rf /mnt/upgrade/productcheck
				rm -rf /mnt/upgrade/check.dat
				echo 0 > ${UpdateStatus}
				chmod 666 ${UpdateStatus}
				rm -rf ${UpdateFileName}
				#cp -f /mnt/Bkconfig/CruiseConfig.dat /mnt/mtd/config/
				#cp -f /mnt/Bkconfig/PresetConfig.dat /mnt/mtd/config/
				echo "update succ"
			fi
			rm /mnt/usbdir/upfile.tar
			umount /mnt/usbdir
			rm -rf /mnt/usbdir
			rm -rf /nfsdir/run
			echo "$0: Complete Upgrate!"
			echo "=================================================================================="
			sync
			sh /hitoe/rewdg.sh
			sleep 20
			reboot	
		fi
	fi       
	
	
}



##
Update

/mnt/mtd/dep2.sh



