# Android device tree for realme SM8250 devices running mainline kernel

Family tree for realme phones with the Qualcomm SM8250 family (Snapdragon
865/870), booted by the **stock** bootloader. Device directories:

| Directory | Device |
|-----------|--------|
| `spartan_mainline` | realme GT Neo 3T (RMX3371) / Q5 Pro (RMX3372), Snapdragon 870 |

The GT Neo 2 (`bitra`, RMX3370) shares the board design and can be added as a
thin device directory.

## Status

Verified with a mainline 7.2 kernel and a test initramfs (not yet with this
Android build):

| Feature | Works | Notes |
|---------|-------|-------|
| Boot (stock ABL) | yes | `fastboot boot` from the ROM slot, `dtbo` untouched |
| Kernel to userspace | yes | 8 CPUs, full RAM, reserved memory map from stock |
| USB (peripheral) | yes | USB serial gadget used for the boot log |
| Android | | Not built yet |
| Display | | Bootloader framebuffer only; no panel driver for the Samsung AMS662ZS01 |
| Touch | | FocalTech FT3658U, no mainline driver (FT3518 tried) |
| Audio | | Needs ADSP and a UCM profile |
| Wi-Fi / Bluetooth | | QCA6390; firmware not packaged (see Known issues) |
| Camera | no | |
| Modem | no | External SDX55 |
| Charging | | PM8150B; MP2650 charger has no driver |

## How the stock bootloader is satisfied

The realme/Oplus ABL accepts a mainline image only when:

| Requirement | Where |
|-------------|-------|
| Header v2 boot image with the DTB inside | `BoardConfig.mk` |
| DTB root has `oplus,dtsi_no` and `qcom,board-id` `<0x10008 0>, <0 0>` | Kernel: `sm8250-realme-common.dtsi` |
| The Android board overlay in `dtbo` merges cleanly into the DTB | Kernel: `sm8250-realme-overlay-sink.dtsi` |

The ABL always applies the board overlay from the active slot's `dtbo`.
`sm8250-realme-overlay-sink.dtsi` gives every label those overlays use an
inert, disabled target, so the merge succeeds without touching real nodes.
It is generated from the stock `dtbo`; regenerate it if a ROM or kernel
flash changes `dtbo`.

What breaks it:

| Action | Result |
|--------|--------|
| `fastboot erase dtbo` | The ABL resets the phone; nothing boots |
| A `dtbo` with no matching board overlay | `Booting OKAY`, stays in fastboot |
| A DTB without `oplus,dtsi_no` or without the sink | `Booting OKAY`, stays in fastboot |

## Before flashing the Android build

1. Unlock the bootloader.
2. Back up at least `persist`, `boot_a`/`boot_b`, `dtbo_a`/`dtbo_b`,
   `vbmeta_a`/`vbmeta_b`.
3. Keep the stock (or current ROM's) `dtbo`. **Do not erase it.**
4. Disable verification once:
   `fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img`.
5. Try the boot image first with `fastboot boot boot.img`; it writes nothing.

## Additional repositories required to build

| Path | Source |
|------|--------|
| `kernel/mainline/sm8250-mainline` | `https://github.com/provasish/linux` (branch: `spartan-7.2`): `https://gitlab.nura.eco/soc/qualcomm-sm8250/linux` `7.2.0-dev`, the Android patches, and the realme device trees (`sm8250-realme-common.dtsi`, `sm8250-realme-overlay-sink.dtsi`, `sm8250-realme-spartan.dts`, `sm8250-realme-spartan-usbtest.dts`) |
| `vendor/realme/sm8250-common`, `vendor/realme/spartan` | The vendor trees of the downstream LineageOS port (`extract-files.py` of the downstream device trees) |
| `hardware/qcom-caf/bootctrl` | Needed by `TARGET_BOOT_HAL := qcom-caf-aidl`. TODO(maintainer): confirm the LineageOS manifest already provides it |

## Kernel

Apply the patches in
`device/mainline/common/docs/KERNEL_PATCHES.md`.

Device specific: none beyond the device tree files above.

## Kernel modules

`modprobe/modules.load.*` were derived, not guessed: every `compatible` of
an enabled node in the spartan DTB was matched against `modules.alias` of a
full module build, then completed with drivers that bind without a device
tree alias (`ath11k_pci`, `qrtr-smd`, `socinfo`). Dependencies are pulled by
`TARGET_AUTO_COLLECT_KERNEL_MODULE_DEPS`.

| List | Loaded | Content |
|------|--------|---------|
| `modules.load.basic` | Early, and in recovery | I2C and touch, power key, watchdog, RNG, RTC, ADC, fuel gauge, `socinfo` |
| `modules.load.normal` | `post-fs`, before `start_all_remoteproc` | DSPs, audio, GPU (`msm`), video, Wi-Fi, Bluetooth, PCIe, haptics, speaker amps |

## Firmware

Nothing proprietary is committed here. At runtime:

| Firmware | Source |
|----------|--------|
| ADSP, CDSP, SLPI | `modem` partition (`image/*.mdt`), mounted at `/vendor/firmware_mnt`; names set in `properties/vendor.prop` |
| Adreno 650 (`sqe`, `gmu`, `zap`) | Copied from `vendor/realme/sm8250-common` |
| DSP data (`acdb`, sensors) | Copied from the vendor trees into `hexagonrpcd-root` |
| `socinfo` | Captured from the downstream kernel's `/sys/devices/soc0` on an RMX3371 |

## Build

    breakfast spartan_mainline
    m

## Install

TODO(maintainer): installation into the existing virtual A/B layout replaces
the current ROM's logical partitions in `super`. Document the exact steps
after the first successful boot.

## Known issues

- `TARGET_INITIAL_BRINGUP` is set (permissive SELinux, early adbd).
- USB is fixed to peripheral mode (`usbtest` DTB) until Type-C role
  switching is verified.
- Wi-Fi: ath11k wants `ath11k/QCA6390/hw2.0/{amss.bin,m3.bin,board-2.bin}`
  from linux-firmware; the stock files on `modem` (`qca6390/amss20.bin`,
  `bdwlan.*`) use other names and formats. TODO(maintainer): package them in
  `external/linux-firmware-mainline`.
- Bluetooth: the driver requests `qca/htbtfw20.tlv` and `qca/htnv20.bin`.
  The stock files are on the `bluetooth` partition. TODO(maintainer): package
  them in `external/linux-firmware-mainline`.
- Venus: the kernel DTS names `qcom/sm8250/realme/spartan/venus.mbn`, but the
  stock image is `venus.mdt` on `modem`. TODO(maintainer): align the name.
- No panel driver: the screen shows the bootloader framebuffer only.
