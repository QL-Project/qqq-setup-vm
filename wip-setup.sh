#!/usr/bin/env bash
#
# Personal setup for QLauncher
#
# Usage :
# $ curl -fsSL https://raw.githubusercontent.com/Xavier099/qqq-setup/master/setup.sh -o setup.sh && chmod +x setup.sh && sh setup.sh
# or
# $ wget https://raw.githubusercontent.com/Xavier099/qqq-setup/master/setup.sh && chmod +x setup.sh && ./setup.sh
#
# NOTE: Make sure to verify the contents of the script
#       you downloaded matches the contents of setup.sh
#       located at https://github.com/Xavier099/qqq-setup
#       before executing.
#

DIR=$(pwd)
DIR_QL="$DIR/qlauncher"
QLS="$DIR_QL/qlauncher.sh"
QLPKG="app.tar.gz"

list=("curl" "net-tools" "ufw" "wget")
PKG="$DIR/list.txt"
install=$(cat "${PKG}")

redhat () {
    check_list=$(rpm -q "${list[@]}" | grep -e "not installed" | awk 'BEGIN { FS = " " } ; { printf $2" "}' > "${PKG}")
    grep -q '[^[:space:]]' < "${PKG}"
    EMPTY_FILE=$?

    if [[ $EMPTY_FILE -eq 1 ]]; then
       echo "Nothing to do"
    else
       yum install -y $install
    fi
}

ubuntu () {
    apt -qq "$list[@]}" | grep -v "installed" | awk -F/ '{print $1}' > "${PKG}"
    grep -q '[^[:space:]]' < "${PKG}"
    EMPTY_FILE=$?

    if [[ $EMPTY_FILE -eq 1 ]]; then
       echo "Nothing to do"
    else
        apt-get  install -y $install
    fi
}

# i don't know but lets do this
if [[ -d "/etc/redhat-release" ]]; then
   redhat
else
   ubuntu
fi
echo ""

# install docker
echo "Installing docker"
if [[ -e "/usr/bin/docker" ]]; then
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
echo ""
echo "Start docker"
systemctl start docker
echo ""
else
echo "Docker already installed"
fi

# download QLauncher
echo "Create dir QLauncher"
mkdir "$DIR_QL"
echo "Downloading ..."
wget https://github.com/poseidon-network/qlauncher-linux/releases/latest/download/ql-linux.tar.gz -O "$QLPKG"
echo "Extracting QLauncher"
tar -vxzf "$QLPKG" -C "$DIR_QL"
rm "$QLPKG"
echo "Done."
echo ""

# Starting QLauncher
echo "QLauncher start"
"$DIR_QL"/qlauncher.sh start
echo ""

# Setup port
echo "Configure open port for QLauncher (32440 - 32449)"
sudo ufw allow 32440:32449/tcp
sudo ufw allow 22/tcp
echo ""

# automatically run QLauncher
echo "run QLauncher on system startup"
cat > /etc/systemd/system/qlauncher.service << EOF
[Unit]
Description=qlauncher.service
[Service]
Type=simple
ExecStart=$QLS start
ExecStop=$QLS stop
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF
echo "done."
echo ""

# Enable QLauncher as system service
echo "Enable QLauncher as system service"
systemctl daemon-reload
systemctl enable qlauncher
systemctl start qlauncher
echo "done"
echo ""
echo "run ql -h or ql --help"
echo ""

# last step
echo "export QLS=$QLS" >> ~/.bashrc
curl -fsSL https://raw.githubusercontent.com/Xavier099/qqq-setup/master/ql -o /usr/bin/ql
chmod +x /usr/bin/ql
