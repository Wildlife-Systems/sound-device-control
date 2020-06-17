#!/bin/bash

#Identify the sound card
DEV="0"

DEVTEST=`aplay -l | grep -c "bcm2835 Headphones"`
if [ "$DEVTEST" -eq "1" ]; then
	DEV="rpi-core-audio"
fi

DEVTEST=`aplay -l | grep -c "AudioInjector audio wm8731-hifi-0"`
if [ "$DEVTEST" -eq "1" ]; then
	DEV="ai-zero"
fi

DEVTEST=`aplay -l | grep -c "audioinjector-ultra"`
if [ "$DEVTEST" -eq "1" ]; then
	DEV="ai-ultra"
fi

DEVTEST=`aplay -l | grep -c "audioinjector-octo-soundcard"`
if [ "$DEVTEST" -eq "1" ]; then
	DEV="ai-octo"
fi

DEVTEST=`aplay -l | grep -c "snd_rpi_hifiberry_dac"`
if [ "$DEVTEST" -eq "1" ]; then
	DEV="rpa-dac"
fi

if [ "$DEV" = "0" ]; then
	echo "No compatible sound device found."
	exit 1
fi

case "$1" in
	input)
		case "$2" in 
			line)
				case "$DEV" in
					ai-zero)
						alsactl --file /usr/share/doc/audioInjector/asound.state.RCA.thru.test restore
						;;
					ai-ultra)
						amixer cset name='ADC Mux' 1
						;;
					*)
						echo "line is not a supported input for $DEV"
						exit 1
						;;
				esac
				;;
			mic)
				case "$DEV" in
					ai-zero)
						alsactl --file /usr/share/doc/audioInjector/asound.state.MIC.thru.test restore
						;;
					ai-ultra)
						amixer cset name='ADC Mux' 0
						;;
					*)
						echo "mic is not a supported input for $DEV"
						exit 1
						;;
				esac
				;;
		esac
		;;
	volume)
		case "$2" in
			capture)
				case "$DEV" in
					ai-zero)
						amixer sset Capture $3
						;;
					*)
						echo "capture is not a supported output for $DEV"
						;;
				esac
				;;
			master)
				case "$DEV" in
					ai-zero | rpa-dac)
						amixer sset Master $3
						;;
					rpi-core-audio)
						echo "Setting Headphone output for rpi-core-audio"
						amixer sset Headphone $3
						;;
					*)
						echo "master is not a supported output for $DEV"
						;;
				esac
				;;
			*)
				echo "unknown volume: $2"
				exit 1
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
	name)
		case "$DEV" in
			ai-zero)
				echo "AudioInjector Zero or AudioInjector Stero"
				;;
			ai-ultra)
				echo "AudioInjector Ultra"
				;;
			ai-octo)
				echo "AudioInjector Octo"
				;;
			rpa-dac)
				echo "RasPiAudio Audio+ DAC"
				;;
			*)
				echo "No compatible card detected."
				;;
		esac
		;;
	*)
		echo $"Usage: sdc input <line|mic>"
		echo $"       sdc volume <capture|master> <n%|n>"
		echo $"       sdc mic-boost <on|off>"
		echo $"       sdc name"
		exit 1
		;;
esac
