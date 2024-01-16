# The LiteGapps Project
# by wahyu6070
# Module-install.sh
# Running in customize.sh

MODULE_TMP=$MODULE_TMP
SYSDIR=$SYSTEM
TYPEINSTALL=$TYPEINSTALL
DIR_BACKUP=$LITEGAPPS/backup


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



packagename=`getp package.name $MODULE_TMP/litegapps-prop`

cdir $DIR_BACKUP
print "- Installing $packagename"

#check package 
if [ ! "$SDK" -eq "$(getp android_sdk $MODULE_TMP/module.prop)" ]; then
	print " ${R}This package for sdk : $(getp android_sdk $MODULE_TMP/module.prop)"
	print " ${G}Your sdk version : $SDK"
	print " "
	print "${R} Install package $packagename Failed !!!"
	return 1
fi
if [ "$ARCH" != "$(getp android_arch $MODULE_TMP/module.prop)" ]; then
	print " ${R}This package for arch : $(getp android_arch $MODULE_TMP/module.prop)"
	print " ${G}Your arch version : $ARCH"
	print " "
	print "${R} Install package $packagename Failed !!!"
	return 1
fi

# remove file and backup
for Y in $SYSTEM $PRODUCT $SYSTEM_EXT; do
     for G in app priv-app; do
        for P in $(cat $MODULE_TMP/list-rm); do
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
               [ ! -d $DIR_BACKUP${Y}/$G/$P ] && mkdir -p $DIR_BACKUP${Y}/$G/$P
               print "- Backuping to $DIR_BACKUP${Y}/$G/$P"
               cp -rdf $Y/$G/$P/* $DIR_BACKUP${Y}/$G/$P/
               print "- Removing  $Y/$G/$P"
               echo "$Y/$G/$P" >> $DIR_BACKUP/list-debloat
               rm -rf $Y/$G/$P
             fi
           fi
        done
     done
done






#copying files
cp -rdf $MODULE_TMP/system/* $MODPATH/system/

#set permissions
cd $MODULE_TMP
for i in $(find * -type f); do
	chmod 644 "$MODPATH/system/$i"
	chcon -h u:object_r:system_file:s0 "$MODPATH/system/$i"
	chmod 755 "$(dirname $MODPATH/system/$i)"
	chcon -h u:object_r:system_file:s0 "$(dirname $MODPATH/system/$i)"
done
