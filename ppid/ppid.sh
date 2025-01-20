#! /vendor/bin/sh

getprop | grep ro.vendor.ppid
if [ $? -eq 1 ]; then
  DATA=$(xxd -s 0x0c -l 20 -p /sys/bus/i2c/devices/2-0050/eeprom)
  ASCII_DATA=$(echo $DATA | xxd -r -p)
  setprop ro.vendor.ppid $ASCII_DATA
fi
