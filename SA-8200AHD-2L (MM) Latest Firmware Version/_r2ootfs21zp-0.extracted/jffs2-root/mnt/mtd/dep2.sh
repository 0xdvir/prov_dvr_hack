#!/bin/sh

echo 2048 > /proc/sys/vm/min_free_kbytes
echo 200 > /proc/sys/vm/vfs_cache_pressure

#解压驱动文件
rm /nfsdir/modules -rf
mkdir -p /nfsdir/modules
cd /nfsdir/modules
cp /mnt/mtd/modules.tar.lzma ./
unlzma modules.tar.lzma
tar -xvf modules.tar
rm modules.tar
#加载驱动文件
cd /nfsdir/modules
sh /nfsdir/modules/load3521 -i

#删除驱动文件
rm /nfsdir/modules -rf

#解压客户端目录
if [ -f /mnt/mtd/WebServer.tar.lzma ]; then
	rm /nfsdir/WebServer -rf
	mkdir /nfsdir/WebServer
	cd /nfsdir/WebServer
	cp /mnt/mtd/WebServer.tar.lzma ./
	unlzma WebServer.tar.lzma
	tar -xvf WebServer.tar
	rm WebServer.tar
	rm /mnt/mtd/WebServer -rf
	ln -s /nfsdir/WebServer  /mnt/mtd/
fi

#解压NVR的库文件
if [ -f /mnt/mtd/plugin.tar.lzma ]; then
	rm /nfsdir/plugin -rf
	mkdir /nfsdir/plugin
	cd /nfsdir/plugin
	cp /mnt/mtd/plugin.tar.lzma ./
	unlzma plugin.tar.lzma
	tar -xvf plugin.tar
	rm plugin.tar
	rm /mnt/mtd/plugin -rf
	ln -s /nfsdir/plugin  /mnt/mtd/
fi


#解压ui目录
if [ -f /mnt/mtd/ui/code_table.dat.lzma ]; then
	rm /nfsdir/front -rf
	mkdir -p /nfsdir/front
	cd /nfsdir/front
	cp /mnt/mtd/ui/code_table.dat.lzma ./
	unlzma code_table.dat.lzma
	ln -s /nfsdir/front/code_table.dat  /mnt/mtd/ui/code_table.dat
fi


#解压客户端语言
if [ -f /mnt/mtd/WebServer/language.tar.gz ]; then
	rm /nfsdir/language -rf
	mkdir /nfsdir/language
	tar -xzvf /mnt/mtd/WebServer/language.tar.gz -C /nfsdir/language
	rm /mnt/mtd/WebSites/language -rf
	ln -s /nfsdir/language  /mnt/mtd/WebServer/
fi

#解压DVR端语言
rm /nfsdir/dvr/language -rf
mkdir -p /nfsdir/dvr/language
cd /nfsdir/dvr/language
cp /mnt/mtd/language.tar.lzma ./
unlzma language.tar.lzma
tar -xvf language.tar
rm language.tar
rm /mnt/mtd/language -rf
ln -s /nfsdir/dvr/language  /mnt/mtd/


rm /nfsdir/lib -rf
rm /mnt/mtd/libhi3521.so
rm /mnt/mtd/libgomp.so.1
rm /mnt/mtd/libApiNetSocket.so
rm /mnt/mtd/libApiServer.so
rm /mnt/mtd/libApiShareLib.so
rm /mnt/mtd/libApiuuid.so
mkdir -p /nfsdir/lib
cd /nfsdir/lib
cp /mnt/mtd/libhi3521.so.lzma ./
cp /mnt/mtd/libgomp.so.1.lzma ./
cp /mnt/mtd/libApiNetSocket.so.lzma  ./
cp /mnt/mtd/libApiServer.so.lzma  ./
cp /mnt/mtd/libApiShareLib.so.lzma  ./
cp /mnt/mtd/libApiuuid.so.lzma  ./
unlzma libhi3521.so.lzma
unlzma libgomp.so.1.lzma
unlzma libApiNetSocket.so.lzma
unlzma libApiServer.so.lzma
unlzma libApiShareLib.so.lzma
unlzma libApiuuid.so.lzma
cd /mnt/mtd
ln -s /nfsdir/lib/libhi3521.so libhi3521.so
ln -s /nfsdir/lib/libgomp.so.1 libgomp.so.1
ln -s /nfsdir/lib/libApiNetSocket.so 	libApiNetSocket.so	
ln -s /nfsdir/lib/libApiServer.so 		libApiServer.so
ln -s /nfsdir/lib/libApiShareLib.so 	libApiShareLib.so
ln -s /nfsdir/lib/libApiuuid.so 		libApiuuid.so



#???????????
mkdir -p /nfsdir/sbin
cd /nfsdir/sbin
cp /mnt/mtd/mkisofs.lzma ./
cp /mnt/mtd/growisofs.lzma ./
unlzma mkisofs.lzma
unlzma growisofs.lzma
ln -s /nfsdir/sbin/mkisofs  /mnt/mtd/mkisofs
ln -s /nfsdir/sbin/growisofs  /mnt/mtd/growisofs

rm /upgrade/ -rf
rm /mnt/mtd/preupgrade.sh
rm /mnt/mtd/productcheck


#telnetd &

export mac=$(cat /etc/init.d/mac.dat)
ifconfig eth0 down
ifconfig eth0 hw ether $mac
ifconfig eth0 up

ifconfig lo up
route add -net 224.0.0.0 netmask 240.0.0.0 dev eth0

mount -t usbfs none /proc/bus/usb

ln -s /mnt/mtd/WebSites/logo /mnt/mtd/WebServer

if [ -f /mnt/mtd/debug.sh ]; then
	cd /mnt/mtd && ./DVRService &
	cd /mnt/mtd && ./debug.sh
	cd /mnt/mtd && ./td3521 &
else
	cd /mnt/mtd && ./XDVRStart.hisi ./td3521 &
fi

