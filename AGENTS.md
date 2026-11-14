# AGENTS.md - device/realme/sm8250-mainline

Agents must read this file before touching anything in this repository.

Part of the mainline repository set. Map of all repos: `vendor/mainline/docs/REPOSITORIES.md`.

Family tree for realme SM8250 devices (`spartan_mainline`). Layer:
`mainline/common` -> `mainline/qcom-common` -> this tree -> device
directory.

## Read first

| Task | Read |
|------|------|
| Anything about bringup, kernel, boot, init, SELinux | `device/mainline/common/docs/README.md` |
| Commits, style, review | `hardware/mainline/common/docs/` |
| Qualcomm layers | `device/mainline/qcom-common/docs/NEW_DEVICE.md` |
| Stock bootloader rules, install steps | `README.md` |

## Hard rules

- No Android build, flashing or test without asking the human first
  (`hardware/mainline/common/docs/WORKFLOW.md`).
- Do not search from the AOSP tree root; use precise directories.
- Keep device specific values here. Things that apply to more devices
  belong in the common trees (ask first).
- Never tell anyone to erase `dtbo`: the stock ABL then resets the phone.
  The kernel DTB carries an overlay sink instead (`README.md`).
- The partition scheme comes from the device's own GPT. Never take it from
  another device.
- Do not add firmware or proprietary files.
