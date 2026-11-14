#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

TARGET_DEVICE_PATH := device/realme/sm8250-mainline/spartan_mainline

# Inherit from parent
$(call inherit-product, device/realme/sm8250-mainline/device.mk)

# AAPT
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Audio
# TODO(maintainer): no ALSA UCM profile exists yet for this sound card
# ("Realme GT Neo 3T"); set TARGET_AUDIO_MAINLINE_UCM_PROFILES once one does.

# Boot animation
TARGET_SCREEN_WIDTH := 1080
TARGET_SCREEN_HEIGHT := 2400

# DSP
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(TARGET_DEVICE_PATH)/socinfo/,$(TARGET_COPY_OUT_VENDOR)/etc/hexagonrpcd-root/socinfo/) \
    $(call find-copy-subdir-files,*,vendor/realme/sm8250-common/proprietary/vendor/etc/acdbdata/,$(TARGET_COPY_OUT_VENDOR)/etc/hexagonrpcd-root/acdb/) \
    $(call find-copy-subdir-files,*,vendor/realme/spartan/proprietary/odm/etc/acdbdata/,$(TARGET_COPY_OUT_VENDOR)/etc/hexagonrpcd-root/acdb/) \
    $(call find-copy-subdir-files,*,vendor/realme/sm8250-common/proprietary/vendor/etc/sensors/config/,$(TARGET_COPY_OUT_VENDOR)/etc/hexagonrpcd-root/sensors/config/) \
    vendor/realme/sm8250-common/proprietary/vendor/etc/sensors/sns_reg_config:$(TARGET_COPY_OUT_VENDOR)/etc/hexagonrpcd-root/sensors/sns_reg.conf

# Firmware
# Adreno 650: TODO(maintainer) switch to linux_firmware_qcom-a650 once
# external/linux-firmware-mainline has it.
PRODUCT_COPY_FILES += \
    vendor/realme/sm8250-common/proprietary/vendor/firmware/a650_gmu.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/qcom/a650_gmu.bin \
    vendor/realme/sm8250-common/proprietary/vendor/firmware/a650_sqe.fw:$(TARGET_COPY_OUT_VENDOR)/firmware/qcom/a650_sqe.fw \
    vendor/realme/sm8250-common/proprietary/vendor/firmware/a650_zap.elf:$(TARGET_COPY_OUT_ODM)/firmware/qcom/sm8250/realme/spartan/a650_zap.mbn

PRODUCT_PACKAGES += \
    all_symlink_firmware_spartan

# Init
PRODUCT_PACKAGES += \
    fstab.spartan \
    fstab.spartan.ramdisk \
    init.spartan.rc \
    ueventd.spartan.rc

# SoC
TARGET_QCOM_SOC := sm8250-ac
