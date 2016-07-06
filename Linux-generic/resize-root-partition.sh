#!/bin/bash

function snot() {
	local _s="\"$1\""
	local _f=""
	shift
	
	for _f in "$@"; do
		_s="${_s} \"${_f}\""
	done
	
	eval "${_s}" && return 1
	return 0
}

if [ `whoami` != "root" ]; then
	exec sudo "$0" "-kzza" "${HOME}" "$@"
elif [ "$1" = "-kzza" ]; then
	__home="$2"
	shift 2
else
	echo "ERROR: $0 cannot be run as root."
	exit 1
fi	

source "${__home}/bin/LoadBashScripts.sh"

__msg="This utility will extend the root partition to fill the entire disk. Are you sure you want to do this?"

if snot whiptail --backtitle "Rootfs Expander Utility" --yesno "${__msg}" 0 0; then
	exit 0
fi

__datenow=`date "+%Y%m%d-%H%M%S"`
__logfile="${__home}/resize-${__datenow}-log.txt"
__ptstart=`fdisk -l /dev/mmcblk0 | grep mmcblk0p2 | awk '{print $2}'`

case "${DISTRO_VERSION}" in
	"15.04" | "15.10" | "16.04")
		__ptstop=$((`fdisk -l /dev/mmcblk0 | grep Disk | grep sectors | awk '{printf $7}'` - 1024))
		;;
	*)
		__ptstop=$((`fdisk -l /dev/mmcblk0 | grep total | grep sectors | awk '{printf $8}'` - 1024))
		;;
esac

fdisk "/dev/mmcblk0" >> "${__logfile}" 2>&1 <<-GREOF
		p
		d
		2
		n
		p
		2
		${__ptstart}
		${__ptstop}
		p
		w
	EOF

case "${DISTRO_VERSION}" in
	"15.04" | "15.10" | "16.04") 
		cat > /lib/systemd/system/fsresize.service <<-"GREOF"
			[Unit]
			Description=Resize FS
			
			[Service]
			Type=simple
			ExecStart=/etc/init.d/resize2fs_once start
			
			[Install]
			WantedBy=multi-user.target
		GREOF
		systemctl enable fsresize;;
esac

cat > /etc/init.d/resize2fs_once <<-"GREOF"
		#!/bin/sh
		### BEGIN INIT INFO
		# Provides:          resize2fs_once
		# Required-Start:
		# Required-Stop: 
		# Default-Start: 2 3 4 5 S
		# Default-Stop:
		# Short-Description: Resize the root filesystem to fill partition
		# Description:
		### END INIT INFO
		
		. /lib/lsb/init-functions
		
		case "$1" in
		    start)
		        log_daemon_msg "Starting resize2fs_once" && \
		            resize2fs /dev/mmcblk0p2 && \
		            rm /etc/init.d/resize2fs_once && \
		            update-rc.d resize2fs_once remove && \
		            log_end_msg $?
		        ;;
		    *)  
		        echo "Usage: $0 start" >&2
		        exit 3
		        ;;
		esac  
	EOF

chmod a+x /etc/init.d/resize2fs_once
update-rc.d resize2fs_once defaults

__msg="Rootfs Extended. Your system needs to be\nrebooted in order for this to take effect.\n\nDo you want to reboot now?"

if whiptail --backtitle "Rootfs Expander Utility" --yesno "${__msg}" 0 0; then
	reboot
fi

exit 0
