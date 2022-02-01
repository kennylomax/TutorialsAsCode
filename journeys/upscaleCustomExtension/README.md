# Tutorials as Code - Tutorial and End2End Test in One: Upscale Custom Extension

## Background
- these journeys serve as demos, tutorials, **and end2end tests, that can be run automatically on Docker** (for inclusion in CICDs)
- The proposal is to have a series of these journey, to  serve as *tutorials*, *demos*, and also as *end-to-end tests* for inclusion in CICD pipelines and onboarding material.

## Prerequisites for OSX

- install golang: brew install go
- Download the file journeysetupexample.sh to journeysetup.sh and personalize its contents
  - curl https://raw.githubusercontent.com/kennylomax/SelfValidatingJourney/main/journeys/upscaleNativeExtension/journeysetupexample.sh > journeysetup.sh
  - source ./journeysetup.sh

# Journey

Create a website in $MY_JOURNEY_DIR with the following 3 files:
```commands
mkdir -p $MY_JOURNEY_DIR
cd $MY_JOURNEY_DIR
curl https://raw.githubusercontent.com/kennylomax/SelfValidatingJourney/main/journeys/upscaleCustomExtension/material/main.go > main.go
curl https://raw.githubusercontent.com/kennylomax/SelfValidatingJourney/main/journeys/upscaleCustomExtension/material/index.html > index.html
curl https://raw.githubusercontent.com/kennylomax/SelfValidatingJourney/main/journeys/upscaleCustomExtension/material/script.js > script.js
```

Run the server that will listen on port 3000:
```commands
go mod init mymodule
go get -v -u github.com/gorilla/mux
go run main.go &
```

Create a Custom Upscale extension:


```clickpath:CreateCustomExtension
YourUpscaleWorkbenchURL -> Advanced Settings -> Extensions -> + -> Custom component ->
  Name=my-extension${NOW}
  Source URL=http://localhost:3000
  -> Save
``` 



https://user-images.githubusercontent.com/6401254/151970084-e91d060b-90e4-41d1-87f8-2e4c7b15e03f.mp4


Add event bindings



```clickpath:AddEventBindings
YourUpscaleWorkbenchURL -> Advanced Settings -> Extensions -> <your Extension> -> Add event subscription 
  -> Choose event type to subscribe to -> browse_category_click -> Subscribe -> Choose an attribute to map in the event 
    -> category.id -> Add field -> Choose an attribute to map in the event -> category.name -> Add field -> Add event subscription 
  -> Choose event type to subscribe to -> browse_product_click -> Subscribe ->  Choose an attribute to map in the event
    -> product.id -> Add field -> Choose an attribute to map in the event -> product  -> Add field 
  -> Save
YourUpscaleWorkbenchURL -> Experiences -> Coffeefy Mobile Commerce Experience -> Browse -> Component -> Custom 
  ->  Extension ID=<the Extension ID noted in the previous click path>
  -> Show fallback image -> Fallback image URL = https://avatars.githubusercontent.com/u/2531208
  -> Save
``` 


https://user-images.githubusercontent.com/6401254/151970631-34e31436-3882-4abc-9e52-30a627b56813.mp4


Preview And Send Events



```clickpath:@PreviewAndSendEvents
YourUpscaleWorkbenchURL -> Experiences -> Coffeefy Mobile Commerce Experience -> Preview -> Preview -> I Agree -> Coffee Makers -> Drinkware -> Cups -> JURA 65037
```


https://user-images.githubusercontent.com/6401254/151970668-b6139423-b52f-44b8-b211-bce77079a427.mp4


Check for sent events
https://user-images.githubusercontent.com/6401254/150346397-b7fedd6d-a967-4416-a735-78d589250e92.mp4
```clickpath:@CheckForEvents
http://localhost:3000/events -> <Confirm you see Upscale events listed>
```


https://user-images.githubusercontent.com/6401254/151970681-252810e9-3e7f-4635-ae7e-0a0d146b4927.mp4


# Further reading
- [Based on this demo](https://help.sap.com/viewer/0160c41e0de84b218d05bc1185213d1d/SHIP/en-US/f542f9dc2d744b28b471ca6f044d832c.html)
