# Tutorials as Code - Wiring Spartacus up to Kyma

## Prerequisites

* You set up a (free) BTP trial account @[SAP&#39;s BTP (Business Technology Platform) Cockpit](https://account.hanatrial.ondemand.com) 
* Create a subaccount **named trial**, and add the **Kyma runtime  Service Plan** to its list of **Entitlements**
* Enable Kyma runtime in your subaccount
* access your Kyma dashboard from your BTP subaccount.

# Journey

Add a new namespace in Kyma

```clickpath:AddKymaNamespace
KymaCockpit -> Namespaces  -> Create Namespace 
Name={UNIQUEID} 
Enable Sidecar Injection = true
-> Create
```

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

Wait a few minutes, until the System appears in your list of Applications/Systems in Kyma:

```clickpath:ConfirmSystemAppearsInKyma
KymaCockpit -> Integration -> Applications ->  mp-mykymasystem{UNIQUEID}
```

## Pair your SAP Commerce with Kyma

```clickpath:PairBackoffice
BACKOFFICE → System → API → Destination Target → Default_Template → Wizard →
  -> Token URL = <Paste URL that you copied earlier>
  -> New Destination's Id = mykmyasystem{UNIQUEID}
  -> Register Destination Target
```

________________
## APPENDIX is  OPTIONAL
## Creating a Kyma Function

```clickpath:createKymaFunction
Kyma -> < yourNameSpace > -> Workloads -> Functions ->  Create Function -> 
  Name = < yourFunctionName > -> Create -> 
  Configuration -> Create Subscription -> 
  Application name = < your new Application > 
  Event name = order.created 
  Event version = v1 
  -> Create 
```

## Open the function's logs

```clickpath:OpenFunctionLogs
Kyma -> < yourNameSpace > -> Workloads -> Functions ->  <your Function> -> View Logs
```


## Purchase something in Spartacus

```clickpath:MakeFirstPurchaseWithVisa4444333322221111
https://jsapps.{MY_COMMERCE_CLOUD_DOMAIN}...
```


.. and you should see in the function logs, that your function has been invoked
