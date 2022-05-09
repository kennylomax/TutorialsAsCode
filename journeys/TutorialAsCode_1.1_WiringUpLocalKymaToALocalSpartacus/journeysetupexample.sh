#!/bin/bash
export MY_JOURNEY_DIR=~/journey/$NOW

if docker info | grep "Cannot"; then
   echo "Looks like Docker is not running.."
   exit
fi

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