TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = com.pxmage.egoreader

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ego

ego_FILES = Tweak.x
ego_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
