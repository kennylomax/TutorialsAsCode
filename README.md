# Tutorials as Code - Tutorials and End2End Tests in one:

- these journeys serve as demos and tutorials, **and  as end2end tests, that can be executed automatically on Docker and in CICD Pipelines** 
- their particular format makes them followable by humans but also by a computer, meaning they can be run and the journey verified in CICD pipeline.
- when run in Docker/CICD
  - **Karate** features execute the clickpaths 
  - **videos of the clickpaths** are created, for optional inclusion in the respective READMEs.

- The proposal is to have a series of these journey, to  serve as *tutorials*, *demos*, and also as *end-to-end tests* for inclusion in CICD pipelines and onboarding material.

# Current Tutorials are here
  - [Upscale Custom Extension](journeys/upscaleCustomExtension)
  - [Upscale Native Extension](journeys/upscaleNativeExtension)
  - [CCV2 and Spartacus](journeys/commerceCloudSpartacus)

## Options:
  - **To follow those tutorials manually**, simply follow the readmes in those tutorials
  - **To execute the tutorials as end2end tests directly on OSX**:
    - Copy journeys/xx/journeysetupexample.sh to journeys/xx/journeysetup.sh and personalize it, then:
    - ./validatejourney.sh upscaleNativeExtension|upscaleCustomExtension|commercecloud1
  - **To execute the tutorials as end2end tests directly in Docker**
    - source ./journeys/upscaleNativeExtension|upscaleCustomExtension|commercecloud1/journeysetup.sh 
    - docker run --name karate --rm -p 5900:5900 --cap-add=SYS_ADMIN -p 4200:4200 -p 9002:9002 -p 9001:9001 -v $MY_DOWNLOAD_FOLDER:/home/chrome/Downloads -v "$PWD":/src kenlomax/karatejourneys:v1.02
    - open vnc://localhost:5900
    - docker exec -it -w /src karate bash
    - source ./validatejourney.sh upscaleNativeExtension|upscaleCustomExtension|commercecloudSpartacus
    - Videos are generated in the journey folder and can be modified as needed, then dragged into the README

