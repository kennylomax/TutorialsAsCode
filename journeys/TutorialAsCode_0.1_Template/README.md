# Tutorials as Code - A minimal template, to serve as an example starting point

This is an example in TutorialsAsCode, to show how they can contain:

- personalized prerequisites
- environment variables
- code samples with respective file names,
- click paths that are implemented by respective Karate Scenarios

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

## Write some node code..

Write some basic node code in the file **$MY_JOURNEY_DIR/mysupercoolwebsite.js** to show a webpage with a button in it. The idea is that the user should click the button, and their name is then shown.

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

Run your website in the background:

```commands
node mysupercoolwebsite.js &
```

## Click the button in the website

Click the button in the website and confirm that you see your name appear.

```clickpath:confirmThatYouSeeYourName
https://localhost:3000 -> ClickMe -> confirmThatYouSeeYourName :)
```

## Stop the node process

Kill the node process that is runnin in the background

```commands
killall -9 node
```

That's it :)