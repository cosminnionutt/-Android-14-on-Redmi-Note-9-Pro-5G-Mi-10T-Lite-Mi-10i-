# Copyright (C) 2021 The LiteGapps Project
#
# write by wahyu6070 (wahyu kurniawan)
#
#litegapps-uninstall (running in litegappps controller)
#
dirsystem=$SYSTEM_INSTALL
TMP=$tmp

packagename=`getp package.name $MOD_MODULE/litegapps-prop`
packagesize=`getp package.size $MOD_MODULE/litegapps-prop`
packagedate=`getp package.date $MOD_MODULE/litegapps-prop`
packageversion=`getp package.version $MOD_MODULE/litegapps-prop`
packagecode=`getp package.code $MOD_MODULE/litegapps-prop`
packagemodule=`getp package.module $MOD_MODULE/litegapps-prop`


echo " Name    : $packagename"
echo " Version : $packageversion"
echo " Size    : $packagesize"
echo " Date    : $packagedate"
echo " "
echo "- Restoring"
if [ $MODE_INSTALL = MAGISK ]; then
#placeholder
echo
else
	if [ -f $MOD_MODULE/list-debloat ]; then
		for W444 in $(cat $MOD_MODULE/list-debloat); do
		print " • Restoring $(basename $W444)"
		cp -af $MOD_MODULE/backup/system/$W444 $SYSTEM_DIR/$W444
		done
	fi
fi


echo "- Uninstalling"
for un in $(cat $MOD_MODULE/litegapps-list); do
	if [ -f $SYSTEM_INSTALL/$un ]; then
	rm -rf $SYSTEM_INSTALL/$un
	rmdir $(dirname $SYSTEM_INSTALL/$un) 2>/dev/null
	elif [ -d $SYSTEM_INSTALL/$un ]; then
	rm -rf $SYSTEM_INSTALL/$un
	rmdir $(dirname $SYSTEM_INSTALL/$un) 2>/dev/null
	fi
done
echo "${G}- Uninstall $packagename Successfully${W}"
