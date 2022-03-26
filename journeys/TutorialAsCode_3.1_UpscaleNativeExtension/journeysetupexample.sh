#!/bin/bash

echo "Running journeysetup.sh: setting up env variables.."

#####################
# Personalize these to your environment
#####################
export MY_UPSCALE_WORKBENCH=xx
export MY_UPSCALE_EMAIL=xx
export MY_UPSCALE_PASSWORD=xx
export MY_GITHUB_USERNAME=xx
export MY_GITHUB_EMAIL=xx
# Token to your (new?) github repo that you will be pushing to, with repo and write:packages permissions
export MY_GITHUB_TOKEN=xx
export MY_DOWNLOAD_FOLDER=xx
export MY_JOURNEY_DIR=~/journey/$NOW


#####################
#Leave these alone, unless you know what you are doing :)
#####################

git config --global user.name "$MY_GITHUB_USERNAME"
git config --global user.password "$MY_GITHUB_TOKEN"
git config --global user.email "$MY_GITHUB_EMAIL"

echo "MY_UPSCALE_WORKBENCH=$MY_UPSCALE_WORKBENCH"
echo "MY_UPSCALE_EMAIL=$MY_UPSCALE_EMAIL"
echo "MY_UPSCALE_PASSWORD=$MY_UPSCALE_PASSWORD" 
echo "MY_GITHUB_USERNAME=$MY_GITHUB_USERNAME"
echo "MY_GITHUB_TOKEN=$MY_GITHUB_TOKEN"
echo "MY_GITHUB_EMAIL=$MY_GITHUB_EMAIL"
echo "MY_DOWNLOAD_FOLDER=$MY_DOWNLOAD_FOLDER" 


if [[ "$OSTYPE" == *"darwin"* ]]; then
  echo "Running on Mac. Assuming node and npm installed..";
else
  echo "Running on Debian. Installing node and npm..";
  export MY_DOWNLOAD_FOLDER=/home/chrome/Downloads
  apt-get update    
  # See https://linuxize.com/post/how-to-install-node-js-on-debian-10/
  curl -sL https://deb.nodesource.com/setup_12.x |  bash -
  apt-get install -y nodejs
  npm install pm2 -g 
  echo N | /usr/bin/npm install -g @angular/cli@12.2.10
  # Need to create and write-enable the downloads folder, otherwise chrome will ask for location during download..
  mkdir -p /home/chrome/Downloads
	chmod 777 /home; chmod 777 /home/chrome; chmod 777 /home/chrome/Downloads 
fi