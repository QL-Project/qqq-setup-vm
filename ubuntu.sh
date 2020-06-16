#!/usr/bin/env bash
#
# Personal Ubuntu 18.04 setup for QLauncher
#
# Usage :
# $ curl -fsSL https://raw.githubusercontent.com/Xavier099/qqq-setup/master/setup.sh -o ubuntu.sh && chmod +x ubuntu.sh && ./ubuntu.sh
# or
# $ wget https://raw.githubusercontent.com/Xavier099/qqq-setup/master/ubuntu.sh && chmod +x ubuntu.sh && ./ubuntu.sh
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

function echo () {
    command echo -e "${@}"
}

echo "Install needed package"
sudo apt update
sudo apt install \
         curl \
         docker.io \
         net-tools \
         wget -y

echo
echo "Start docker"
systemctl start docker
echo

# download QLauncher
echo "Create dir QLauncher"
mkdir "$DIR_QL"
echo "Downloading ..."
wget https://github.com/poseidon-network/qlauncher-linux/releases/latest/download/ql-linux.tar.gz -O "$QLPKG"
echo "Extracting QLauncher"
tar -vxzf "$QLPKG" -C "$DIR_QL"
rm "$QLPKG"
echo "Done."
echo

# synology root
echo
sudo mount --make-rshared /
echo

# Starting QLauncher
echo "QLauncher start"
$QLS start
echo

# Setup port
echo "QLauncher need port 433, 32440, 32443, 32446 to be open"
sudo ufw allow 32440/tcp
sudo ufw allow 32443/tcp
sudo ufw allow 32446/tcp
sudo ufw allow 443/tcp
sudo ufw enable < y
echo

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
echo

# Enable QLauncher as system service
echo "Enable QLauncher as system service"
systemctl daemon-reload
systemctl enable qlauncher
systemctl start qlauncher
echo "done"
echo
echo "run ql -h or ql --help"
echo

# last step
echo "export QLS=$QLS" >> ~/.bashrc
curl -fsSL https://raw.githubusercontent.com/Xavier099/qqq-setup/master/ql -o /usr/bin/ql
chmod +x /usr/bin/ql
source ~/.bashrc
