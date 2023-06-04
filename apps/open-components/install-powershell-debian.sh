# set -x
# set -e
# # Install system components
# apt update && apt install -y curl gnupg apt-transport-https

# # Save the public repository GPG keys
# curl https://packages.microsoft.com/keys/microsoft.asc | gpg --yes --dearmor --output /usr/share/keyrings/microsoft.gpg

# # Register the Microsoft Product feed
# echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" > /etc/apt/sources.list.d/microsoft.list

# # Install PowerShell
# apt update && apt install -y powershell

wget https://github.com/PowerShell/PowerShell/releases/download/v7.3.4/powershell_7.3.4-1.deb_amd64.deb
dpkg -i ./powershell_7.3.4-1.deb_amd64.deb