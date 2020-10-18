#!/bin/bash

##########################################
# Functions
##########################################

#relies in git and python being downloaded
function getTools {
    wget -q -O - archive.kali.org/archive-key.asc | sudo apt-key add -
    declare -a packages
    packages=("hydra" "hashcat" "john" "dirbuster" "cewl" "nikto")
    for pkg in "${packages[@]}"
    do
        sudo apt-get install $pkg -y
    done

    echo "Finished Installing Packages"
}

function commentRepo {
    echo '[-] Removing kali repo to /etc/apt/sources.list'
    sed -i 's/deb http:\/\/http.kali.org\/kali kali-rolling main non-free contrib/#deb http:\/\/http.kali.org\/kali kali-rolling main non-free contrib/g' /etc/apt/sources.list
    apt-get update -y
}

function checkRoot {
    if [ "$EUID" -ne 0 ]
        then echo "Please run with sudo permissions."
        exit 
    fi     
}

##########################################
# INIT
##########################################

checkRoot

CURR_DIR=$(pwd)

if ! command -v git &> /dev/null
then
    echo '[+] Installing git...'
    apt-get install git
fi

### Check for Kali Repo
CHECK=$(cat /etc/apt/sources.list | grep kali)

if [[ "$CHECK" == "" ]]
then
    echo '[+] Updating system...'
    apt-get update -y
    getTools
    commentRepo 
else
    # add kali repo to /etc/apt/sources.list
    echo '[+] Adding kali repo to /etc/apt/sources.list'
    echo 'deb http://http.kali.org/kali kali-rolling main non-free contrib' >> /etc/apt/sources.list
    echo '[+] Updating system...'
    apt-get update -y
    getTools
    commentRepo
fi

##########################################
# WORDLISTS
##########################################

mkdir WORDLISTS
cd WORDLISTS

echo 'BEGINNING TO INSTALL WORDLIST'
echo '[+] Git cloning seclists in background...'
git clone https://github.com/danielmiessler/SecLists.git &

# enter wordlist repos

cd $CURR_DIR

##########################################
# TOOLS
##########################################

mkdir TOOLS

echo '[+] Installing python3...'
apt-get install python3 &

echo '[+] Installing python2...'
apt-get install python2 &

cd TOOLS

echo 'BEGINNING TO INSTALL TOOLS'

# msfconsole
echo '[+] Installing msfconsole in background...'
git clone https://github.com/rapid7/metasploit-framework &

# bloodhound - post exploitation graph of AD environment
echo '[+] Installing bloodhound in the background...'
git clone https://github.com/BloodHoundAD/BloodHound.git &

# nmap 
echo '[+] Installing nmap...'
git clone https://github.com/nmap/nmap.git

# owasp zap 
echo '[+] Installing owasp zap...'
git clone https://github.com/OWASP/www-project-zap

# fuff
echo '[+] Installing fuff...'
git clone https://github.com/ffuf/ffuf

# dirbuster 
echo '[+] Installing dirbuster...'
git clone https://gitlab.com/kalilinux/packages/dirbuster.git

# gobuster 
echo '[+] Installing gobuster...'
git clone https://github.com/OJ/gobuster.git

# impacket -- enumerate and dump hashes 
echo '[+] Installing impacket...'
git clone https://github.com/SecureAuthCorp/impacket.git

# linpeas/winpeas -- linux/windows priv escalation script
echo '[+] Installing linpeas/winpeas...'
git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git

# aquatone -- vuln scanner produces html w screenshots 
echo '[+] Installing aquatone...'
git clone https://github.com/michenriksen/aquatone.git

# smod - scada pentesting framework using python 2.7
echo '[+] Installing smod...'
git clone https://github.com/trouat/smod.git

# sqlmap 
echo '[+] Installing sqlmap...'
git clone https://github.com/sqlmapproject/sqlmap.git

cd $CURR_DIR

##########################################
# SHELLS
##########################################

mkdir SHELLS
cd SHELLS

echo 'BEGINNING TO INSTALL SCRIPTS'

# nishang
echo '[+] Installing nishang...'
git clone https://github.com/samratashok/nishang.git

echo '[+] Installing php-webshells'
git clone https://github.com/JohnTroony/php-webshells.git

cd $CURR_DIR

echo '[+] Done'