TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = com.xiaoduotou.yjb

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = yangjibao

yangjibao_FILES = Tweak.x
yangjibao_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
