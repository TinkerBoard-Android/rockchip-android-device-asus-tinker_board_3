#! /vendor/bin/sh

LOG_TAG="cpu_gpu_utility.sh"
CONFIG_FILE="/dtoverlay/config.txt"

logi () {
    /vendor/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}

CPU_GOVERNOR=`cat $CONFIG_FILE | grep cpu_governor | awk 'BEGIN {FS="="}; {print $2}'`
GPU_GOVERNOR=`cat $CONFIG_FILE | grep gpu_governor | awk 'BEGIN {FS="="}; {print $2}'`
A55_MIN_FREQ=`cat $CONFIG_FILE | grep a55_minfreq | awk 'BEGIN {FS="="}; {print $2}'`
A55_MAX_FREQ=`cat $CONFIG_FILE | grep a55_maxfreq | awk 'BEGIN {FS="="}; {print $2}'`

logi "CPU_GOVERNOR=$CPU_GOVERNOR, GPU_GOVERNOR=$GPU_GOVERNOR, A55_MIN_FREQ=$A55_MIN_FREQ, A55_MAX_FREQ=$A55_MAX_FREQ"

for governor in $(ls /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)
do
  echo "$CPU_GOVERNOR" > $governor
  sleep 0.05
done
echo "$GPU_GOVERNOR" > /sys/class/devfreq/fde60000.gpu/governor

echo "$A55_MIN_FREQ" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
sleep 0.05
echo "$A55_MAX_FREQ" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
