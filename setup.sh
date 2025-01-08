#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo"
  exit 1
fi

# Update the package index
echo "Updating package index..."
apt-get update -y

# Install prerequisites
echo "Installing prerequisites..."
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add Docker's official GPG key
echo "Adding Docker's official GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository
echo "Setting up the Docker repository..."
echo \  \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package index again
apt-get update -y

# Install Docker
echo "Installing Docker..."
apt-get install -y docker-ce docker-ce-cli containerd.io

# Verify Docker installation
if docker --version >/dev/null 2>&1; then
  echo "Docker installed successfully: $(docker --version)"
else
  echo "Docker installation failed."
  exit 1
fi

# Optional: Add the current user to the docker group (to run docker without sudo)
read -p "Do you want to add the current user to the Docker group? (y/n): " add_user
if [ "$add_user" = "y" ]; then
  usermod -aG docker $USER
  echo "User $USER added to the Docker group. Log out and back in to apply changes."
fi


sudo apt install certbot
sudo apt install python3-certbot-nginx
# sudo certbot --nginx -d react.switzerlandnorth.cloudapp.azure.com
