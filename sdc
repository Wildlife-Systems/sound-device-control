#!/bin/bash

# WildlifeSystems
#
# This script is part of the WildlifeSystems project. For further information
# please refer to https://docs.wildlife.systems, or for more information on
# the project itself, please refer to https://wildlife.systems.

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

DEVTEST=`aplay -l | grep -c "RPiCirrus"`
if [ "$DEVTEST" -eq "1" ]; then
	DEV="wolfson"
	. "/usr/bin/rpi-cirrus-functions.sh"
fi

if [ "$DEV" = "0" ]; then
	echo "No compatible sound device found."
	exit 30
fi



case "$1" in
	input)
		case "$2" in 
			line)
				case "$DEV" in
					wolfson)
						record_from_linein
						;;
					ai-zero)
						alsactl --file /usr/share/doc/audioInjector/asound.state.RCA.thru.test restore
						;;
					ai-ultra)
						amixer cset name='ADC Mux' 1
						;;
					*)
						echo "line is not a supported input for $DEV"
						exit 31
						;;
				esac
				;;
			mic)
				case "$DEV" in
					wolfson)
						record_from_dmic
						;;
					ai-zero)
						alsactl --file /usr/share/doc/audioInjector/asound.state.MIC.thru.test restore
						;;
					ai-ultra)
						amixer cset name='ADC Mux' 0
						;;
					*)
						echo "mic is not a supported input for $DEV"
						exit 31
						;;
				esac
				;;
			headset)
				case "$DEV" in
					wolfson)
						record_from_headset
						;;
					*)
						echo "mic is not a supported input for $DEV"
						exit 31
						;;
				esac
				;;
			spdif)
				case "$DEV" in
					wolfson)
						record_from_spdif
						;;
					*)
						echo "spdif is not a supported input for $DEV"
						exit 31
						;;
				esac
				;;
			*)
				echo "Unknown input $2"
				exit 32
		esac
		;;
	output)
		case "$2" in
			headphone)
				case "$DEV" in
					wolfson)
						playback_to_headset
						;;
					rpi-core-audio)
						amixer cset numid=3 1
						;;
					*)
						echo "headphone is not a supported output for $DEV"
						exit 31
						;;
				esac
				;;
			line)
				case "$DEV" in
					wolfson)
						playback_to_lineout
						;;
					*)
						echo "line is not a supported output for $DEV"
						exit 31
						;;
					
				esac
				;;
			spdif)
				case "$DEV" in
					wolfson)
						playback_to_spdif
						;;
					*)
						echo "spdif is not a supported output for $DEV"
						exit 31
						;;
					
				esac
				;;
			speaker)
				case "$DEV" in
					wolfson)
						playback_to_speakers
						;;
					*)
						echo "speaker is not a supported output for $DEV"
						exit 31
						;;
					
				esac
				;;
			hdmi)
				case "$DEV" in
					rpi-core-audio)
						amixer cset numid=3 2
						;;
					*)
						echo "HDMI is not a supported output for $DEV"
						exit 31
						;;
				esac
				;;
			auto)
				case "$DEV" in
					rpi-core-audio)
						amixer cset numid=3 0
						;;
					*)
						echo "auto is not a supported output for $DEV"
						exit 31
						;;
			
				esac
				;;
			*)
				echo "Unknown output $2"
				exit 31
		esac
		;;
	volume)
		case "$2" in
			capture)
				case "$DEV" in
					ai-zero)
						amixer sset Capture $3
						;;
					ai-ultra)
						if [[ "$3" == *% ]]; then
							N=`awk "BEGIN {print int(${3%\%} * 48 / 100 )}"`
							amixer cset name='PGA Volume' -- $N
						else
							amixer cset name='PGA Volume' -- $3
						fi
						;;
					ai-octo)
						if [ -z "$4" ]; then
							echo "Setting all ADC values (1-3). Set individual using captureN."
							amixer cset name='ADC1 Capture Volume' $3
							amixer cset name='ADC2 Capture Volume' $3
							amixer cset name='ADC3 Capture Volume' $3
						else
							amixer cset name="ADC$4 Capture Volume" $3
						fi
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
						if [[ "$3" == *% ]]; then
							N=`awk "BEGIN {print int(${3%\%} * 10639 / 100 - 10239)}"`
							amixer sset Headphone -- $N
						else
							amixer sset Headphone -- $3
						fi
						;;
					ai-octo)
						if [ -z "$4" ]; then
							echo "Setting all DAC values (1-3). Set individual using captureN."
							amixer cset name='DAC1 Capture Volume' $3
							amixer cset name='DAC2 Capture Volume' $3
							amixer cset name='DAC3 Capture Volume' $3
							amixer cset name='DAC4 Capture Volume' $3
						else
							amixer cset name="DAC$4 Capture Volume" $3
						fi
						;;
					ai-ultra)
						amixer cset name='DAC Volume' -- $N
						;;
					*)
						echo "master is not a supported output for $DEV"
						;;
				esac
				;;
			*)
				echo "unknown volume: $2"
				exit 31
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
			rpi-core-audio)
				echo "Raspberry Pi inbuilt audio"
				;;
			wolfson)
				echo "Wolfson Sound Card"
				;;
			*)
				echo "No compatible card detected."
				echo 30
				;;
		esac
		;;
	*)
		echo $"Usage: sdc input <line|mic|micin|spdif>"
		echo $"       sdc output <headphone|hdmi|spdif|line|speakers|auto>"
		echo $"       sdc volume <capture|master> <n%|n>"
		echo $"       sdc volume <capture|master> <n%|n> <subdevice>"
		echo $"       sdc mic-boost <on|off>"
		echo $"       sdc name"
		exit 2
		;;
esac
