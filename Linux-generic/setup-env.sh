#!/bin/bash

__scpt=`readlink -f "$0"`
__sdir=`dirname "${__scpt}"`

__bindir="${__sdir}/bin"
__bshdir="${__sdir}/bash.d"

if [ -d "${__bindir}" -a -d "${__bshdir}" ]; then
	##########################################################################
	# Setup some variables....
	#
	__dig="0 1 2 3 4 5 6 7 8 9"
	__wai=`whoami`
	__dr1="${HOME}/bin"
	__dr2="${HOME}/.bash.d"
	__ssh="${HOME}/.ssh"
	__hn=""
	__ipa=`hostname -I`
	__ipb=`echo "${__ipa}" | sed 's/\./ /g'`
	__ipc=`echo "${__ipb}" | awk '{print $4}'`
	__ipd=`echo "${__ipb}" | awk '{print $1"."$2"."$3}'`
	#
	##########################################################################
	# Some very helpful functions...
	#
	function Zoidberg() {
		local x=""
		for x in ${__dig}; do
			if [ "$2$x" = "$1" ]; then
				echo "$3$x"
				return 0
			fi
		done
		echo ""
		return 1
	}
	function Not() {
		local cmd="\"$1\""
		local elm=""
		shift; for elm in "$@"; do cmd="${cmd} \"${elm}\""; done
		if eval "${cmd}"; then return 1; else return 0; fi
	}
	#
	##########################################################################
	# Some distros leave out these 3 tools. I find them incredibly useful!!
	#
	sudo apt-get -y install nano rsync whiptail
	sudo update-alternatives --set editor `which nano`
	#
	##########################################################################
	# Some people who trust themselves an aweful lot (or like to live life on
	# the edge) don't like to have to enter a password to use sudo.
	#
	__psu=$(sudo cat "/etc/sudoers" | grep -E "^${__wai}\\s+(ALL)=\\(\\1\\)\\s+NOPASSWD:\\s+\\1")
	
	if [ -z "${__psu}" ]; then
		__m="Password-less sudo?\n\n"
		__m="${__m}CAUTION: Make sure you understand the risks before you say \"Yes\"!\n\n"
		__m="${__m}If you don't know what any of this means then just say \"No\"!"
	
		if whiptail --yesno "${__m}" 0 0; then
			echo "${__wai} ALL=(ALL) NOPASSWD: ALL" | sudo tee -a "/etc/sudoers" >/dev/null
		fi
	fi
	#
	##########################################################################
	# Back up the originals if any exist...
	#
	if [ -d "${__dr1}" -o -d "${__dr2}" ]; then
		__dt1=`date +%Y%m%d%H%M%S`
		__dr3=""
		if [ -d "${__dr1}" ]; then __dr3="${__dr3} ${__dr1}"; fi
		if [ -d "${__dr2}" ]; then __dr3="${__dr3} ${__dr2}"; fi
		
		if Not tar cvfz "${__sdir}/backup-${__dt1}.tar.gz" ${__dr3} >/dev/null; then
			if Not whiptail --yesno "Backup of the existing ${HOME}/bin failed.\n\nDo you wish to continue?" 0 0; then
				exit 1
			fi
		fi
		
		unset __dr3
	fi
	#
	##########################################################################
	# Copy over the bash script additions and the helper scripts.
	#
	rsync -av "${__bindir}/" "${__dr1}/" || exit "$?"
	rsync -av "${__bshdir}/" "${__dr2}/" || exit "$?"
	#
	##########################################################################
	# Compile any C helper scripts...
	#
	cc -o "${__dr1}/bcnt" -O2 -g "${__dr1}/bcnt.c" >/dev/null 2>/dev/null
	#
	##########################################################################
	# Set the new bash scripts to load on login.
	#
	cat >> "${HOME}/.bashrc" <<-"GREOF"
		###################################################################
		# Load the custom bash scripts from the <HOME>/.bash.d/ directory.
		#
		__fu="${HOME}/bin/LoadBashScripts.sh"; if [ -e "${__fu}" ]; then source "${__fu}"; fi; unset __fu
		#
		###################################################################
	GREOF
	source "${HOME}/bin/LoadBashScripts.sh"
	#
	##########################################################################
	# Generate new SSH keys if wanted...
	#
	if [ ! -e "${__ssh}/id_rsa" ]; then
		if whiptail --yesno "Generate new SSH keys?" 0 0; then
			mkdir -p "${__ssh}"
			__pwd="${PWD}"
			cd "${__ssh}"
			ssh-keygen -t rsa
			cd "${__pwd}"
		fi
	fi
	#
	##########################################################################
	# Create new /etc/hosts file...
	#
	cat <<-myEOF | sudo tee "/etc/hosts" >/dev/null
		127.0.0.1	localhost
		
		# The following lines are desirable for IPv6 capable hosts
		::1     ip6-localhost ip6-loopback
		fe00::0 ip6-localnet
		ff00::0 ip6-mcastprefix
		ff02::1 ip6-allnodes
		ff02::2 ip6-allrouters
		
		${__ipd}.1		galen-r router
		${__ipd}.101	homer
		${__ipd}.105	windowsbox
		${__ipd}.206	zaphod
		
		${__ipd}.130	rpi0 rpi
		${__ipd}.131	rpi1
		${__ipd}.132	rpi2
		${__ipd}.133	rpi3
		${__ipd}.134	rpi4
		${__ipd}.135	rpi5
		${__ipd}.136	rpi6
		${__ipd}.137	rpi7
		${__ipd}.138	rpi8
		${__ipd}.139	rpi9
				
		${__ipd}.140	odroid0 odroid
		${__ipd}.141	odroid1
		${__ipd}.142	odroid2
		${__ipd}.143	odroid3
		${__ipd}.144	odroid4
		${__ipd}.145	odroid5
		${__ipd}.146	odroid6
		${__ipd}.147	odroid7
		${__ipd}.148	odroid8
		${__ipd}.149	odroid9

	myEOF
	#
	##########################################################################
	# Create new hostname for device....
	#
	# __hn=$(cat /etc/hostname)
	#
	__on=`cat "/etc/hostname" | head -n1`
	__hn=`Zoidberg "${__ipc}" "14" "odroid"`
	if [ -z "${__hn}" ]; then __hn=`Zoidberg "${__ipc}" "13" "rpi"`; fi
	if [ -z "${__hn}" ]; then __hn="${__on}"; fi
	
	__nh=`whiptail --inputbox "Enter Hostname" 0 40 "${__hn}" 3>&1 1>&2 2>&3`
	
	if [ $? -eq 0 -a -n "${__nh}" -a "${__on}" != "${__nh}" ]; then
		echo "${__nh}" | sudo tee "/etc/hostname" >/dev/null;
	fi
	#
	##########################################################################
	#
	if whiptail --yesno "You'll need to reboot for the settings to take effect.\n\nReboot Now?" 0 0; then
		exec sudo reboot
	fi
	#
	##########################################################################
else
	##########################################################################
	# The files we need are missing so let's refetch them from the repository
	# and then restart the new copy of the script.
	#
	__oscpt="${__sdir}/odroid-scripts"
	__basen=`basename "$0"`
	git clone "https://github.com/GalenRhodes/odroid-scripts.git" "${__oscpt}" || exit "$?"
	__zzz=`find "${__oscpt}" -name "${_basen}" | head -n1`
	exec "${__zzz}" "$@"
	#
	##########################################################################
fi

exit 0
