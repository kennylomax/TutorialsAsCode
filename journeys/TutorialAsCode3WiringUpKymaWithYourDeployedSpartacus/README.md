# Tutorials as Code - Wiring Spartacus up to Kyma

## Prerequisites 

- You have completed the previous 2 journeys 
  - [TutorialAsCode1: Running CCV2 and Spartacus locally](https://github.com/kennylomax/TutorialsAsCode/tree/main/journeys/TutorialAsCode1LocalCCV2AndSpartacus) and  
  - [TutorialAsCode2: Deploying CCV2 and Spartacus to Commerce Cloud](https://github.com/kennylomax/TutorialsAsCode/tree/main/journeys/TutorialAsCode2DeployCCV2AndSpartacusToCommerceCloud)
- You have a (free) BTP trial account @ [SAP's BTP (Business Technology Platform) Cockpit](https://account.hanatrial.ondemand.com) and **have enabled Kyma**  on it, and can access your Kyma dashboard via it.
- You have downloaded, personalized and sourced the file journeysetupexample.sh:
  - curl https://raw.githubusercontent.com/kennylomax/TutorialsAsCode/main/journeys/TutorialAsCode3WiringUpKymaWithYourDeployedSpartacus/journeysetupexample.sh > journeysetup.sh 
  - personalize its contents, 
  - then source it with the command **source journeysetup.sh**
 - This takes inspiration from [this cool tutorial](https://developers.sap.com/tutorials/cp-kyma-mocks.html), which you might want to read first.
# Journey

## !!Kyma Cockpit has had breaking changes, so this journey needs updating...#


Add a new namespace in Kyma 
```clickpath:AddKymaNamespace
KymaCockpit -> Namespaces  -> Create Namespace 
  Name={UNIQUEID} 
-> Create
```

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
