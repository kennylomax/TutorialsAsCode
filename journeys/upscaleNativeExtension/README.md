# Tutorials as Code - Tutorial and End2End Test in One.. Native Upscale Extension

## Background
- these journeys serve as demos, tutorials, **and end2end tests, that can be run automatically on Docker** (for inclusion in CICDs)
- The proposal is to have a series of these journey, to  serve as *tutorials*, *demos*, and also as *end-to-end tests* for inclusion in CICD pipelines and onboarding material.
- based on [Adriaan's Upscale Demo](https://performancemanager.successfactors.eu/sf/learning?destUrl=https%3a%2f%2fsaplearninghub%2eplateau%2ecom%2flearning%2fuser%2fdeeplink%5fredirect%2ejsp%3flinkId%3dONLINE%5fCONTENT%5fSTRUCTURE%26componentID%3dPSD%5fWEB%5f20955%5fEN%26componentTypeID%3dEXPERT%5fLED%26revisionDate%3d1631693160000%26fromSF%3dY&company=learninghub).

## Prerequisites for OSX
- intall brew, 
- node: brew install node@12,
- ng: brew install angular-cli
- pm2: npm install pm2 -g
- mvn: brew install mvn
- Download the file journeysetupexample.sh to journeysetup.sh and personalize its contents:
  - curl https://raw.githubusercontent.com/kennylomax/SelfValidatingJourney/main/journeys/upscaleNativeExtension/journeysetupexample.sh > journeysetup.sh 
  - source ./journeysetup.sh 

# Journey

Create an Angular app and within that an Angular library:
```commands
mkdir -p $MY_JOURNEY_DIR
cd $MY_JOURNEY_DIR
ng new hello-world${NOW} --create-application=false
cd hello-world${NOW}
ng generate library my-first-native-extension
pushd $MY_DOWNLOAD_FOLDER
rm -f application-pwa*.zip
popd

```

Download the latest Upscale PWA Libraries from the Upscale Workbench:
```clickpath:download_PWA
YourUpscaleWorkbenchURL -> Consumer Applications -> PWA -> Edit application configuration -> Save & download project
```

https://user-images.githubusercontent.com/6401254/151949229-98fa20de-7676-46e9-b7b3-cd0bc1bf067a.mp4

| Clickpath | Screengrab |
| ------ | ------ |
| YourUpscaleWorkbenchURL -> Consumer Applications -> PWA -> Edit application configuration -> Save & download project | https://user-images.githubusercontent.com/6401254/146175213-1e9cbd06-63e5-44c5-8d73-3ecced3aef19.mp4 |


Copy the downloaded libs into your Angular app, which include a thin client SDK, that the PWA uses to access APIs, and the web storefront SDK.

```commands
cp $MY_DOWNLOAD_FOLDER/application-pwa.zip $MY_JOURNEY_DIR
cd $MY_JOURNEY_DIR 
unzip application-pwa.zip 
cp -R caas2-webapp/libs  hello-world${NOW}
cd hello-world${NOW}
npm install --save-dev ./libs/upscale-service-client-angular-0.10*.tgz 
npm install --save-dev ./libs/upscale-web-storefront-sdk-0.0.1-BETA.*.tgz 
```

Reduce the compilation requirements to avoid compilation errors:

```commands
sed -i -e 's/"inlineSources": true,/"inlineSources": true, "strictNullChecks":false,"noImplicitAny":false,/g' projects/my-first-native-extension/tsconfig.lib.json 
```

Adjust/Create 2 new files:
```commands 
curl https://raw.githubusercontent.com/kennylomax/SelfValidatingJourney/main/journeys/upscaleNativeExtension/my-first-native-extension.component.ts > projects/my-first-native-extension/src/lib/my-first-native-extension.component.ts
curl https://raw.githubusercontent.com/kennylomax/SelfValidatingJourney/main/journeys/upscaleNativeExtension/my-first-native-extension.module.ts > projects/my-first-native-extension/src/lib/my-first-native-extension.module.ts
``` 
 
Build and package:

```commands 
npm install --save form-data
ng build --configuration production
npm pack ./dist/my-first-native-extension
``` 

Check into github:

```commands 
curl --user "$MY_GITHUB_USERNAME:$MY_GITHUB_TOKEN" -X POST https://api.github.com/user/repos -d '{"name": "my-first-native-extension'"$NOW"'", "public": "true"}'
rm -rf .git
git init
git add my-first-native-extension-0.0.1.tgz README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://${MY_GITHUB_USERNAME}:${MY_GITHUB_TOKEN}@github.com/${MY_GITHUB_USERNAME}/my-first-native-extension${NOW}.git
git push -u origin main
``` 

Add an Upscale extension and then add to an experience:

```clickpath:CreateExtensionAndExperience
YourUpscaleWorkbenchURL -> Advanced Settings -> Extensions -> + -> PWA Native Extension (beta) ->
  Extension name=my-first-native-extension${NOW}
  Key=<the name attribute in your hello-world${NOW}/package.json>
  Location=https://raw.githubusercontent.com/$MY_GITHUB_USERNAME/my-first-native-extension${NOW}/main/my-first-native-extension-0.0.1.tgz
  -> <Take a note of the Extension ID>
  -> Save

YourUpscaleWorkbenchURL -> Experiences -> Coffeefy Mobile Commerce Experience -> Account -> Component + -> Custom ->
  Extension ID=<the Extension ID noted in the previous click path>
  PWA Native Extension Component (beta)=<the name used in your registration hello-world${NOW}/projects/my-first-native-extension/src/lib/my-first-native-extension.module.ts>
  -> Save
``` 
https://user-images.githubusercontent.com/6401254/146175247-36879bd8-3330-404d-8658-f08afd2ddabb.mp4


Remove the previousy downloaded PWA:

```commands
pushd $MY_DOWNLOAD_FOLDER
rm -f application-pwa*.zip  
popd

```

Include your new extension in your PWA, then download it:
```clickpath:DownloadNewPWA
YourUpscaleWorkbenchURL -> Settings -> Consumer Applications -> PWA -> Edit Application Configuration -> 
Link experience=Coffeefy Mobile Commerce Experience 
Extensions=NG Coffeefy styling, MyFirstExtension${NOW} 
-> Save & download project
```
https://user-images.githubusercontent.com/6401254/146175285-30d5266a-a426-4161-a620-9c9e59eb6171.mp4


Compile and run your new PWA
(note on linux we currently also need to run the  command "npm run postinstall" ourselves, as the install cannot run it itself)
```commands 
pushd $MY_DOWNLOAD_FOLDER
unzip -o application-pwa.zip 
cd caas2-webapp
npm install -y
npm run postinstall
pm2 --name MyUpscaleExtension start npm -- start
``` 
Access your site at http://localhost:4200/ and confirm the stick man is there.

```clickpath:ConfirmLittleStickman
localhost:4200 -> Account -> confirmYouSeeYourLittleStickMan :)
``` 
