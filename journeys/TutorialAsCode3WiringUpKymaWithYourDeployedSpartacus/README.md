# Tutorials as Code - Wiring Spartacus up to Kyma

## Prerequisites 

- You have completed the previous 2 journeys 
  - [TutorialAsCode1: Running CCV2 and Spartacus locally](https://github.com/kennylomax/TutorialsAsCode/tree/main/journeys/TutorialAsCode1LocalCCV2AndSpartacus) and  
  - [TutorialAsCode2: Deploying CCV2 and Spartacus to Commerce Cloud](https://github.com/kennylomax/TutorialsAsCode/tree/main/journeys/TutorialAsCode2DeployCCV2AndSpartacusToCommerceCloud)
- You have a (free) BTP trial account @ [SAP's BTP (Business Technology Platform) Cockpit](https://account.hanatrial.ondemand.com) and **have enabled Kyma**  on it, and can access your Kyma dashboard via it.
- You have downloaded, personlized and sourced the file journeysetupexample.sh:
  - curl https://raw.githubusercontent.com/kennylomax/TutorialsAsCode/main/journeys/TutorialAsCode3WiringUpKymaWithYourDeployedSpartacus/journeysetupexample.sh > journeysetup.sh 
  - personalize its contents, 
  - then source it with the command **source journeysetup.sh**
# Journey Under construction....
This is based on [this cool tutorial](https://developers.sap.com/tutorials/cp-kyma-mocks.html)


Add a new namespace in Kyma 
```clickpath:AddKymaNamespace
KYMA_COCKPIT -> Add new namespace ->
  name=mykymanamespace
```



## Create a System on BTP

```clickpath:CreateBTPSystem
https://account.hanatrial.ondemand.com -> Go To Your Trial Account -> System Landscape -> Systems -> Register System -> 
  System Name = Something
  Type = SAP Commerce Cloud
  -> Register
  -> Copy the token to your clipboard
```

https://user-images.githubusercontent.com/6401254/155512005-1a67afb7-9222-4359-bcf3-67d67274b13a.mp4




Copy the Token value 

## Create a Formation on BTP

```clickpath:CreateBTPFormation
https://account.hanatrial.ondemand.com -> Go To Your Trial Account -> System Landscape -> Formations -> Create Formation  -> 
  Name = $(NOW) 
  Select Subaccount=trial
  Select Systems = mykymasystem
  -> Create
```

https://user-images.githubusercontent.com/6401254/155512311-1a7b1127-7b21-4f87-ba72-2a3e5fc4775b.mov


Wait a few minutes, until it the System appears in your list of Applications/Systems in Kyma:

```clickpath:ConfirmSystemAppearsInKyma
KYMA_COCKPIT -> Integration -> Applications/Systems ->  mp-mykymasystem 
```

## Pair your SAP Commerce with Kyma

```clickpath:PairBackoffice
BACKOFFICE → System → API → Destination Target → Default_Template → Wizard → Paste URL
```



https://user-images.githubusercontent.com/6401254/155512477-a3f409a3-440c-42dd-8f0d-67340a8c030b.mov


## Creating a binding in Kyma
```clickpath:createKymaBinding
Kyma → Application/Systems → Create Application → CreateBinding → Namespace
```
https://user-images.githubusercontent.com/6401254/155512498-1c21fbf9-94de-42ef-9ee9-74a4a682f858.mov



## Set up Events
```clickpath:setUpEventsInKyma
Kyma → defaultNamespace -> Catalog -> mykymasystem -> CC Events v1 -> + Add -> Create
```

https://user-images.githubusercontent.com/6401254/155512518-902bfab0-a77d-440c-9799-c547bc9e6928.mov




## Creating a Kyma Function
```clickpath:createKymaFunction
Kyma -> defaultNamespace -> Workloads -> Functions ->  Create Function -> Create -> 
  Configuration -> Create Event Subscription -> order.created -> Save -> 
  Code ->
    Source = module.exports = { main: function (event, context) { console.log("Hi there"); return "Hello World!";} }
  -> Save
```
https://user-images.githubusercontent.com/6401254/155512532-be843808-4144-4494-9c28-94338a0136ba.mov

## Purchase something in Spartacus
.. and you should see that your function has been called
