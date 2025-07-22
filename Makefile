TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = com.strava.stravaride

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = strava

strava_FILES = Tweak.x
strava_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
