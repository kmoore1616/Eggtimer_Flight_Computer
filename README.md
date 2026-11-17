# Simple Rocket Ejection Timer

A low-profile, time-based rocket recovery deployment controller designed for affordability, simplicity, and ease of use.

Built around the **STM8S103F3**, the system uses a four-position DIP switch to configure a 4-bit countdown delay (0–15 seconds). Once triggered, the controller waits for the configured duration before activating its deployment output.

## Features

- Compact, low-cost design
- 4-bit DIP switch for configurable delay
- Active-low start input
- LED countdown indicator
- Bare-metal C firmware using SDCC

## Pinout

| Pin | Function |
|-----|----------|
| PB5 | Status LED |
| PC3–PC6 | 4-bit DIP switch |
| PC7 | Start input |
| PD4 | Deployment output |

## Build & Flash

Requires **SDCC**, **stm8flash**, and an **ST-Link V2** programmer.

```bash
sdcc -mstm8 main.c tim.c -o firmware.ihx
stm8flash -c stlinkv2 -p stm8s103f3 -w firmware.ihx
```
