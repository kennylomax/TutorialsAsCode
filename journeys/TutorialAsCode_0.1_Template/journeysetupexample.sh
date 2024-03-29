#!/bin/bash

# The folder in which this journey will be built.
export MY_JOURNEY_DIR=~/journey/$NOW
# Note you can override this by passing in a directory when you invoke the test later. 

# Example Environment variables that need personalizing 
export YOUR_NAME="Your Name"

# For automatic execuatons, we can handle any adjustments here..
if [[ "$OSTYPE" == *"darwin"* ]]; then
 echo "$OSTYPE Running on Mac. ..";
else 
  #  For example, if you are downdloading something in the tutorial with chrome, you would find it at /home/chrome/Downloads, so can set that variable here.
  echo "$OSTYPE Running on Linux/Debian.";
  # If on docker we want to install node ourselves..
  echo "Installing Node";
  apt update
  apt install nodejs -y
  echo "node installed"
fi

echo "Running with:"
echo "YOUR_NAME: " ${YOUR_NAME}
echo "MY_JOURNEY_DIR: " ${MY_JOURNEY_DIR}

