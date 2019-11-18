# Usage

In order to load the application in INQMEGA camera please follow these steps:
1. Apply `extract_part.sh` on the downloaded from 4PDA image (e.g. Hip_Mod_fw_S.img) to extract `root` and `home` partitions. Place `mtd3_ro.img` and `mtd5_home.img` in the current directory.
`file *.img` should report, that these two extracted images are Squashfs filesystems.

      _Note:_ if flash layout changes, offsets can always be found by grepping `strings FIRMWARE | grep  mtdparts=`
2. `mtd4_config.img` is not directly used in these scripts, but if you want to replace the default configuration in `./data`, this image should be extracted
3. Compile wanscam_wifi_config and place edit_config.arm into the current directory
4. Edit config.txt to match your camera MAC address
5. Set up Wi-Fi credentials in the same file
6. Activate `custom_firmware/entry.sh` script in `../debug_cmd.sh`
7. As `zskj_script_run.sh` will be also executed it might result in loading same scripts twice. In order to prevent it this file can be just removed, but probably you would like to disable cloud domains via `/etc/hosts` file for the custom firmware also, then `zskj_script_run.sh` should be patched so that this line contains a list of desired modules to be loaded like 
`[ -x $BASEDIR/entry.sh ] && $BASEDIR/entry.sh hosts`
In this case only `hosts` module will be loaded in chroot

# Troubleshooting
* Booting of the custom firmware starts after 30 seconds. `ipc` calibrates camera once more resulting in rotating it back and forth. If it is not happening, check, that the step 6 is done
* If camera is calibrated, but does not connect to your Wi-Fi, remove `./data/.wifi_conn_info` from SD, check config.txt and try again

# What does it do?

1. First these scripts kill the existing p2pcam application and all its dependencies
2. Some drivers are unloaded and replaced by those needed by the custom firmware
3. Then a new chroot environment is created to isolate the new firmware from the old one
4. The new firmware is started in the chroot

In order to enter the chroot environment, you should use `chroot /tmp/root2/`

In roder to prevent flashing of a new firmware by mistake these techniques are applied: `mtd*` devices are deleted from `/dev/` in the chroot and a custom `version.ini` is mounted inside it.
