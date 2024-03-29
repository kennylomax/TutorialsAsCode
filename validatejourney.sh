#!/bin/bash
echo $#
if [ "$#" -le 0 ]; then
  echo "Usage: $0 JOURNEY_NAME <optional: now>" 
  exit 1
fi

export NOW=$( date '+%s000' )

if [ "$#" -ge "2" ]; then
  export NOW=$2
fi

cp journeys/$1/journey.feature journeyvalidator/src/test/java/testing

echo "Checking for existence of ./journeys/"$1"/journeysetup.sh"
if [[ ! -f ./journeys/$1/journeysetup.sh ]] ; then
    echo 'File "./journeys/'$1'/journeysetup.sh" is not found..  aborting.'
    exit
fi

source ./journeys/$1/journeysetup.sh;
mvn test  -f journeyvalidator/pom.xml -Dtest=JourneyTest#runThruTutorial -Dnow=${NOW} -Djourney=$1 -DPath=${PWD} -DfromCmd=999 -DtoCmd=9999
read -p "Run from command:" n1
read -p "Run to command (inclusive) :" n2
echo $n1
echo $n2
mvn test  -f journeyvalidator/pom.xml -Dtest=JourneyTest#runThruTutorial -Dnow=${NOW} -Djourney=$1 -DPath=${PWD} -DfromCmd=$n1 -DtoCmd=$n2 

  # mvn test -f journeyvalidator/pom.xml -Dtest=JourneyTest#runThruTutorial -Djourney=commercecloud1 =${PWD} -DfromCmd=26 
  # mvn clean test -DargLine='-Dkarate.env=docker -Dkarate.options="--tags @preflightChecks"' -Dtest=\!JourneyTest#runThruTutorial  -Dtest=WebRunner
  # mvn clean test -DargLine='-Dkarate.env=docker -Dkarate.options="--tags @ConfirmLittleStickman"' -Dtest=\!JourneyTest#runThruTutorial  -Dtest=WebRunner
  # mvn test -f journeyvalidator/pom.xml -Dtest=JourneyTest#runThruTutorial -Djourney=commercecloud1 -DPath=${PWD} -DfromCmd=0  

