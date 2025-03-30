TARGET := iphone:clang:latest:7.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FakePurchaseTweak
FakePurchaseTweak_FILES = Tweak.xm
FakePurchaseTweak_FRAMEWORKS = StoreKit UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
