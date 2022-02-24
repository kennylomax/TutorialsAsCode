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



https://user-images.githubusercontent.com/6401254/155516810-53c7cb7d-6cda-4cd8-896c-67fd5ec11b85.mp4



## Create a System on BTP

```clickpath:CreateBTPSystem
https://account.hanatrial.ondemand.com -> Go To Your Trial Account -> System Landscape -> Systems -> Register System -> 
  System Name = mykymasystem
  Type = SAP Commerce Cloud
  -> Register
  -> Copy the token to your clipboard
```

https://user-images.githubusercontent.com/6401254/155516849-ac36f2ac-3a3b-44d6-8f89-e0d6eb2f4668.mp4

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
KYMA_COCKPIT -> Integration -> Applications/Systems ->  mp-mykymasystem 
```


https://user-images.githubusercontent.com/6401254/155516968-c5b29037-2194-48d2-a878-e7249b3b6a2a.mp4


## Pair your SAP Commerce with Kyma

```clickpath:PairBackoffice
BACKOFFICE → System → API → Destination Target → Default_Template → Wizard → Paste URL
```

https://user-images.githubusercontent.com/6401254/155516989-8d66671c-a071-4c0b-b450-d6dea5ef47cd.mp4



## Creating a binding in Kyma
```clickpath:createKymaBinding
Kyma → Application/Systems → mp-mykymaststem → CreateBinding → Namespace
```
https://user-images.githubusercontent.com/6401254/155517031-1258aa96-0acf-406e-9d05-a37e3809dcbd.mp4


## Set up Events
```clickpath:setUpEventsInKyma
Kyma → defaultNamespace -> Catalog -> mykymasystem -> CC Events v1 -> + Add -> Create
```





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
