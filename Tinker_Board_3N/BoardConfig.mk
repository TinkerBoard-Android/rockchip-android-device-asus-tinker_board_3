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
#include device/rockchip/rk356x/BoardConfig.mk
include device/asus/tinker_board_3/BoardConfig.mk
BUILD_WITH_GO_OPT := false
BOARD_BUILD_GKI := false
BOARD_GSENSOR_MXC6655XA_SUPPORT := true
BOARD_CAMERA_SUPPORT_EXT := true
BOARD_HS_ETHERNET := true
PRODUCT_UBOOT_CONFIG += tinker_board_3n.config
PRODUCT_KERNEL_DTS := rk3568-tinker_board_3n
ifeq ($(BOARD_BUILD_GKI),true)
PRODUCT_KERNEL_CONFIG += tinker_board_3n_gki.config
else
PRODUCT_KERNEL_CONFIG += tinker_board_3n.config
endif


#64-bit onlye
DEVICE_IS_64BIT_ONLY := true
TARGET_2ND_ARCH :=
TARGET_2ND_ARCH_VARIANT :=
TARGET_2ND_CPU_ABI :=
TARGET_2ND_CPU_ABI2 :=
TARGET_2ND_CPU_VARIANT :=

PRODUCT_FSTAB_TEMPLATE := device/asus/tinker_board_3/Tinker_Board_3N/fstab.in

TARGET_ROCKCHIP_PCBATEST := false

