
ifeq ($(strip $(BOARD_USES_AB_IMAGE)), true)
# generate fstab file for device
-include device/asus/tinker_board_3/RebuildFstab.mk
else ifeq ($(strip $(BOARD_AVB_ENABLE)), true)
# generate fstab file for device
-include device/asus/tinker_board_3/RebuildFstab.mk
endif

# generate dtbo image for device
-include device/rockchip/common/build/rockchip/RebuildDtboImg.mk
# generate parameter.txt for device
-include device/asus/tinker_board_3/RebuildParameter.mk
