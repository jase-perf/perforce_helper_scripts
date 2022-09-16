#!/bin/bash

set -eux -o pipefail

trap 'catch $? $LINENO' ERR

catch() {
    echo ""
    echo "ERROR CAUGHT!"
    echo ""
    echo "Error code $1 occurred on line $2"
    echo ""
    exit $1
}

# ==================================================================================
#  This script will install Helix Search
# ==================================================================================

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    
    if [[ $OS =~ "Ubuntu" ]]; then
        VER=$VERSION_CODENAME
        wget -qO - https://package.perforce.com/perforce.pubkey | sudo apt-key add -
        echo "deb https://package.perforce.com/apt/ubuntu $VER release" | sudo tee /etc/apt/sources.list.d/perforce.list
        sudo apt-get update && sudo apt-get install -y helix-p4search
    else
        if [[ $OS =~ "Amazon Linux" ]]; then
            VER="7"
        else
            VER=$( echo $VERSION_ID | sed 's/\..\+//' )
        fi
        sudo rpm --import https://package.perforce.com/perforce.pubkey
        echo -e "[perforce]\nname=Perforce\nbaseurl=https://package.perforce.com/yum/rhel/$VER/x86_64\nenabled=1\ngpgcheck=1" | sudo tee /etc/yum.repos.d/perforce.repo
        sudo yum install helix-p4search
    fi
else
    echo "Can't auto-detect version. Follow the instructions at https://www.perforce.com/manuals/p4sag/Content/P4SAG/install.linux.packages.install.html"
fi

