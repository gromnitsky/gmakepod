#!/bin/sh

# an aggressive sync: delete src after a successful upload
# usage: GMAKEPOD_MOUNTPOINT=/mnt/dir gmakepod_sync

src=~/podcasts/media
mount_point=${GMAKEPOD_MOUNTPOINT:-/mnt/mp650}
dest=$mount_point/podcasts

errx() { echo "`basename "$0"` error: $1" 1>&2; exit 1; }

sync() {
    mkdir -p "$dest"
    rsync -rcv --remove-source-files --progress "$src/" "$dest"
}

dest_clean_empty_dirs() { rmdir "$dest"/* > /dev/null 2>&1; }

dest_mount() {
    mountpoint -q "$mount_point" || mount "$mount_point" || errx "device isn't plugged in"
}

dest_umount() { mountpoint -q "$mount_point" && umount "$mount_point"; }

dest_mount
sync || exit 1
dest_clean_empty_dirs
dest_umount
