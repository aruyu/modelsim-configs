#!/bin/bash
#==
#   NOTE      - install_vsim.sh
#   Author    - Aru
#
#   Created   - 2025.12.18
#   Github    - https://github.com/aruyu
#   Contact   - vine9151@gmail.com
#/



T_CO_RED='\e[1;31m'
T_CO_YELLOW='\e[1;33m'
T_CO_GREEN='\e[1;32m'
T_CO_BLUE='\e[1;34m'
T_CO_GRAY='\e[1;30m'
T_CO_NC='\e[0m'

CURRENT_PROGRESS=0

function script_print()
{
  echo -ne "${T_CO_BLUE}[SCRIPT]${T_CO_NC}$1"
}

function script_notify_print()
{
  echo -ne "${T_CO_BLUE}[SCRIPT]${T_CO_NC}${T_CO_GREEN}-Notify- $1${T_CO_NC}"
}

function script_error_print()
{
  echo -ne "${T_CO_BLUE}[SCRIPT]${T_CO_NC}${T_CO_RED}-Error- $1${T_CO_NC}"
}

function script_println()
{
  echo -ne "${T_CO_BLUE}[SCRIPT]${T_CO_NC}$1\n"
}

function script_notify_println()
{
  echo -ne "${T_CO_BLUE}[SCRIPT]${T_CO_NC}${T_CO_GREEN}-Notify- $1${T_CO_NC}\n"
}

function script_error_println()
{
  echo -ne "${T_CO_BLUE}[SCRIPT]${T_CO_NC}${T_CO_RED}-Error- $1${T_CO_NC}\n"
}

function error_exit()
{
  script_error_println "$1\n"
  exit 1
}




#==
#   Starting codes in blew
#/

if [[ $EUID -eq 0 ]]; then
  error_exit "This script must be run as USER!"
fi

ARCH=Arch
UBUNTU=Ubuntu

while true; do
  read -p "Enter what you want to install (Arch, Ubuntu): " SELECTION
  case ${SELECTION} in
    [Aa][Rr][Cc][Hh] )          CURRENT_JOB=Arch; break;;
    [Uu][Bb][Uu][Nn][Tt][Uu] )  CURRENT_JOB=Ubuntu; break;;
    * )                         script_error_println "Wrong answer.";;
  esac
done


script_notify_println "Installing dependencies..."

if [[ ${CURRENT_JOB} = ${ARCH} ]]; then
  # Arch
  sudo pacman -S --needed expat fontconfig freetype2 xorg-fonts-type1 glibc gtk2 libcanberra libpng libpng12 libice libsm util-linux ncurses tcl zlib libx11 libxau libxdmcp libxext libxft libxrender libxt libxtst
  sudo pacman -S --needed lib32-expat lib32-fontconfig lib32-freetype2 lib32-glibc lib32-gtk2 lib32-libcanberra lib32-libpng lib32-libpng12 lib32-libice lib32-libsm lib32-util-linux lib32-ncurses lib32-zlib lib32-libx11 lib32-libxau lib32-libxdmcp lib32-libxext lib32-libxft lib32-libxrender lib32-libxt lib32-libxtst
  trizen -S --needed tcllib ncurses5-compat-libs lib32-ncurses5-compat-libs

elif [[ ${CURRENT_JOB} = ${UBUNTU} ]]; then
  # Ubuntu
  sudo dpkg --add-architecture i386 
  sudo apt-get update 
  sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 
  sudo apt-get install lib32z1 lib32ncurses5 lib32bz2-1.0 

fi


script_notify_println "Running setup file..."

if [[ ! -e "./ModelSimSetup-20.1.1.720-linux.run" ]]; then
  wget https://download.altera.com/akdlm/software/acdsinst/20.1std.1/720/ib_installers/ModelSimSetup-20.1.1.720-linux.run
fi

./ModelSimSetup-20.1.1.720-linux.run --modelsim_edition modelsim_ase --accept_eula 1 --mode unattended --unattendedmodeui minimal &
PID=$!
read -p "Press enter when the setup dialog says 'Setup complete.'"
kill $PID

cd /opt/intelFPGA/20.1/modelsim_ase
sed -i 's/linux_rh60/linux/' vco
sed -i 's/dir=`dirname "$arg0"`/dir=`dirname "$arg0"`\nexport LD_LIBRARY_PATH=${dir}\/lib32/' vco
# adds "export LD_LIBRARY_PATH=${dir}/lib32" after $dir is found.

cat > ./modelsim.desktop <<EOF
[Desktop Entry]
Name=ModelSim
Comment=ModelSim
Exec=/opt/intelFPGA/20.1/modelsim_ase/bin/vsim
Icon=modelsim
Terminal=true
Type=Application
Categories=Development
EOF
sudo mv ./modelsim.desktop /usr/share/applications

script_notify_println "${CURRENT_JOB} installation successfully done."
