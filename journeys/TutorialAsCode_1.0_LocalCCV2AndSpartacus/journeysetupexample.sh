#!/bin/bash
### Personalize these
export MY_DOWNLOAD_FOLDER=/Users/xxx/Downloads
export MY_GITHUB_USERNAME=xxx
# Token with repo and write:packages permissions
export MY_GITHUB_TOKEN=xxx
export MY_GITHUB_EMAIL=xxx
# The version you are downloading
export SAP_COMMERCE=CXCOMM210500P_8-70005661
export MY_JOURNEY_DIR=~/journey/$NOW
### End of Personalize these


git config --global user.name "$MY_GITHUB_USERNAME"
git config --global user.password "$MY_GITHUB_TOKEN"
git config --global user.email "$MY_GITHUB_EMAIL"

if type -p java; then
    echo found java executable in PATH
    _java=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
    echo found java executable in JAVA_HOME     
    _java="$JAVA_HOME/bin/java"
else
    echo "no java"
fi

if [[ "$_java" ]]; then
    version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo version "$version"
    if [[ "$version" == *"11."*  ]]; then
        echo java version 11 detected
    else         
        echo You need java version 11; 
        exit
    fi
fi

if [[ "$OSTYPE" == *"darwin"* ]]; then
 echo "$OSTYPE Running on Mac. ..";
else 
  export MY_DOWNLOAD_FOLDER=/home/chrome/Downloads
  echo "$OSTYPE Running on Linux/Debian.";
  echo "Installing Node, NPM6.11.0 and Yarn";
  apt update
  apt install nodejs -y
  curl -L https://www.npmjs.com/install.sh | sh
  npm install -g npm@6.11.0
  echo y | npm install 
  npm install -g yarn
fi