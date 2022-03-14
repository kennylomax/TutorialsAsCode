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
  Name=UNIQUEID 
-> Create
```

https://user-images.githubusercontent.com/6401254/155689125-d8cb53ce-ef6c-452a-8eee-fe4cc9b31463.mp4

## Create a System on BTP

```clickpath:CreateBTPSystem
https://account.hanatrial.ondemand.com -> Go To Your Trial Account -> System Landscape -> Systems -> Register System -> 
  System Name = mykymasystem
  Type = SAP Commerce Cloud
  -> Register
  -> Copy the token to your clipboard
```

https://user-images.githubusercontent.com/6401254/155689156-5ab4bb67-98ff-463a-9297-6f4675044174.mp4

## Create a Formation on BTP

```clickpath:CreateBTPFormation
https://account.hanatrial.ondemand.com -> Go To Your Trial Account -> System Landscape -> Formations -> Create Formation  -> 
  Name = myformation
  Select Subaccount=trial
  Select Systems = mykymasystem
  -> Create
```

https://user-images.githubusercontent.com/6401254/155516878-0222d239-5245-4e58-aabd-811652d65e56.mp4

Wait a few minutes, until it the System appears in your list of Applications/Systems in Kyma:

```clickpath:ConfirmSystemAppearsInKyma
KymaCockpit -> Integration -> Applications ->  mp-mykymasystem 
```

https://user-images.githubusercontent.com/6401254/155516968-c5b29037-2194-48d2-a878-e7249b3b6a2a.mp4


## Pair your SAP Commerce with Kyma

```clickpath:PairBackoffice
BACKOFFICE → System → API → Destination Target → Default_Template → Wizard →
  -> TOken URL = <Paste URL that you copied earlier>
  -> New Destination's Id = mykmyasystem{UNIQUEID}
  -> Register Destination Target
```
https://user-images.githubusercontent.com/6401254/155705067-9a03b1e6-6722-4394-8d9a-4aa90beba308.mp4

## Creating a binding in Kyma
```clickpath:createKymaBinding
KymaCockpit -> Integration -> Applications → Create Application → CreateBinding → Namespace
```
https://user-images.githubusercontent.com/6401254/155517031-1258aa96-0acf-406e-9d05-a37e3809dcbd.mp4

## Set up Events
```clickpath:setUpEventsInKyma
Kyma → defaultNamespace -> Catalog -> mykymasystem20220314a -> + Add -> Create
```

https://user-images.githubusercontent.com/6401254/155518322-60a9f641-d7fc-45b4-a9a4-24b84b30d233.mp4

## Creating a Kyma Function
```clickpath:createKymaFunction
Kyma -> defaultNamespace -> Workloads -> Functions ->  Create Function -> Create -> 
  Configuration -> Create Event Subscription -> order.created -> Save -> 
  Code ->
    Source = module.exports = { main: function (event, context) { console.log("Hi there"); return "Hello World!";} }
  -> Save
```

https://user-images.githubusercontent.com/6401254/155518857-31d86ac5-d3f3-448e-b5c2-f8dc72c5f248.mp4


## Purchase something in Spartacus
```clickpath:MakeFirstPurchaseWithVisa4444333322221111
https://jsapps.{MY_COMMERCE_CLOUD_DOMAIN}...
```

.. and you should see that your function has been called
