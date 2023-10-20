#!/bin/bash
#Java8 Installation
#This script installs Java 8 alongside any other java installation
clear
echo About to install java 8
echo This script should run in sudo
echo ...
sleep 1
clear
echo About to install java 8
echo This script should run in sudo
echo ..
sleep 1
clear
echo About to install java 8
echo This script should run in sudo
echo .
sleep 1
clear
echo About to install java 8
echo This script should run in sudo
echo
sleep 1
clear

#create structure
cd "/lib"
mkdir jvm
cd ./jvm
mkdir java-8
cd ./java-8
sleep 1

#get and extract files
rm -r jre1.8.0*
wget -c https://javadl.oracle.com/webapps/download/AutoDL?BundleId=244058_89d678f2be164786b292527658ca1605
tar -x -f Auto*
rm AutoDL*
cd jre1.8.0*
sleep 1

#create links
DIR=$(find /lib/jvm/java-8 -type d -name 'jre1.8.0*' -print -quit)
rm /usr/bin/java8
rm /usr/bin/java-8
ln -s $DIR/bin/java /usr/bin/java8
ln -s $DIR/bin/java /usr/bin/java-8
sleep 1


#Create app for execution
cd /usr/share/applications
rm java-8.desktop
printf "[Desktop Entry]\nEncoding=UTF-8\nVersion=1.0\nType=Application\nNoDisplay=true\nExec=java8 -jar %%f\nName=java_1.8\nComment=Launch jar with java 8" >> java-8.desktop

#Finishing
cd ~/
echo "Done!"
echo "Open a new terminal and run \"java-8 -version\" to see if it works"
echo ...
sleep 1
clear
echo "Done!"
echo "Open a new terminal and run \"java-8 -version\" to see if it works"
echo ..
sleep 1
clear
echo "Done!"
echo "Open a new terminal and run \"java-8 -version\" to see if it works"
echo .
sleep 1
clear
echo "Done!"
echo "Open a new terminal and run \"java-8 -version\" to see if it works"
echo
echo "Script finished."
echo
echo "more info:"
echo "-Java-8 should be extracted in " $DIR
echo "-Links were created in /usr/bin/java8 and java-8"
echo "-A java-8.desktop was created in /usr/share/applications"
echo "enjoy!"
 
