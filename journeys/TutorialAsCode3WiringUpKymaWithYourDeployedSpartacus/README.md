# Tutorials as Code - Tutorial and End2End Test in One: Spartacus and CCV2
In this journey we:
* Get CCV2 and Spartacus running locally.
* Then deploy to BTP
* Then wire up to Kyma for further fun

## Prerequisites for OSX

- You have CCV2 and Spartacus running locally, and you have personalized and sourced journeysetup.sh, both of which are described in  [TutorialAsCode1: Running CCV2 and Spartacus locally](journeys/TutorialAsCode1LocalCCV2AndSpartacus)
- You have deployed CCV2 and Spartacus to SAP Commerce Cloud as described in [TutorialAsCode2: Deploying CCV2 and Spartacus to Commerce Cloud](journeys/TutorialAsCode2DeployCCV2AndSpartacusToCommerceCloud)

# Journey

## Interacting with Kyma
Under construction....

(More at ) https://developers.sap.com/tutorials/cp-kyma-mocks.html)

Create a System in the SAP BTP which will be used to pair SAP Commerce  to the Kyma runtime. This step will be performed at the Global account level of your SAP BTP account.  Open your global SAP BTP account and choose the System Landscape > Systems menu options.

```clickpath:CreateBTPSystem
https://jsapps.{MY_COMMERCE_CLOUD_DOMAIN}
```

Confirm you can purchase an item from Spartacus. Use visa card number 4444333322221111 (with any other card details).
```clickpath:MakeFirstPurchaseWithVisa4444333322221111
https://jsapps.{MY_COMMERCE_CLOUD_DOMAIN}
```
Choose the Register System option, provide the name commerce-mock, set the type to SAP Commerce Cloud and then choose Register.


Copy the Token value and close the window. This value will expire in five minutes and will be needed in a subsequent step.

If the token expires before use, you can obtain a new one by choosing the Display Token option shown next to the entry in the Systems list.


Create a Formation
In this step, you will create a Formation. A Formation is used to connect one or more Systems created in the SAP BTP to a runtime. This step will be performed at the Global account level of your SAP BTP account.

Within your global SAP BTP account, choose the System Landscape > Formations menu options. Choose the Create Formation option.

Provide a Name, choose your Subaccount where the Kyma runtime is enabled, choose the commerce-mock System. Choose Create.

The pairing process will establish a trust between the Commerce mock application and in this case the SAP Kyma runtime. Once the pairing is complete, the registration of APIs and business events can be performed. This process allow developers to utilize the APIs and business events with the authentication aspects handled automatically.

CCV2 Backoffice → System → API → Destination Target → Default_Template → Wizard → Paste URL
Kyma → Application/Systems → Create Application → CreateBinding → Namespace


CCV2 Backoffice → System → API → Destination Target → Default_Template → Wizard → Paste URL
Kyma → Application/Systems → Create Application → CreateBinding → Namespace

Set up Events

Kyma → Service Management → Catalog → CC Events v1 → Add Once

Kyma → Workloads → Function → Configuration → CreateEventSubscription → <Event>

OrderCreation works, some do not.
