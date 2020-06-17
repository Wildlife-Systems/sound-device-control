# Sound device control and installation for Raspberry Pi
This bash script allows for control of various Raspberry Pi sound cards using a simple and standardised interface. The script was developed as part of the Automated Acoustic Observatories project and simplifies the automated control of audio collection when using a network of Raspberry Pi devices with a heterogenous set of sound devices.

## Comaptible devices
Devices that have been tested with these scripts are listed below. The short name is used internally to refer to different sound cards, and is the paramater passed to `sdc-inst` to perform the installation.

| Device | `shortname` |
| --- | --- |
| audioInjector Zero | ai-zero |
| audioInjector Ultra | ai-ultra |
| audioInjector Octo | ai-octo |
| raspiaudio Audio+ DAC | rpa-dac |
| Inbuilt headphone jack | rpi-core-audio |

## Installing this package
`wget -O - https://github.com/audioblast/sound-device-control/raw/master/install | sudo bash`

## Installation of sound device software
The script `sdc-inst` can be used to install various drivers for sound cards and configure them. This is mainly of use in large scale, automated, heterogenous deployments but may simplify things for some other end users (as an example at the time of writing the Audio+ DAC installation required running `speaker-test` and two reboots to be functional in `alsamixer` - the process here only requires a single reboot).

Usage:
```
sdc-inst <shortname>
```

## Development
* Initial development of this script was done as part of the Levehulme Trust funded Automated Acoustic Observatories project at the University of York.
* Support for further devices was added as part of the Urban Nature Project at the Natural History Museum, London.
