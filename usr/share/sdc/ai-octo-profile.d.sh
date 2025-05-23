#!/bin/bash

DEVTEST=`aplay -l 2> >(grep -c "no soundcards found")`
if [ "$DEVTEST" -eq "1" ]; then
  sudo modprobe -r snd_soc_audioinjector_octo_soundcard
  sudo modprobe -r snd_soc_cs42xx8_i2c
  sudo modprobe -r snd_soc_cs42xx8
  sudo modprobe snd_soc_cs42xx8
  sudo modprobe snd_soc_cs42xx8_i2c
  sudo modprobe snd_soc_audioinjector_octo_soundcard
fi
