# Read-only modular GOKE GK7102/GK7102S camera customizer

_Disclaimer:_ you have a high risk of bricking your camera. Make sure you understand what you are doing.

In this repository you can find a bit reworked scripts acquired from zsgx1hacks and 4PDA (in Russian).
The main difference is modularity and flexibility allowing to select needed functionalities one by one.

These scripts offer customization of firmwares for GOKE GK7102/GK7102S based web-cameras.

Main features:
* Default `root` password is `cxlinux`
* Location independent scripts. You may copy and rename `mod/` directory to test multiple versions at the same time. Just copy everything and point to another `DEST/main.sh`, everything else should be detected automatically
* Generic logging for all scripts
* Easy configuration through `config.txt` files. Each module can be configured separately
* Two entry points per module: `boot` and `run`. This defines the order of execution
* Dependencies between modules are checked
* SSH is preferred over telnet (dropbear can be easily activated)
* `/root/` home directory is on SD card: `.ash_history` and `authorized_keys` are editable
* Custom modules:
  * `fake_hw_clock` saves the current time into a file on SD, recovers the time on reboot
  * `inqmega_patches` copies devParam.dat from SD to /home/
  * `openrtsp` is a pre-compiled tool to capture live streams. E.g. the original IL-HIP291 does not save videos if cannot access its servers

Edit `mod/config.txt` to activate/deactivate modules or other settings.

Tested on:
* INQMEGA IL-HIP291
* Wanscam K21
* Should also work on similar compatible cameras. Check 4PDA thread for more details.

## Troubleshooting

* It is better to configure your camera through the app first in order to make sure there is a network connectivity
* `passwd` will not allow to change password, because it cannot create a file on a read-only /etc/. Mount the whole directory containing `passwd`, `group` and `shadow` files via `--bind` on `/etc`: `mount --bind PATH_TO_PASSWD_DIR /etc/`, change the password and unmount. The new password will be saved on the SD card
* Use `./mod/logs/` to analyze boot logs and search for errors

## Boot details
Different firmwares offer different entry points to hook into to run these scripts.

INQMEGA uses `debug_cmd.sh` as an entry point, which is executed before the main application and allows to customize everything. 

Though Wanscam K21 uses `zskj_script_run.sh` as an entry point, which is executed by the camera application itself (`ipc`) and has some limits. For example, it is not possible to pre-load drivers.

If you need to run these scripts earlier, it is possible to use this entry-point:
`/data/pre_init.sh`, see `/home/run_init.sh` in K21 firmware. `installer.sh` can do it, currently there is no need to use it.

# Custom firmware (Wanscam K21)

Many thanks go to *PauS* and *slydiman* from https://4pda.ru/forum/index.php?showtopic=928641 who built this firmware.

The difference here is only allowing to run it in a chroot environment on INQMEGA IL-HIP291 without needing to flash it.

**IMPORTANT: never use the update mechanism in this mode as it will destroy your firmware.**
There are some prevention techniques used, but still the update might destroy everything.

Check `custom_firmware/readme.md` for more details.

# Tools

Tools are either pre-compiled, when taking from other sources or written in shell or Go (https://golang.org/doc/install).

- `swap_bytes` - converts a firmware image to be flashable via a CH341A programmer
- `wanscam_wifi_config` - generates a Wi-Fi configuration file used by the K21 firmware
- `backup_mtd.sh` - backs up the firmware into the current directory
- `flashwriterFlash` - flash writer was taken from the custom firmware from 4PDA
- `memory_dumper.sh` - dumps memory of an active process

# General information

How to find an IP address of my camera? Connect via the native application first and obtain the address either from this application or from your Wi-Fi router.

## INQMEGA

### URLs
|Type| URL|
|---|---|
| HD   | rtsp://login:pass@IP_ADDR:554/0/av0    |
| SD   | rtsp://login:pass@IP_ADDR:554/0/av1    |
| JPEG | http://login:pass@IP_ADDR:554/snapshot |
| Audio| rtsp://login:pass@IP_ADDR:554/0/audio  |
| Onvif| rtsp://IP_ADDR:554/onvif1              |

## Wanscam K21

### URLs
|Type| URL|
|---|---|
| HD     | rtsp://IP_ADDR:554/ch0_0.h264       |
| 640x360| rtsp://IP_ADDR:554/ch0_1.h264       |
| JPEG   | http://IP_ADDR/cgi-bin/net_jpeg.cgi |
| Audio  | - |
| Onvif  | http://IP_ADDR/onvif/device_service |
| Web Interface  | http://IP_ADDR/  user: admin pass: admin |

It is possible to access any file via web: `http://IP_ADDR/anything/` results in a 404 error listing all files. Then it is possible to navigate and open other pages like `static.html` in `httpd` module.

# References and credits
* https://github.com/ant-thomas/zsgx1hacks 
* https://4pda.ru/forum/index.php?showtopic=928641
* http://www.live555.com/openRTSP/
