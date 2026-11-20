---
name: linux-usb-xhci-diagnostics
description: Diagnose Linux USB-C ports, xHCI link error counts, Single-TT vs Multi-TT USB 2.0 hub collisions, and GPU DisplayPort clock states via sysfs and debugfs registers.
---

# Linux USB-C, xHCI & Display Register Diagnostics

Use this skill whenever diagnosing intermittent USB device disconnects (`error -71` / `-EPROTO`), USB hub resets (`clear tt 1`), or external display blanking on Linux workstations. Always inspect kernel hardware registers before speculating about power supplies or physical cables.

## 4-Stage Register Inspection Protocol

1. **Over-Current & Port Power Control (`sysfs`)**:
   Check whether any physical root port has tripped hardware over-current protection or aggressive autosuspend:
   ```bash
   grep -H . /sys/bus/usb/devices/*-port*/over_current_count
   grep -H . /sys/bus/usb/devices/*-port*/power/control
   grep -H . /sys/bus/usb/devices/*-port*/usb3_lpm_permit 2>/dev/null
   cat /sys/module/usbcore/parameters/autosuspend
   ```

2. **xHCI Link Error Count & SuperSpeed Lane Negotiation (`debugfs`)**:
   Inspect `/sys/kernel/debug/usb/xhci/*/ports/*/portli` to check `LEC` (Link Error Count) and `RLC`/`TLC` (active RX/TX lanes):
   ```bash
   sudo grep -H . /sys/kernel/debug/usb/xhci/*/ports/*/portli
   ```

3. **USB 2.0 Transaction Translator (Single-TT vs. Multi-TT) Audit**:
   Inspect `/sys/kernel/debug/usb/devices` for `Cls=09(hub)`:
   - `Prot=01` indicates a **Single-TT** USB 2.0 hub (all ports share a single 12 Mbps USB 1.1 Transaction Translator).
   - `Prot=02` indicates a **Multi-TT** USB 2.0 hub (dedicated Transaction Translator per port).
   - Combining a 12 Mbps Full-Speed isochronous audio device (`#Iso>0`) and 1.5 Mbps Low-Speed HID keyboard/mouse on a `Prot=01` Single-TT hub overflows the periodic frame schedule (`clear tt 1 error -71`). Separate them onto different root ports or a `Prot=02` Multi-TT hub.

4. **Portable Dual-USB-C Monitor Back-Feed Safety**:
   Never advise plugging an external USB-C PD wall brick into the secondary unlabelled USB-C port of a generic portable monitor while connected to a host computer unless reverse-current diode isolation is verified, as shared `VBUS` rails can back-feed voltage into the host Type-C controller.
