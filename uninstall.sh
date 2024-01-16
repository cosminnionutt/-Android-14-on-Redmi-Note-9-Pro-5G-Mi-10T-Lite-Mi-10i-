# Copyright (C) 2020-2022 The LiteGapps Open Source Project
#
# write by wahyu6070 (wahyu kurniawan)
#


if [ $TYPEINSTALL = magisk ]; then
    MODEINSTALL="Magisk module (systemless)"
else
    MODEINSTALL="Android System (non systemless)"
fi


packagename=`getp package.name litegapps-prop`
packagesize=`getp package.size litegapps-prop`
packagedate=`getp package.date litegapps-prop`
packageversion=`getp package.version litegapps-prop`
packagecode=`getp package.code litegapps-prop`
packagemodule=`getp package.module litegapps-prop`


print " "
print " LiteGapps Addon"
print " "
print " Name    : $packagename"
print " Version : $packageversion"
print " Size    : $packagesize"
print " Date    : $packagedate"
print " "
print " MODE INSTALL : $MODEINSTALL"
print " "

if [ $TYPEINSTALL = magisk ]; then
    #placeholder
    echo
else
	if [ -f $KOPIMOD/list-debloat ]; then
		for D in $(cat $KOPIMOD/list-debloat); do
			print " • Restoring $D"
			test ! -d $D && mkdir -p $D
			cp -rdf $KOPIMOD/backup${D}/* $D/
		done
	fi
fi

if [ -f $KOPIMOD/list_install_system ]; then
	for i in $(cat $KOPIMOD/list_install_system); do
		
		if [ -f $SYSTEM/$i ]; then
			del $SYSTEM/$i
			rmdir $(dirname $SYSTEM/$i) 2>/dev/null
		fi
	done
fi


if [ -f $KOPIMOD/list_install_vendor ]; then
	for i in $(cat $KOPIMOD/list_install_vendor); do
		if [ -f $VENDOR/$i ]; then
			del $VENDOR/$i
			rmdir $(dirname $VENDOR/$i) 2>/dev/null
		fi
	done
fi

if [ -f $KOPIMOD/list_install_product ]; then
	for i in $(cat $KOPIMOD/list_install_product); do
		
		if [ -f $PRODUCT/$i ]; then
			del $PRODUCT/$i
			rmdir $(dirname $PRODUCT/$i) 2>/dev/null
		fi
	done
fi

if [ -f $KOPIMOD/list_install_system_ext ]; then
	for i in $(cat $KOPIMOD/list_install_system_ext); do
		if [ -f $SYSTEM_EXT/$i ]; then
			del $SYSTEM_EXT/$i
			rmdir $(dirname $SYSTEM_EXT/$i) 2>/dev/null
			
		fi
	done
fi

# restoring product/build.prop
if [ -f $KOPIMOD/build.prop ]; then
	cp -pf $KOPIMOD/build.prop $SYSTEM_DIR/product/build.prop
fi

print "- Uninstalling successfully"
