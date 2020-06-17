# sdc: sound device control for Raspberry Pi
This bash script allows for control of various Raspberry Pi sound cards using a simple and standardised interface. The script was developed as part of the Automated Acoustic Observatories project and simplifies the automated control of audio collection when using a network of Raspberry Pi devices with a heterogenous set of sound devices.

## Comaptible devices
* audioInjector Zero
* audioInjector Stereo
* audioInjector Ultra
* raspiaudio Audio+ DAC

## Installation of sound device software
The script sdc-inst can be used to install various drivers for sound cards and configure them. This is mainly of use in large scale, automated, heterogenous deployments but may simplify things for some other end users.

## Development
* Initial development of this script was done as part of the Levehulme Trust funded Automated Acoustic Observatories project at the University of York.
* Support for further devices was added as part of the Urban Nature Project at the Natural History Museum, London.
