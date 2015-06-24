SHARED_CFLAGS = -fobjc-arc
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

TWEAK_NAME = SnoozeHelper
SnoozeHelper_FILES = Tweak.xm

SnoozeHelper_FRAMEWORKS = UIKit, CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

include $(THEOS_MAKE_PATH)/aggregate.mk
