# Tutorials as Code - Tutorials and End2End Tests in one:
- Current Tutorials are:
  - [Running CCV2 and Spartacus locally, then on Commerce Cloud, then with Kyma](journeys/commerceCloudSpartacus)
  - [Upscale Custom Extension](journeys/upscaleCustomExtension)
  - [Upscale Native Extension](journeys/upscaleNativeExtension)
- these journeys serve as demos and tutorials, **and  as end2end tests, that can be executed automatically on Docker and in CICD Pipelines** 
- their particular format makes them followable by humans but also by a computer, meaning they can be run and the journey verified in CICD pipeline.
- when run in Docker/CICD
  - **Karate** features execute the clickpaths 
  - **videos of the clickpaths** are created, for optional inclusion in the respective READMEs.
- The proposal is to have a series of these journey, to  serve as *tutorials*, *demos*, and also as *end-to-end tests* for inclusion in CICD pipelines and onboarding material.

## Options:
  - **To follow those tutorials manually**, simply follow the readmes in those tutorials
  - **To execute the tutorials as end2end tests directly on OSX**:
    - Copy journeys/xx/journeysetupexample.sh to journeys/xx/journeysetup.sh and personalize it, then:
    - ./validatejourney.sh upscaleNativeExtension|upscaleCustomExtension|commercecloudSpartacus
  - **To execute the tutorials as end2end tests directly in Docker**
    - source ./journeys/upscaleNativeExtension|upscaleCustomExtension|commercecloudSpartacus/journeysetup.sh 
    - docker run --name karate --rm -p 5900:5900 --cap-add=SYS_ADMIN -p 4200:4200 -p 9002:9002 -p 9001:9001 -v $MY_DOWNLOAD_FOLDER:/home/chrome/Downloads -v "$PWD":/src kenlomax/karatejourneys:v1.05
    - open vnc://localhost:5900
    - docker exec -it -w /src karate bash
    - source ./validatejourney.sh upscaleNativeExtension | upscaleCustomExtension | commercecloudSpartacus
    - Videos are generated in the journey folder and can be modified as needed, then dragged into the README

## To add a journey ABC, use the existing ones as examples:
  - Add a new folder journeys/ABC
  - Start writing the new tutorial in journeys/ABC/README.md, and embed, as needed,  with
    - **Terminal commands**:
      -  preceed with **\```commands** and end with **\```** 
    - **File contents**:
      - the closest previous bold text is taken as the absolute location of the file being described
      - preceed the file contents with **\```file** and end with **\```**
    - **Environment variables**: 
      - Your README assumes the existence of **environment variables**. Include a neighbouring **journeysetupexample.sh** file that has anonymized/non sensitive data that you and others will use a a basis to create a neighbouring **journeysetup.sh** file that does contain personalized (sensitive) data. At the start of your README you can tell the user to source that file: **source ./journeysetup.sh**  Note the gitignore file ensures ** journeysetup sh** is not pushed to github. 

    - **Clickpaths**:
      - preceed the clickpath with  **\```clickpath:thisClickPathName** and end with  **\```**
      - add a karate scenario in a neighbouring **journey.feature** file, in the format:
```     
@thisClickPathName
Scenario:
"""
Clickpath text Identical to that in the README (otherwise the text validator will deliberately fail)
"""
  * the karate commands that replicate/perform this clickpath
```
  - See the existing journeys and their files as examples
  - At any point you can try out your journey locally on OSX, with the command:
  **./validatejourney.sh yourJourneyFolder**  Once it is working reliably, run on Docker using the commands listed earlier.
  - when your journey runs on docker, videos of the clickpaths can be found in MY_JOURNEY_DIR. You can edit these as appopriate, then drag into your README directly within github, and github will encode and embed that video in the README file.
