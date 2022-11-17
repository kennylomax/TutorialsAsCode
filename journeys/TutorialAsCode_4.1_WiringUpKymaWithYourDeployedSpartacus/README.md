# Tutorials as Code - Wiring Spartacus up to Kyma

## Prerequisites

* You set up a (free) BTP trial account @[SAP&#39;s BTP (Business Technology Platform) Cockpit](https://account.hanatrial.ondemand.com) 
* you enable Kyma in your BTP trial account
* you can access your Kyma dashboard via your BTP trial account.

# Journey

Add a new namespace in Kyma

```clickpath:AddKymaNamespace
KymaCockpit -> Namespaces  -> Create Namespace 
Name={UNIQUEID} 
Enable Sidecar Injection = true
-> Create
```

https://user-images.githubusercontent.com/6401254/158362790-23ee4170-eaa9-40f3-90c8-21397804a21f.mp4

## Create a System on BTP

```clickpath:CreateBTPSystem
BTP_COCKPIT -> Go To Your Trial Account -> System Landscape -> Systems -> Add System -> 
  System Name = mykymasystem{UNIQUEID}
  Type = SAP Commerce Cloud
  -> Add
  -> Get Token
  -> Copy the token to your clipboard
  
```

Wait a minute for the Kyma system to be setup.  

https://user-images.githubusercontent.com/6401254/158362823-a1c5098d-cbe4-4af0-a373-47f38dd30c5a.mp4

## Create a Formation on BTP

```clickpath:CreateBTPFormation
BTP_COCKPIT -> Go To Your Trial Account -> System Landscape -> Formations -> Create Formation  -> 
  Formation Name = myformation{UNIQUEID}
  Formation Type = Side-by-side extensibility with Kyma
  Select Subaccount=trial
  Include System = mykymasystem{UNIQUEID}.  (If you do not see it wait a few minutes and repeat)
  -> Next Step 
  -> Create
```

https://user-images.githubusercontent.com/6401254/158362859-916caa9c-d666-4544-84c2-aabfa28bc571.mp4

Wait a few minutes, until the System appears in your list of Applications/Systems in Kyma:

```clickpath:ConfirmSystemAppearsInKyma
KymaCockpit -> Integration -> Applications ->  mp-mykymasystem{UNIQUEID}
```

https://user-images.githubusercontent.com/6401254/158362894-43040579-f30f-4927-afc6-d6f0e5af93ca.mp4

## Pair your SAP Commerce with Kyma

```clickpath:PairBackoffice
BACKOFFICE → System → API → Destination Target → Default_Template → Wizard →
  -> Token URL = <Paste URL that you copied earlier>
  -> New Destination's Id = mykmyasystem{UNIQUEID}
  -> Register Destination Target
```

https://user-images.githubusercontent.com/6401254/158362912-85af36b7-85d0-43fb-888f-c078895faeb9.mp4

## Creating a Kyma Function

```clickpath:createKymaFunction
Kyma -> defaultNamespace -> Workloads -> Functions ->  Create Function -> Create -> 
  Configuration -> Create Event Subscription -> order.created -> Save -> 
  Code ->
    Source = module.exports = { main: function (event, context) { console.log("Hi there"); return "Hello World!";} }
  -> Save
```

https://user-images.githubusercontent.com/6401254/158363245-a0a66714-820c-4e1d-9bf6-27a47fa8c221.mov

## Purchase something in Spartacus

```clickpath:MakeFirstPurchaseWithVisa4444333322221111
https://jsapps.{MY_COMMERCE_CLOUD_DOMAIN}...
```

.. and you should see that your function has been called
