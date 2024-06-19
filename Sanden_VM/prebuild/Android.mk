ifeq ($(PRODUCT_NAME), $(filter $(PRODUCT_NAME),Sanden_VM))
LOCAL_PATH := $(call my-dir)

include $(call all-makefiles-under,$(LOCAL_PATH))
endif
