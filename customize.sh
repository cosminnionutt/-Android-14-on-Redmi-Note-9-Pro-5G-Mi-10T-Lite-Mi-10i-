# Copyright (C) 2022 The LiteGapps Project
#
# write by wahyu6070 (wahyu kurniawan)
#

SDK=$API
TMP=$KOPIMOD

if [ $TYPEINSTALL = magisk ]; then
    MODEINSTALL="Magisk module (systemless)"
else
    MODEINSTALL="Android System (non systemless)"
fi


set_prop() {
  property="$1"
  value="$2"
  file_location="$3"
  if grep -q "${property}" "${file_location}"; then
    sed -i "s/\(${property}\)=.*/\1=${value}/g" "${file_location}"
  else
    echo "${property}=${value}" >>"${file_location}"
  fi
}


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

#check package 
MOD_SDK=`getp android_sdk $MODPATH/module.prop`
if [ "$MOD_SDK" != all ] && [ ! "$SDK" -eq "$MOD_SDK" ]; then
	print " This package for sdk : $MOD_SDK"
	print " Your sdk version : $SDK"
	print " "
	print " Install package $packagename Failed !!!"
	exit 1
fi

MOD_ARCH=`getp android_arch $MODPATH/module.prop`
if [ "$MOD_ARCH" != all ] && [ "$ARCH" != "$MOD_ARCH" ]; then
	print " ${R}This package for arch : $MOD_ARCH"
	print " ${G}Your arch version : $ARCH"
	print " "
	print "${R} Install package $packagename Failed !!!"
	exit 1
fi

#Debloat
for Y in $SYSTEM $PRODUCT $SYSTEM_EXT; do
     for G in app priv-app; do
        for P in $(cat $MODPATH/list-rm); do
           if [ -d $Y/$G/$P ]; then
             if [ $TYPEINSTALL = magisk ]; then
                if [ $SYSTEM = $Y ]; then
                     print "- Debloating systemless $Y/$G/$P"
                     mkdir -p $MODPATH/system/$G/$P/.replace
                elif [ $SYSTEM_EXT = $Y ]; then
                     print "- Debloating systemless $Y/$G/$P"
                     mkdir -p $MODPATH/system/system_ext/$G/$P/.replace
                elif [ $PRODUCT = $Y ]; then
                    print "- Debloating systemless $Y/$G/$P"
                    mkdir -p $MODPATH/system/product/$G/$P/.replace
                fi
             else
               [ ! -d $TMP/backup${Y}/$G/$P ] && mkdir -p $TMP/backup${Y}/$G/$P
               print "- Backuping to $TMP/backup${Y}/$G/$P"
               cp -rdf $Y/$G/$P/* $TMP/backup${Y}/$G/$P/
               print "- Removing  $Y/$G/$P"
               echo "$Y/$G/$P" >> $TMP/list-debloat
               rm -rf $Y/$G/$P
             fi
           fi
        done
     done
done
