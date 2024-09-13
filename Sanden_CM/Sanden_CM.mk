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

# First lunching is U, api_level is 34
PRODUCT_SHIPPING_API_LEVEL := 34
PRODUCT_DTBO_TEMPLATE := $(LOCAL_PATH)/dt-overlay.in
PRODUCT_SDMMC_DEVICE := fe2b0000.dwmmc

PRODUCT_ASUS_NAME := Sanden_CM 
BOARD_BOOT_HEADER_VERSION ?= 2

include device/rockchip/common/build/rockchip/DynamicPartitions.mk
include device/asus/tinker_board_3/Sanden_CM/BoardConfig.mk
include device/rockchip/common/BoardConfig.mk
$(call inherit-product, device/asus/tinker_board_3/device.mk)
$(call inherit-product, device/rockchip/common/device.mk)
$(call inherit-product, device/asus/common/device.mk)
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

PRODUCT_CHARACTERISTICS := tablet

PRODUCT_NAME := Sanden_CM
PRODUCT_DEVICE := Sanden_CM
PRODUCT_BRAND := toshiba
PRODUCT_MODEL := Sanden_CM
PRODUCT_MANUFACTURER := asus
PRODUCT_AAPT_PREF_CONFIG := hdpi
#
## add Rockchip properties
#
PRODUCT_PROPERTY_OVERRIDES += ro.sf.lcd_density=240
PRODUCT_PROPERTY_OVERRIDES += ro.wifi.sleep.power.down=true
PRODUCT_PROPERTY_OVERRIDES += persist.wifi.sleep.delay.ms=0
PRODUCT_PROPERTY_OVERRIDES += persist.bt.power.down=true
PRODUCT_PROPERTY_OVERRIDES += persist.sys.rotation.efull-1=true
PRODUCT_PROPERTY_OVERRIDES += persist.sys.fflag.override.settings_enable_monitor_phantom_procs=false
PRODUCT_PROPERTY_OVERRIDES += debug.sf.nobootanimation=1

PRODUCT_VENDOR_PROPERTIES += ro.soc.model=RK3568
TARGET_BOOTLOADER_BOARD_NAME := Sanden_CM 

RTW88_FIRMWARES_DIR := vendor/rockchip/common/wifi/firmware/rtw88
RTW88_FIRMWARES ?= $(filter-out .git/% %.mk,$(subst ./,,$(shell cd $(RTW88_FIRMWARES_DIR) && find . -type f)))

PRODUCT_COPY_FILES += \
    $(foreach f,$(RTW88_FIRMWARES),$(RTW88_FIRMWARES_DIR)/$(f):vendor/etc/firmware/rtw88/$(f))


DEVICE_MANIFEST_FILE += device/asus/tinker_board_3/gps/gps_manifest.xml

BOARD_SEPOLICY_DIRS += \
    device/asus/tinker_board_3/sepolicy_vendor/gps

PRODUCT_PACKAGES += \
    android.hardware.gnss@1.0-impl android.hardware.gnss@1.0-service

PRODUCT_COPY_FILES += \
    device/asus/tinker_board_3/gps/gps_cfg.inf:vendor/etc/gps_cfg.inf

PRODUCT_PACKAGES += product_quectel_gps

ifeq ($(strip $(PRODUCT_NAME)), Sanden_CM)
PRODUCT_PACKAGES += \
    libmraa \
    libmraajava

PRODUCT_PACKAGES += \
    termux-app_release_universal \
    termux-boot_release_universal \
    Gboard \
    Magisk.apk
endif

PRODUCT_COPY_FILES += \
     $(LOCAL_PATH)/prebuild/apps/Magisk/install_magisk.sh:$(TARGET_COPY_OUT_VENDOR)/bin/install_magisk.sh \
     $(LOCAL_PATH)/prebuild/apps/Magisk/com.topjohnwu.magisk_preferences.xml:$(TARGET_COPY_OUT_VENDOR)/overlay/com.topjohnwu.magisk_preferences.xml

SF_PRIMARY_DISPLAY_ORIENTATION := 90
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.surface_flinger.primary_display_orientation=ORIENTATION_$(SF_PRIMARY_DISPLAY_ORIENTATION)
