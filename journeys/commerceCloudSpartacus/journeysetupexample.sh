#!/bin/bash

export MY_DOWNLOAD_FOLDER=/Users/xx/Downloads
export MY_GITHUB_USERNAME=xx
# Token with repo and write:packages permissions
export MY_GITHUB_TOKEN=xx
export MY_GITHUB_EMAIL=xx
export NOW=$( date '+%s000' )
export MY_JOURNEY_DIR=~/journey/$NOW

# Set to the version you are downlading
export SAP_COMMERCE=CXCOMM201100P_15-70005693

git config --global user.name "$MY_GITHUB_USERNAME"
git config --global user.password "$MY_GITHUB_TOKEN"
git config --global user.email "$MY_GITHUB_EMAIL"

if [[ "$OSTYPE" == *"darwin"* ]]; then
 echo "$OSTYPE Running on Mac. ..";
else
  export MY_DOWNLOAD_FOLDER=/home/chrome/Downloads
  echo "$OSTYPE Running on Linux/Debian.";
  echo "Intsalling Node, NPM6.11.0 and Yarn";
  apt update
  apt install nodejs -y
  curl -L https://www.npmjs.com/install.sh | sh
  npm install -g npm@6.11.0
  echo y | npm install 
  npm install -g yarn
fi
