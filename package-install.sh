# Copyright (C) 2020-2022 The LiteGapps Project
# wahyu6070 (wahyu kurniawan)
# package-install.sh (running in litegapps controller)

TMP=$BASE/tmp

MODE_INSTALL=$MODE_INSTALL

# functions
getp(){ grep "^$1" "$2" | head -n1 | cut -d = -f 2; }
set_perm_file(){
	chcon -h u:object_r:system_file:s0 "$1"
	chmod 644 "$1"
	}
set_perm_dir(){
	chcon -hR u:object_r:system_file:s0 "$1"
	chmod 755 "$1"
	}

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
DEBLOAT(){
	local INPUT=$1
	if [ $MODE_INSTALL = MAGISK ]; then
		if [ -d $SYSTEM_DIR/$INPUT ]; then
			if [ -f  $SYSTEM_DIR/$INPUT/$(basename $INPUT).apk ]; then
				test ! -d $SYSTEM_INSTALL/$INPUT && mkdir -p $SYSTEM_INSTALL/$INPUT
				cdir $SYSTEM_INSTALL/$INPUT/.replace
				echo "$INPUT" >> $TMP/list-debloat
			fi
		
		fi
	else
		if [ -d $SYSTEM_DIR/$INPUT ]; then
				test ! -d $TMP/backup/system/$(dirname $INPUT) && mkdir -p $TMP/backup/system/$(dirname $INPUT)
				#print " • Backuping : $(basename $INPUT)"
				cp -af $SYSTEM_DIR/$INPUT $TMP/backup/system/$INPUT
				rm -rf $SYSTEM_DIR/$INPUT
				echo "$INPUT" >> $TMP/list-debloat
		fi
	fi
	}
##
packagename=`getp package.name $TMP/litegapps-prop`
packagesize=`getp package.size $TMP/litegapps-prop`
packagedate=`getp package.date $TMP/litegapps-prop`
packageversion=`getp package.version $TMP/litegapps-prop`
packagecode=`getp package.code $TMP/litegapps-prop`
packagemodule=`getp package.module $TMP/litegapps-prop`

echo " Name    : $packagename"
echo " Version : $packageversion"
echo " Size    : $packagesize"
echo " Date    : $packagedate"
echo " "



#check package 
MOD_SDK=`getp android_sdk $TMP/module.prop`
if [ "$MOD_SDK" != all ] && [ ! "$SDK" -eq $MOD_SDK ]; then
	print " This package for sdk : $MOD_SDK"
	print " Your sdk version : $SDK"
	print " "
	print " Install package $packagename Failed !!!"
	return 1
fi

MOD_ARCH=`getp android_arch $TMP/module.prop`
if [ "$MOD_ARCH" != all ] && [ "$ARCH" != "$MOD_ARCH" ]; then
	print " ${R}This package for arch : $MOD_ARCH"
	print " ${G}Your arch version : $ARCH"
	print " "
	print "${R} Install package $packagename Failed !!!"
	retun 1
fi

LIST_DEBLOAT=$(cat $TMP/list-rm)

sys_app="
app
priv-app
product/app
product/priv-app
system_ext/app
system_ext/priv-app

"
for z in $sys_app; do
	for i in $LIST_DEBLOAT; do
		DEBLOAT $z/$i
	done
done

echo "- Creating list package"
cd $TMP/system
for creating_list in $(find * -type f); do
echo "$creating_list" >> $TMP/litegapps-list
done


echo "- Installing"
for install_sys in $(cat $TMP/litegapps-list); do
	if [ -f $TMP/system/$install_sys ]; then
	[ ! -d $(dirname $SYSTEM_INSTALL/$install_sys) ] && mkdir -p $(dirname $SYSTEM_INSTALL/$install_sys)
	cp -pf $TMP/system/$install_sys $SYSTEM_INSTALL/$install_sys
	fi
done

echo "- set permissions"
if [ $MODE_INSTALL = MAGISK ]; then
	set_perm_dir $SYSTEM_INSTALL
fi
for install_sys2 in $(cat $TMP/litegapps-list); do
	if [ -d $SYSTEM_DIR/$install_sys2 ]; then
		set_perm_dir $SYSTEM_INSTALL/$install_sys2
	elif [ -f $SYSTEM_DIR/$install_sys2 ]; then
		set_perm_file $SYSTEM_INSTALL/$install_sys2
	fi
done
echo "${G}- Installing $packagename successful ${G}"
echo " "
