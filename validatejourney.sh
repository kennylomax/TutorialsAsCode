#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 JOURNEY_NAME" 
  exit 1
fi

cp journeys/$1/journey.feature journeyvalidator/src/test/java/testing
source ./journeys/$1/journeysetup.sh;
mvn test -f journeyvalidator/pom.xml -Dtest=JourneyTest#runThruTutorial -Djourney=$1 -DPath=${PWD} -DfromCmd=999 -DtoCmd=9999
read -p "Run from command: (return for all)" n1
read -p "Run to command : (return for all)" n2
echo $n1
echo $n2
mvn test -f journeyvalidator/pom.xml -Dtest=JourneyTest#runThruTutorial -Djourney=$1 -DPath=${PWD} -DfromCmd=$n1 -DtoCmd=$n2

  # mvn test -f journeyvalidator/pom.xml -Dtest=JourneyTest#runThruTutorial -Djourney=commercecloud1 -DPath=${PWD} -DfromCmd=26 
  # mvn clean test -DargLine='-Dkarate.env=docker -Dkarate.options="--tags @preflightChecks"' -Dtest=\!JourneyTest#runThruTutorial  -Dtest=WebRunner
  # mvn clean test -DargLine='-Dkarate.env=docker -Dkarate.options="--tags @ConfirmLittleStickman"' -Dtest=\!JourneyTest#runThruTutorial  -Dtest=WebRunner
  # mvn test -f journeyvalidator/pom.xml -Dtest=JourneyTest#runThruTutorial -Djourney=commercecloud1 -DPath=${PWD} -DfromCmd=0  

