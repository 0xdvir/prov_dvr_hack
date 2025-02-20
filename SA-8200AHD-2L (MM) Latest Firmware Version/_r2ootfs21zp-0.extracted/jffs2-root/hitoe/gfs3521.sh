mkdir /dev/gnfsdrv/
tar zxvf /hitoe/gfs3521.tar.gz -C /dev/gnfsdrv/
insmod /dev/gnfsdrv/stmmac.ko
#insmod /dev/gnfsdrv/ohci-hcd.ko
#insmod /dev/gnfsdrv/ehci-hcd.ko
#insmod /dev/gnfsdrv/usb-storage.ko
insmod /dev/gnfsdrv/sunrpc.ko
insmod /dev/gnfsdrv/auth_rpcgss.ko
insmod /dev/gnfsdrv/lockd.ko
insmod /dev/gnfsdrv/nfs_acl.ko
insmod /dev/gnfsdrv/nfs.ko
rm -rf /dev/gnfsdrv/


