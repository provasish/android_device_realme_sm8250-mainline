#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_MAKEFILES := \
    aosp_spartan_mainline:$(LOCAL_DIR)/spartan_mainline/aosp_spartan_mainline.mk \
    lineage_spartan_mainline:$(LOCAL_DIR)/spartan_mainline/lineage_spartan_mainline.mk

$(foreach build_type, user userdebug eng, \
    $(eval COMMON_LUNCH_CHOICES += aosp_spartan_mainline-$(build_type)) \
    $(eval COMMON_LUNCH_CHOICES += lineage_spartan_mainline-$(build_type)))
