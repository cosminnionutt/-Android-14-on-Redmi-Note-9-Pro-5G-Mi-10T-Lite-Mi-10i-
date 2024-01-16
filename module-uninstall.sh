# The LiteGapps Project
# by wahyu6070
# Module-uninstall.sh
# Running in uninstall.sh

MODULE_TMP=$MODULE_TMP
SYSDIR=$SYSTEM
TYPEINSTALL=$TYPEINSTALL
DIR_BACKUP=$LITEGAPPS/backup

cdir $DIR_BACKUP
printlog "- Uninstalling $(getp package.name $MODULE_TMP/litegapps-prop)"
if [ -f $DIR_BACKUP/list-debloat ]; then
	for P in $(cat $DIR_BACKUP/list-debloat); do
		[ ! -d $P ] && cdir $P
		printlog "- Restoring $P"
		sedlog "- copying $DIR_BACKUP${P} T0 $DIR_i/"
		cp -rdf $DIR_BACKUP${P}/* $P/
		#set permissions
		chmod 644 $P/$(basename $P).apk
		chcon -h u:object_r:system_file:s0 $P/$(basename $P).apk
		chmod 755 $P
		chcon -h u:object_r:system_file:s0 $P
	done
fi


# restore product/build.prop
if [ -f $DIR_BACKUP/build.prop ]; then
	cp -pf $DIR_BACKUP/build.prop $SYSTEM/build.prop
fi
del $DIR_BACKUP
