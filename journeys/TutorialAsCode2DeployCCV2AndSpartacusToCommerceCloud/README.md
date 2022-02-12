# Tutorials as Code - Tutorial and End2End Test in One: Spartacus and CCV2
In this journey we  deploy to SAP Commerce Cloud and configure Spartacus so we can purchase something.

## Prerequisites for OSX

- You have CCV2 and Spartacus running locally,as described in this  [TutorialAsCode1: Running CCV2 and Spartacus locally](https://github.com/kennylomax/TutorialsAsCode/tree/main/journeys/TutorialAsCode1LocalCCV2AndSpartacus)
- You have a (free) trial account @ https://portal.commerce.ondemand.com/subscription, with an environment in there called "dev". 

# Journey

## Deploy your CCV2 and Spartacus solution to SAP Commerce Cloud

Create a reference to your Github Commerce Cloud Repository from within Commerce Cloud:
```clickpath:CreateCCRepo
https://portal.commerce.ondemand.com -> Repository 
  -> Repository URL = github.com/$MY_GITHUB_USERNAME/concerttours-ccloud
  -> Username = $MY_GITHUB_USERNAME
  -> Token = $MY_GITHUB_TOKEN
  -> Save
```


https://user-images.githubusercontent.com/6401254/153717099-1a72c469-0dbe-453b-aa77-422551c72b01.mp4


Trigger a build of this repository in SAP Commerce Cloud:
```clickpath:TriggerABuild
https://portal.commerce.ondemand.com -> Builds -> Create 
  -> Name = Build${NOW} 
  -> Git Branch or Tag = main
  -> Save
```

https://user-images.githubusercontent.com/6401254/153717152-c68550b8-699c-4534-8f7f-71a22cb79d0e.mp4


On the assumption that this Build was successful...

Deploy the build to your SAP Commerce Cloud "dev" Environment:
```clickpath:DeployBuild
https://portal.commerce.ondemand.com -> Builds -> LatestBuild  ->  Deploy to Environment    
  -> Target Environment = dev 
  -> Data Migration Mode = Initialize database
  -> Deployment Mode = Recreate (fastest, with downtime)
  -> Deploy -> Deploy
```

https://user-images.githubusercontent.com/6401254/153718241-9189418f-0b71-44e9-bb35-b9b2ce44c2d1.mp4

On the assumption that the deployment was successful...

Allow access to the endpoints, and access Spartacus..
```clickpath:AllowAccessToCloudCommerceAndAccessSpartacus
https://portal.commerce.ondemand.com -> Environments 
  -> dev -> Deny all -> Allow all -> Save
  -> API -> Deny all -> Allow all -> Save
  -> Backoffice -> Deny all -> Allow all -> Save
  -> JS Storefront -> Deny all -> Allow all -> Save
  -> Storefront -> Deny all -> Allow all -> Save
  -> JS Storefront URL
```

In the following clickpaths you will find:

* your Backoffice Admin password, 
* your Backoffice URL, which will be of the form https://backoffice.(yourCommerceCloudEnvironmentDomain)/backoffice
* your hac (hybris Administration Console) URL, which will be https://backoffice.(yourCommerceCloudEnvironmentDomain)/hac

and you will open:
* your Backoffice
* your hac

```clickpath:GetAdminPwdAndLoginToBackoffice
https://portal.commerce.ondemand.com ->  Environments -> dev -> API -> view all -> hcs_admin -> Properties -> admin -> Copy to clipboard

<New Browser Tab> -> https://portal.commerce.ondemand.com -> Environments -> dev -> Backoffice URL ->
  -> username = admin
  -> Password = Paste Password from clipboard
  -> Login

<New Browser Tab> -> Backoffice URL with the tail "backoffice/" replaced by "hac/" 
(for example https://backoffice.cqz1m-softwarea1-d57-public.model-t.cc.commerce.ondemand.com/hac) ->
  -> username = admin
  -> Password = Password from clipboard
  -> Login
```


https://user-images.githubusercontent.com/6401254/153720221-8df0d4db-9768-4123-9149-c28eab7cbf65.mov


You should now have 3 browser tabs open:
* "SAP Commerce Cloud", 
* "hybris administration console" and 
* "SAP CX Backoffice"

Set 2 more useful environment variables:
* MY_COMMERCE_CLOUD_DOMAIN to the domain assigned to your backoffice,
* MY_COMMERCE_CLOUD_PASSWORD the admin password you found in the above clickpaths

for example: 
```
export MY_COMMERCE_CLOUD_DOMAIN=cqz1m-softwarea1-d57-public.model-t.cc.commerce.ondemand.com

export MY_COMMERCE_CLOUD_PASSWORD=xxx
```

Set up OCC credentials [(for reasons why see here)](https://sap.github.io/spartacus-docs/installing-sap-commerce-cloud-1905/#configuring-cors). as follows:

Import this impex via the hac (hybris Administration Console):
```clickpath:ImportCorsFilters
https://backoffice/hac/ -> Console -> ImpEx Import  
-> Import content
INSERT_UPDATE OAuthClientDetails;clientId[unique=true]  ;resourceIds   ;scope  ;authorizedGrantTypes  ;authorities   ;clientSecret  ;registeredRedirectUri
  ;client-side  ;hybris  ;basic  ;implicit,client_credentials   ;ROLE_CLIENT   ;secret  ;http://localhost:9001/authorizationserver/oauth2_implicit_callback;
  ;mobile_android   ;hybris  ;basic  ;authorization_code,refresh_token,password,client_credentials  ;ROLE_CLIENT   ;secret  ;http://localhost:9001/authorizationserver/oauth2_callback;
```

Personalize, then add corsfilter properties via the hac (hybris Administration Console):
```clickpath:AddCorsFilterProperties
https://backoffice.{MY_COMMERCE_CLOUD_DOMAIN}/hac/-
-> Platform -> Configuration
-> New key...=corsfilter.ycommercewebservices.allowedOrigin
-> New value...=https://jsapps.{MY_COMMERCE_CLOUD_DOMAIN} 
-> add
-> New key...=corsfilter.ycommercewebservices.allowedMethods
-> New value...=GET HEAD OPTIONS PATCH PUT POST DELETE
-> add
-> New key...=corsfilter.ycommercewebservices.allowedHeaders
-> New value...=origin content-type accept authorization cache-control if-none-match x-anonymous-consents
-> add
```

https://user-images.githubusercontent.com/6401254/153720457-54561ef2-befb-492b-9885-c66b55d4d1a7.mov

## You can now use your deployed Spartacus

Register an account in Spartacus so you can purchase something

```clickpath:RegisterInSpartacus
https://jsapps.{MY_COMMERCE_CLOUD_DOMAIN} -> Sign In / Register -> Register ->
  -> Register yourself
  -> Check both checkboxes
  -> Register
```

Confirm you can purchase an item from Spartacus. Use visa card number 4444333322221111 (with any other card details).
```clickpath:MakeFirstPurchaseWithVisa4444333322221111
https://jsapps.{MY_COMMERCE_CLOUD_DOMAIN} 
  -> DSC-T90 -> Add To Cart -> Proceed To Checkout 
  -> Fill in Shipping Address -> Continue
  -> Fill in Shipping Address -> Continue
  -> Specify Shipping Method -> Continue
  -> Specify payment type as Visa card with number 4444333322221111 -> Continue
  -> Check "I am confirming.." -> Place Order

```
