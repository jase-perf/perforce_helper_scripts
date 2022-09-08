# ==================================================================================
#  This script will setup Ubuntu, RHEL, or Centos instances to install P4 Packages
# ==================================================================================

if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    
    if [[ $OS =~ "Ubuntu" ]]; then
        VER=$VERSION_CODENAME
        wget -qO - https://package.perforce.com/perforce.pubkey | sudo apt-key add -
        echo "deb http://package.perforce.com/apt/ubuntu $VER release" > /etc/apt/sources.list.d/perforce.list
        apt-get update
        apt-get install -y helix-cli helix-proxy
    else
        VER=$( echo $VERSION_ID | sed 's/\..\+//' )
        sudo rpm --import https://package.perforce.com/perforce.pubkey
        echo -e "[perforce]\nname=Perforce\nbaseurl=http://package.perforce.com/yum/rhel/$VERSION_ID/x86_64\nenabled=1\ngpgcheck=1" > /etc/yum.repos.d/perforce.repo
        sudo yum install -y helix-cli helix-proxy
    fi
else
    echo "Can't auto-detect version. Follow the instructions at https://www.perforce.com/manuals/p4sag/Content/P4SAG/install.linux.packages.install.html"
fi