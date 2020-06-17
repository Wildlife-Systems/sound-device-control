#!/bin/bash

sudo alsactl restore -f /rpa-dac-asound.state
sudo rm ./rpa-dac-asound.state

# Delete me
sudo rm /etc/profile.d/rpa-dac-profile.d
