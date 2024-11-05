#! /system/bin/sh

LOG_TAG="db_property_setting"

logi () {
    /vendor/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}

logi "db_property_setting service start"

FIRST_BOOT_CHECK=$(settings get global first_boot_done)

if [ "$FIRST_BOOT_CHECK" == "1" ]; then
    echo "This is not the first boot."
    logi "This is not the first boot."
else
    logi "This is the first boot"

    # notification bubbles
    settings put secure notification_bubbles 0

    # notification dot icon
    settings put secure  notification_badging 0

    # disable "Show media recommendations"
    settings put secure qs_media_recommend 0
    # disable "Show media on lock screen"
    settings put secure media_controls_lock_screen 0
    # disable "Pin media player"
    settings put secure qs_media_resumption 0

    settings put global first_boot_done 1
    echo "This is the first boot"
fi

