# Tutorials as Code - Wiring Spartacus up to Kyma

# THIS TUTORIAL IS UNDER CONSTRUCTION _ NOT YET READY FOR USE..
## Prerequisites 

- You have completed the previous journey
  - [TutorialAsCode1: Running CCV2 and Spartacus locally](https://github.com/kennylomax/TutorialsAsCode/tree/main/journeys/TutorialAsCode1LocalCCV2AndSpartacus)  and have 
    - a running Commerce Backoffice at https://localhost:9002/backoffice
    - a running Spartacus at https://localhost:4200
- You have a (free) BTP trial account on [SAP's BTP (Business Technology Platform) Cockpit](https://account.hanatrial.ondemand.com) and **have enabled Kyma**  on it, and can access your Kyma dashboard via it.
- You have opened a tunnel to your Commerce backoffice with [ngrok](https://ngrok.com/download): 
  - download [ngrok](https://ngrok.com/download) 
  - run the command **ngrok tls 9002** to open an https tunnel to your Commerce, 
  - identify the URL the ngrok has activated (it should be something like **tls://xxx.ngrok.io** )
  - assign the URL that ngrok has activated to the TUNNEL variable in your  **journeysetup.sh** file, with an https prefix, so something like **https://xxx.ngrok.io**
- You have downloaded, personalized and sourced the file journeysetupexample.sh:
  - curl https://raw.githubusercontent.com/kennylomax/TutorialsAsCode/main/journeys/TutorialAsCode1WiringUpKymaToALocalSpartacus/journeysetupexample.sh > journeysetup.sh 
  - personalize its contents, 
  - then source it with the command **source journeysetup.sh**
# Journey


## Create a System on BTP

```clickpath:CreateBTPSystem
BTP_COCKPIT -> Go To Your Trial Account -> System Landscape -> Systems -> Register System -> 
  System Name = mykymasystem
  Type = SAP Commerce Cloud
  -> Register
  -> Copy the token to your clipboard
```


## Create a Formation on BTP

```clickpath:CreateBTPFormation
BTP_COCKPIT -> Go To Your Trial Account -> System Landscape -> Formations -> Create Formation  -> 
  Name = myformation{UNIQUEID}
  Select Subaccount=trial
  Select Systems = mykymasystem{UNIQUEID}
  -> Create
```


Wait a few minutes, until it the System appears in your list of Applications/Systems in Kyma:

```clickpath:ConfirmSystemAppearsInKyma
KymaCockpit -> Integration -> Applications ->  mp-mykymasystem{UNIQUEID}
```


## Pair your SAP Commerce with Kyma

```clickpath:PairBackoffice
BACKOFFICE → System → API → Destination Target → Default_Template → Wizard →
  -> TOken URL = <Paste URL that you copied earlier>
  -> New Destination's Id = mykmyasystem{UNIQUEID}
  -> Register Destination Target
```

## Creating a binding in Kyma
```clickpath:createKymaBinding
KymaCockpit -> Integration -> Applications → Create Application → CreateBinding → Namespace
```

## Set up Events
```clickpath:setUpEventsInKyma
Kyma → defaultNamespace -> Catalog -> mykymasystem20220314a -> + Add -> Create
```


## Creating a Kyma Function
```clickpath:createKymaFunction
Kyma -> defaultNamespace -> Workloads -> Functions ->  Create Function -> Create -> 
  Configuration -> Create Event Subscription -> order.created -> Save -> 
  Code ->
    Source = module.exports = { main: function (event, context) { console.log("Hi there"); return "Hello World!";} }
  -> Save
```


## Purchase something in Spartacus
```clickpath:MakeFirstPurchaseWithVisa4444333322221111
https://jsapps.{MY_COMMERCE_CLOUD_DOMAIN}...
```

.. and you should see that your function has been called
