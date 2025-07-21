TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = com.mubu.iosapp

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = mubu

mubu_FILES = Tweak.x
mubu_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
