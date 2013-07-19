#!/bin/bash

pkill grav
ruby /home/user/VLC/vlcfs.rb "/home/user/VLC/Intro.mp4 /home/user/VLC/INK_Drops_4k.mp4" 18 183
/home/user/grav/gravCMD.sh

sleep 1800

pkill grav
ruby /home/user/VLC/vlcfs.rb "udp://@233.25.229.1:5501 udp://@233.25.229.2:5501 udp://@233.25.229.3:5501" 61 61 58
/home/user/grav/gravCMD.sh
