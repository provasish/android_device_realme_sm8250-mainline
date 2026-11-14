#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from parent
include device/realme/sm8250-mainline/BoardConfig.mk

# Boot parameters
BOARD_KERNEL_CMDLINE += \
    androidboot.hardware=spartan

# Display
TARGET_SCREEN_DENSITY := 450

# Kernel
# The usbtest DTB fixes USB to high-speed peripheral mode. It is the variant
# proven on hardware; switch to qcom/sm8250-realme-spartan once Type-C role
# switching through the PM8150B is verified.
TARGET_DTB_LIST_WILDCARD := \
    qcom/sm8250-realme-spartan-usbtest

# OTA
TARGET_OTA_ASSERT_DEVICE := spartan_mainline,spartan,RMX3371,RE54E4L1

# Partitions
# Same super partition as the stock layout (virtual A/B, one copy of each
# logical partition).
BOARD_SUPER_PARTITION_SIZE := 11274289152
BOARD_REALME_SM8250_MAINLINE_DYNPART_SIZE := $(shell expr $(BOARD_SUPER_PARTITION_SIZE) - 4194304)

# Recovery
TARGET_RECOVERY_FSTAB := $(TARGET_DEVICE_PATH)/fstab/fstab.spartan
