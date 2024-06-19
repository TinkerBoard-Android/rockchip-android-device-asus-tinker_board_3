#! /system/bin/sh

magisk_package_name="com.topjohnwu.magisk"
package_name=`echo $(pm list packages|grep com.topjohnwu.magisk|awk -F ":" '{print $2}')`
echo $package_name
if [ ${#package_name} == "0" ]
then
    pm install /vendor/etc/Magisk.apk
    mkdir -p /data/user_de/0/com.topjohnwu.magisk/shared_prefs/
    cp -arp /vendor/overlay/com.topjohnwu.magisk_preferences.xml /data/user_de/0/com.topjohnwu.magisk/shared_prefs/com.topjohnwu.magisk_preferences.xml 
    chmod 771 /data/user_de/0/com.topjohnwu.magisk/shared_prefs
    chmod 664 /data/user_de/0/com.topjohnwu.magisk/shared_prefs/com.topjohnwu.magisk_preferences.xml
fi
