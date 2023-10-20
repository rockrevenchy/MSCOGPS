#!/bin/bash
#mangohud
clear
echo About to download Mangohud from github
echo ...
sleep 1
clear
echo About to download Mangohud from github
echo ..
sleep 1
clear
echo About to download Mangohud from github
echo .
sleep 1
clear
echo About to download Mangohud from github
echo
sleep 1
clear

cd /root
rm MangoHud -R
git clone --recurse-submodules https://github.com/flightlessmango/MangoHud.git
cd ~/MangoHud
./build.sh build
./build.sh package
./build.sh install -y

#Finishing
cd ~/
echo "Done!"
echo "Open a new terminal and run \"mangohud\" to see if it works"
echo ...
sleep 1
clear
echo "Done!"
echo "Open a new terminal and run \"mangohud\" to see if it works"
echo ..
sleep 1
clear
echo "Done!"
echo "Open a new terminal and run \"mangohud\" to see if it works"
echo .
sleep 1
clear
echo "Done!"
echo "Open a new terminal and run \"mangohud\" to see if it works"
echo
echo "Script finished."
