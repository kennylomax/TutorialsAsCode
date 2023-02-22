#!/bin/bash

# The folder in which this journey will be built. You can override this by passing in a directory when you invoke the test
# ./validatejourney.sh <journey>  <optional journey directory>
export MY_JOURNEY_DIR=~/journey/$NOW

### Any environment variables that need personalizing
export AN_EXAMPLE_ENVIRONMENT_VARIABLE=something

# Any adjustements needed if we are running on Linux we can do here..
if [[ "$OSTYPE" == *"darwin"* ]]; then
 echo "$OSTYPE Running on Mac. ..";
else 
  #  For example, if you are downdloading someting in the tutorial with chrome, you would find it at /home/chrome/Downloads, so can set that variable here.
  echo "$OSTYPE Running on Linux/Debian.";
  # If on docker we want to install node ourselves..
  echo "Installing Node";
  apt update
  apt install nodejs -y
  echo "node installed"
fi

echo "Running with:"
echo "AN_EXAMPLE_ENVIRONMENT_VARIABLE: " ${AN_EXAMPLE_ENVIRONMENT_VARIABLE}
echo "MY_JOURNEY_DIR: " ${MY_JOURNEY_DIR}

