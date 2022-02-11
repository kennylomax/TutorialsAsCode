const expectedOrigin = "https://previewer.stage-use1.js-stage.shoot.live.k8s-hana.ondemand.com/en-US";

window.addEventListener(
  "message",
  event => { handleEvent(JSON.stringify(event.data))  },
  false
)

sendStartupEvents();

// required startup events to notify the consumer app of readiness and preferred iframe size
function sendStartupEvents() {
    let initEvent = { type: "initialized" , data: null};
    this.sendMessage(initEvent);
    
    let sizeEvent = { type: "sizeChange", data: { height: 400}} 
    this.sendMessage(sizeEvent);
}

function sendMessage(event) {
    if (window.parent !== window)      // web
        window.parent.postMessage(event, expectedOrigin);
    else if (((window).Android)) // android
        ((window).Android).sendMessage(JSON.stringify(event));
    else if ((window).webkit && (window).webkit.messageHandlers && (window).webkit.messageHandlers.upscaleHandler)  // ios
        (window).webkit.messageHandlers.upscaleHandler.postMessage(JSON.stringify(event));
    else 
        console.log("no send method detected");
}

function handleEvent(d){
    fetch('http://localhost:3000/event', {
        method: 'POST',
        body: '{"data":'+d+'}'
      })
      .then(response => response.json())
      .then(data => document.getElementById('data').innerHTML = JSON.stringify(data));
}
