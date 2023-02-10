# Tutorials as Code - A minimal template, to serve as an example starting point

This is an example tutorial, to show how TutorialsAsCode can be used to write tutorials that contains:
- prerequisites that need personalising
- code samples
- environment variables
- click paths
  

## Prerequisites
- You have installed Node (https://nodejs.org/en/download/)

## Set up
Download, personlize then source your journey's setup:

```
curl https://raw.githubusercontent.com/kennylomax/TutorialsAsCode/main/journeys/TutorialAsCode_1.0_LocalCCV2AndSpartacus/journeysetupexample.sh > journeysetup.sh 

.. then personalize its contents and then source it: ..

source journeysetup.sh
```

# Journey

## Create a new folder and initialise a node site 

```commands
mkdir -p $MY_JOURNEY_DIR
cd $MY_JOURNEY_DIR
npm init -y
```

## Code some node..

Code some basic node code in the file **$MY_JOURNEY_DIR/mysupercoolwebsite.js** to show a webpage with a button in:

```file
const http = require("http")
const port = 3000
const server = http.createServer((req, res) => {
 console.log(req.headers)
 res.statusCode = 200
 res.end(" <html><body><button onclick='document.getElementById(`greeting` ).innerText=`$AN_EXAMPLE_ENVIRONMENT_VARIABLE`' >ClickMe</button> <p id='greeting' > </p></body></html> " );
})
server.listen(port)
console.log("Listening on port 3000")
```

## Launch your website

Run your website
```commands
node mysupercoolwebsite.js &
```

## Confirm you can see and click the button in the website, and that the button invokes your API..

```clickpath:confirmThatYouSeeYourName
https://localhost:3000 -> ClickMe -> confirmThatYouSeeYourName :)
```

## Stop the node process

Kill the node process that is runnin in the background
```commands
killall -9 node
```

