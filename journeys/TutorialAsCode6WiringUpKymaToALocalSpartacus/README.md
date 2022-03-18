# Tutorials as Code - Wiring Spartacus up to Kyma

# THIS TUTORIAL IS UNDER CONSTRUCTION _ NOT YET READY FOR USE..

This is based on [this great journey](https://wiki.wdf.sap.corp/wiki/display/supc/Wyvern%3A+How+to+integrate+Commerce+and+Kyma+locally) by Darrell Merryweather and the Wyvern Team: 
## Prerequisites 

- You have completed [TutorialAsCode1: Running CCV2 and Spartacus locally](https://github.com/kennylomax/TutorialsAsCode/tree/main/journeys/TutorialAsCode1LocalCCV2AndSpartacus)  and have 
    - a running Commerce Backoffice at https://localhost:9002/backoffice
    - a running Spartacus at https://localhost:4200
- You have downloaded, personalized and sourced the file journeysetupexample.sh:
  - curl https://raw.githubusercontent.com/kennylomax/TutorialsAsCode/main/journeys/TutorialAsCode1WiringUpKymaToALocalSpartacus/journeysetupexample.sh > journeysetup.sh 
  - personalize its contents, 
  - then source it with the command **source journeysetup.sh**
# Journey


## Install K3D
```commands
brew update
brew upgrade
brew install k3d
```

## Install Kyma CLI
```commands
brew install kyma-cli
```

## Install Kyma on K3D
```commands
kyma provision k3d
kyma deploy
```

## Import Kyma's Certificate to your OSX Keychain
```commands
sudo kyma import certs
```

## Create an application in Kyma called commerce
```
cat <<EOF | kubectl apply -n kyma-system -f -
apiVersion: applicationconnector.kyma-project.io/v1alpha1
kind: Application
metadata:
  name: commerce
  labels:
    app: commerce
  annotations: {}
spec:
  accessLabel: commerce
  description: ''
  services: []
EOF
```

## Disable SSL Validation for this new commerce application
```
kubectl get deployment commerce-application-gateway -n kyma-integration -o yaml |\
  sed -e 's|skipVerify=false|skipVerify=true|'| \
  kubectl apply -f -
```

## Restart Kyma Cluster
``` commands
k3d cluster stop kyma
k3d cluster start kyma
```

## Open the Kyma dashbord
``` commands
kyma dashboard
```

# Notify CCV2 of your Kyma Certificate 

- Download the local-kyma-dev certification from your OSX Keychain
- From the directory ./hybris/bin/platform/resources/devcerts, set the keytool command to import this certificate into the cacerts file (ydevelopers.jks) file that SAP Commerce uses:

```
security find-certificate -c local-kyma-dev -p > ~/local-kyma-dev-temp.pem

openssl x509 -outform der -in ~/local-kyma-dev-temp.pem -out ~/local-kyma-dev.cer

cd <??>/hybris/bin/platform/resources/devcerts

keytool -keystore ydevelopers.jks -storepass 123456 -import -file ~/local-kyma-dev.cer -alias local-kyma-dev
````

# Update then start SAP Commerce
```
ant clean all
ant initialize
./hybrisserver.sh start
```
## Monitor Events coming into Kyma
```
kubectl logs -n kyma-system eventing-nats-0
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
