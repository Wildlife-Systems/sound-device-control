#!/bin/bash

#Identify the sound card
DEV="0"
DEVTEST=`aplay -l | grep -c "AudioInjector audio wm8731-hifi-0"`
if [ "$DEVTEST" -eq "1" ]; then
	DEV="ai-zero"
fi

if ["$DEV" = "0"]; then
	echo "No compatible sound device found."
	exit 1
fi

case "$1" in
	input)
		case "$2" in 
			line)
				alsactl --file /usr/share/doc/audioInjector/asound.state.RCA.thru.test restore
				;;
			mic)
				alsactl --file /usr/share/doc/audioInjector/asound.state.MIC.thru.test restore
				;;
		esac
		;;
	volume)
		case "$2" in
			capture)
				amixer sset Capture $3
				;;
			master)
				amixer sset Master $3
		esac
		;;
	mic-boost)
		case "$2" in
			on)
				amixer sset 'Mic Boost' 100%
				;;
			off)
				amixer sset 'Mic Boost' 0%
				;;
		esac
		;;
	*)
		echo $"Usage: $0 input <line|mic>"
		echo $"       $0 volume <capture|master> <n%|n>"
		echo $"       $0 mic-boost <on|off>"
		exit 1
		;;
esac
