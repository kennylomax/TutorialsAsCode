# Tutorials as Code - A minimal template, to serve as an example starting point

This is an example in TutorialsAsCode, to show how they can contain:

- personalized prerequisites
- environment variables
- code samples with respective file names,
- click paths that are implemented by respective Karate Scenarios
- a video of the clickpath(s) as created by running this in Docker (as notated in the main readme)

## Prerequisites

- You have installed Node (https://nodejs.org/en/download/)

## Set up

Download, personlize then source your journey's setup:

```
curl https://raw.githubusercontent.com/kennylomax/TutorialsAsCode/main/journeys/TutorialAsCode_0.1_Template/journeysetupexample.sh > journeysetup.sh 

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

Write some basic node code in the file **$MY_JOURNEY_DIR/mysupercoolwebsite.js** that will show a webpage with a button in it. Replace the text $YOUR_NAME in the code below with the value you assigned to YOUR_NAME in the journeysetup.sh file earlier.  The idea is that the user should click the button, and their name is then shown. 

```file
const http = require("http")
const port = 3000
const server = http.createServer((req, res) => {
 console.log(req.headers)
 res.statusCode = 200
 res.end(" <html><body><button onclick='document.getElementById(`greeting` ).innerText=`$YOUR_NAME`' >ClickMe</button> <p id='greeting' > </p></body></html> " );
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
http://localhost:3000 -> ClickMe -> confirmThatYouSeeYourName :)
```

## Stop the node process

Kill the node process that is runnin in the background

```commands
killall -9 node
```


https://user-images.githubusercontent.com/6401254/218129945-26ee6b58-5282-4061-8d38-afc1afc1d8bf.mp4


That's it :)
