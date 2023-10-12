#
# Copyright (c) 2020 Rockchip Electronics Co., Ltd
#

# Set system properties identifying the chipset
PRODUCT_VENDOR_PROPERTIES += ro.soc.model=RK3566
# GPU Profiling
PRODUCT_VENDOR_PROPERTIES += graphics.gpu.profiler.support=true

PRODUCT_PACKAGES += \
    displayd \
    libion

PRODUCT_PACKAGES += \
    RockchipPinnerService

# Disable partial updates
PRODUCT_PROPERTY_OVERRIDES += \
    debug.hwui.use_partial_updates=false

BOARD_SEPOLICY_DIRS += vendor/rockchip/hardware/interfaces/neuralnetworks/1.0/default/sepolicy
PRODUCT_PACKAGES += \
    public.libraries-rockchip \
    librknn_api_android \
    rknn_server \
    librknnhal_bridge.rockchip \
    rockchip.hardware.neuralnetworks@1.0-impl \
    rockchip.hardware.neuralnetworks@1.0-service

$(call inherit-product-if-exists, vendor/rockchip/common/npu/npu.mk)

TARGET_SYSTEM_PROP += device/asus/tinker_board_3/rk356x.prop
# enable this for support f2fs with data partion
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

# This ensures the needed build tools are available.
# TODO: make non-linux builds happy with external/f2fs-tool; system/extras/f2fs_utils
ifeq ($(HOST_OS),linux)
  TARGET_USERIMAGES_USE_F2FS := true
endif

# hdmi cec
ifneq ($(filter atv box tablet, $(strip $(TARGET_BOARD_PLATFORM_PRODUCT))), )
BOARD_SHOW_HDMI_SETTING := true
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.hdmi.cec.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.hdmi.cec.xml

PRODUCT_PROPERTY_OVERRIDES += ro.hdmi.device_type=4
PRODUCT_PACKAGES += \
	hdmi_cec.$(TARGET_BOARD_PLATFORM)

# HDMI CEC HAL
PRODUCT_PACKAGES += \
    android.hardware.tv.cec@1.0-impl \
    android.hardware.tv.cec@1.0-service
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.recovery.rk30board.rc:recovery/root/init.recovery.rk30board.rc \
    vendor/rockchip/common/bin/$(TARGET_ARCH)/busybox:recovery/root/sbin/busybox

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.rk356x.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.rk356x.rc \
    $(LOCAL_PATH)/wake_lock_filter.xml:system/etc/wake_lock_filter.xml \
    $(LOCAL_PATH)/package_performance.xml:$(TARGET_COPY_OUT_ODM)/etc/package_performance.xml \
    $(TARGET_DEVICE_DIR)/media_profiles_default.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml\

# led
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/led/led.sh:$(TARGET_COPY_OUT_VENDOR)/bin/led.sh

BOARD_SEPOLICY_DIRS += \
    device/asus/tinker_board_3/sepolicy/led

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml

# copy xml files for Vulkan features.
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_0_3.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2019-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level-2019-03-01.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2020-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level-2020-03-01.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2021-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level-2021-03-01.xml

PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.ota.host = 192.168.1.1:8888 \
    ro.vendor.sdkversion = $(CURRENT_SDK_VERSION) \
    vendor.gralloc.disable_afbc = 0

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/public.libraries.txt:vendor/etc/public.libraries.txt

#
# add Rockchip properties here
#
PRODUCT_PROPERTY_OVERRIDES += \
                ro.ril.ecclist=112,911 \
                ro.opengles.version=196610 \
                wifi.interface=wlan0 \
                ro.audio.monitorOrientation=true \
                debug.nfc.fw_download=false \
                debug.nfc.se=false \
                vendor.hwc.compose_policy=1 \
                sys.wallpaper.rgb565=0 \
                sf.power.control=2073600 \
                sys.rkadb.root=0 \
                ro.sf.fakerotation=false \
                ro.tether.denied=false \
                sys.resolution.changed=false \
                ro.default.size=100 \
                ro.product.usbfactory=rockchip_usb \
                wifi.supplicant_scan_interval=15 \
                ro.factory.tool=0 \
                ro.kernel.android.checkjni=0 \
                ro.build.shutdown_timeout=6 \
                persist.enable_task_snapshots=false \
                ro.vendor.frameratelock=true

PRODUCT_COPY_FILES += \
    vendor/rockchip/common/bin/$(TARGET_ARCH)/e2fsck:recovery/root/sbin/e2fsck \
    vendor/rockchip/common/bin/$(TARGET_ARCH)/resize2fs:recovery/root/sbin/resize2fs \
    vendor/rockchip/common/bin/$(TARGET_ARCH)/parted:recovery/root/sbin/parted \
    vendor/rockchip/common/bin/$(TARGET_ARCH)/sgdisk:recovery/root/sbin/sgdisk

ifeq ($(strip $(BOARD_AVB_ENABLE)), false)
ifeq ($(strip $(BOARD_USES_AB_IMAGE)), false)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery.fstab.emmc:recovery/root/system/etc/recovery.fstab.emmc \
    $(LOCAL_PATH)/fstab.rk30board.emmc:$(TARGET_COPY_OUT_RAMDISK)/fstab.rk30board.emmc \
    $(LOCAL_PATH)/fstab.rk30board.emmc:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.rk30board.emmc \
    $(LOCAL_PATH)/recovery.fstab.sd:recovery/root/system/etc/recovery.fstab.sd \
    $(LOCAL_PATH)/fstab.rk30board.sd:$(TARGET_COPY_OUT_RAMDISK)/fstab.rk30board.sd \
    $(LOCAL_PATH)/fstab.rk30board.sd:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.rk30board.sd \
    $(LOCAL_PATH)/fstab.rk30board.no_sdmmc:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.rk30board
endif
endif

PRODUCT_COPY_FILES += \
    device/asus/tinker_board_3/external_camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/external_camera_config.xml

BOARD_SEPOLICY_DIRS += \
    device/asus/tinker_board_3/sepolicy/dtoverlay \
    device/asus/tinker_board_3/sepolicy/AsusDebugger \
    device/asus/tinker_board_3/sepolicy/vendor \
    device/asus/tinker_board_3/sepolicy/media \
    device/asus/tinker_board_3/sepolicy/system

# Include thermal HAL module
BOARD_ROCKCHIP_THERMAL := true
$(call inherit-product, device/rockchip/common/modules/thermal.mk)

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/cpu_gpu_utility.sh:$(TARGET_COPY_OUT_VENDOR)/bin/cpu_gpu_utility.sh

BOARD_SEPOLICY_DIRS += \
    device/asus/tinker_board_3/sepolicy/gps

PRODUCT_PACKAGES += \
    android.hardware.gnss@1.0-impl android.hardware.gnss@1.0-service

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/gps/arm64-v8a/gps.default.so:vendor/lib64/hw/gps.default.so \
    $(LOCAL_PATH)/gps/gps_cfg.inf:vendor/etc/gps_cfg.inf

# Add CAN-utils
PRODUCT_PACKAGES += \
    libcan \
    candump \
    cansend

ifeq ($(strip $(PRODUCT_ASUS_NAME)), Sanden_VM)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/Sanden_VM/init.sanden_vm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.sanden_vm.rc \
    $(LOCAL_PATH)/Sanden_VM/ueventd.sanden_vm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc \
    $(LOCAL_PATH)/Sanden_VM/init.connectivity.sanden_vm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.connectivity.rc
else ifeq ($(strip $(PRODUCT_ASUS_NAME)), Sanden_CM)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/Sanden_CM/init.sanden_cm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.sanden_cm.rc \
    $(LOCAL_PATH)/Sanden_CM/ueventd.sanden_cm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc \
    $(LOCAL_PATH)/Sanden_CM/init.connectivity.sanden_cm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.connectivity.rc
else ifeq ($(strip $(PRODUCT_ASUS_NAME)), Tinker_Board_3N)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/Tinker_Board_3N/init.tinker_board_3n.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.tinker_board_3n.rc \
    $(LOCAL_PATH)/Tinker_Board_3N/ueventd.tinker_board_3n.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc \
    $(LOCAL_PATH)/Tinker_Board_3N/init.connectivity.tinker_board_3n.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.connectivity.rc
endif
