#
# Copyright 2014 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# First lunching is S, api_level is 31
PRODUCT_SHIPPING_API_LEVEL := 31
PRODUCT_DTBO_TEMPLATE := $(LOCAL_PATH)/dt-overlay.in
PRODUCT_SDMMC_DEVICE := fe2b0000.dwmmc

PRODUCT_ASUS_NAME := Sanden_VM

include device/rockchip/common/build/rockchip/DynamicPartitions.mk
include device/asus/tinker_board_3/Sanden_VM/BoardConfig.mk
include device/rockchip/common/BoardConfig.mk
$(call inherit-product, device/asus/tinker_board_3/device.mk)
$(call inherit-product, device/rockchip/common/device.mk)
$(call inherit-product, device/asus/common/device.mk)
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

PRODUCT_CHARACTERISTICS := tablet

PRODUCT_NAME := Sanden_VM
PRODUCT_DEVICE := Sanden_VM
PRODUCT_BRAND := toshiba
PRODUCT_MODEL := Sanden_VM
PRODUCT_MANUFACTURER := toshiba
PRODUCT_AAPT_PREF_CONFIG := hdpi
#
## add Rockchip properties
#
PRODUCT_PROPERTY_OVERRIDES += ro.sf.lcd_density=240
PRODUCT_PROPERTY_OVERRIDES += ro.wifi.sleep.power.down=true
PRODUCT_PROPERTY_OVERRIDES += persist.wifi.sleep.delay.ms=0
PRODUCT_PROPERTY_OVERRIDES += persist.bt.power.down=true
PRODUCT_PROPERTY_OVERRIDES += persist.sys.fflag.override.settings_enable_monitor_phantom_procs=false

# Append the manifest files for Tinker Board 2 here since this will be defined
# in device/rockchip/common/BoardConfig.mk to use the default one.
DEVICE_MANIFEST_FILE += device/asus/tinker_board_3/manifest.xml

ifeq ($(strip $(PRODUCT_NAME)), Sanden_VM)
PRODUCT_PACKAGES += \
    libmraa \
    libmraajava

PRODUCT_PACKAGES += \
    Termux \
    Gboard \
    Magisk.apk
endif

PRODUCT_COPY_FILES += \
     $(LOCAL_PATH)/prebuild/apps/Magisk/install_magisk.sh:$(TARGET_COPY_OUT_VENDOR)/bin/install_magisk.sh \
     $(LOCAL_PATH)/prebuild/apps/Magisk/com.topjohnwu.magisk_preferences.xml:$(TARGET_COPY_OUT_VENDOR)/overlay/com.topjohnwu.magisk_preferences.xml

