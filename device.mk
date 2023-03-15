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
    $(LOCAL_PATH)/init.tinker_board_3.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.tinker_board_3.rc \
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

# Cellular
PRODUCT_PACKAGES += \
    CarrierDefaultApp \
    CarrierConfig \
    rild \
    libril \
    libreference-ril \
    usb_dongle \
    radio_dependencies \
    dhcpcd \

EXTRA_VENDOR_LIBRARIES += \
    android.hardware.radio@1.0 \
    android.hardware.radio@1.1 \
    android.hardware.radio@1.2 \
    android.hardware.radio@1.3 \
    android.hardware.radio@1.4 \
    android.hardware.radio@1.5 \
    android.hardware.radio@1.6 \
    android.hardware.radio.config@1.0-service \
    android.hardware.radio.config@1.0 \
    android.hardware.radio.config@1.1 \
    android.hardware.radio.config@1.2 \
    android.hardware.radio.config@1.3 \
    android.hardware.radio.deprecated@1.0 \
    android.hardware.secure_element@1.0 \
    android.hardware.secure_element@1.1 \
    android.hardware.secure_element@1.2

PRODUCT_PROPERTY_OVERRIDES += \
    ro.boot.noril=false \
    ro.radio.noril=false \
    ro.telephony.default_network=26 \
    persist.vendor.radio.apm_sim_not_pwdn=1 \
    persist.vendor.radio.sib16_support=1 \
    persist.vendor.radio.custom_ecc=1 \
    rild.libpath=/vendor/lib64/hw/libreference-ril.so \
    vendor.rild.libpath=/vendor/lib64/hw/libreference-ril.so \
    persist.vendor.radio.procedure_bytes=SKIP \
    persist.radio.multisim.config=ssss \
    persist.vendor.radio.rat_on=combine


PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/cellular/rild.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/rild.rc \
    $(LOCAL_PATH)/cellular/libreference-ril.so:$(TARGET_COPY_OUT_VENDOR)/lib64/hw/libreference-ril.so \
    $(LOCAL_PATH)/cellular/libril.so:$(TARGET_COPY_OUT_VENDOR)/lib64/libril.so \
    $(LOCAL_PATH)/cellular/ql-ril.conf:$(TARGET_COPY_OUT_VENDOR)/etc/ql-ril.conf \
    $(LOCAL_PATH)/cellular/chat:/system/bin/chat \
    $(LOCAL_PATH)/cellular/ip-down:/system/etc/ppp/ip-down \
    $(LOCAL_PATH)/cellular/ip-up:/system/etc/ppp/ip-up \
    $(LOCAL_PATH)/cellular/dhcpcd:$(TARGET_COPY_OUT_VENDOR)/bin/dhcpcd

DEVICE_MATRIX_FILE += \
    device/asus/tinker_board_3/cellular/radio_compatibility_matrix.xml
DEVICE_MANIFEST_FILE += \
    device/asus/tinker_board_3/cellular/radio_manifest.xml

BOARD_SEPOLICY_DIRS += \
    device/asus/tinker_board_3/sepolicy/cellular

# Get the long list of APNs
PRODUCT_COPY_FILES += vendor/rockchip/common/phone/etc/apns-full-conf.xml:system/etc/apns-conf.xml
PRODUCT_COPY_FILES += vendor/rockchip/common/phone/etc/spn-conf.xml:system/etc/spn-conf.xml
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

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery.fstab.emmc:recovery/root/system/etc/recovery.fstab.emmc \
    $(LOCAL_PATH)/fstab.rk30board.emmc:$(TARGET_COPY_OUT_RAMDISK)/fstab.rk30board.emmc \
    $(LOCAL_PATH)/fstab.rk30board.emmc:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.rk30board.emmc \
    $(LOCAL_PATH)/recovery.fstab.sd:recovery/root/system/etc/recovery.fstab.sd \
    $(LOCAL_PATH)/fstab.rk30board.sd:$(TARGET_COPY_OUT_RAMDISK)/fstab.rk30board.sd \
    $(LOCAL_PATH)/fstab.rk30board.sd:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.rk30board.sd \
    $(LOCAL_PATH)/fstab.rk30board.no_sdmmc:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.rk30board

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
