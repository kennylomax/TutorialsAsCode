# Tutorials as Code - Wiring Spartacus up to Kyma

This is based on [this great journey](https://wiki.wdf.sap.corp/wiki/display/supc/Wyvern%3A+How+to+integrate+Commerce+and+Kyma+locally) by Darrell Merryweather and the Wyvern Team. It is tested on Mac OSX.

Last tested manually 20220516
Last tested automatically 20220416

## Prerequisites

- You have completed [TutorialAsCode1: Running CCV2 and Spartacus locally](https://github.com/kennylomax/TutorialsAsCode/tree/main/journeys/TutorialAsCode_1.0_LocalCCV2AndSpartacus)  where you had
  - a running Commerce  at https://localhost:9002
  - a running Spartacus at https://localhost:4200
  - and have stopped them again (use ./hybrisserver.sh stop to stop Commerce, and ctrl-c from your yarn start command)
- You have Docker running
- Use[ JDK  17.x.x](https://www.oracle.com/java/technologies/downloads/#java17). To switch java versions on a Mac, see[ here](https://medium.com/@devkosal/switching-java-jdk-versions-on-macos-80bc868e686a)
- You have downloaded, personalized and sourced the file journeysetupexample.sh:
  - curl https://raw.githubusercontent.com/kennylomax/TutorialsAsCode/main/journeys/TutorialAsCode_1.1_WiringUpLocalKymaToALocalSpartacus/journeysetupexample.sh > journeysetup.sh
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
# kyma deploy
kyma deploy --source=2.2.0
```

## Import Kyma's Certificate to your OSX Keychain
Request Privileges on your Mac (see https://github.com/SAP/macOS-enterprise-privileges) and then import certificates,

```commands
sudo kyma import certs
```

## Create an application in Kyma called commerce

```multilinecommand
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

Confirm you see the newly created application:

```
kubectl get applications -n kyma-space
```

## Downgrade Kyma's security to allow communication with a local Commerce

Adjust the functionBuildExecutorArgs security level:

```multilinecommand
cat > ~/localkymatlsoverrides.yaml <<EOF
serverless:
  containers:
    manager:
      envs:
        functionBuildExecutorArgs:
          value: --insecure,--skip-tls-verify,--skip-unused-stages,--log-format=text,--cache=true,--force
EOF
```

```commands
kyma deploy --values-file ~/localkymatlsoverrides.yaml
```

Enable insecureSpecDownload:

```multilinecommand
kubectl get deployment application-registry -n kyma-integration -o yaml |\
  sed -e 's|insecureSpecDownload=false|insecureSpecDownload=true|'| \
  kubectl apply -f -
```

Disable SSL Validation for your application

```multilinecommand
kubectl get deployment commerce-application-gateway -n kyma-integration -o yaml |\
  sed -e 's|skipVerify=false|skipVerify=true|'| \
  kubectl apply -f -
```

Restart your Kyma Cluster 

```commands
k3d cluster stop kyma
k3d cluster start kyma
```

Before proceeding, use the following queries to confirm that:

- insecureSpecDownload=true and
- skipVerify=true
- you can now see the hostname host.k3d.internal in the coredns description:
```
kubectl get deployment application-registry -n kyma-integration -o yaml 
kubectl get deployment commerce-application-gateway -n kyma-integration -o yaml
kubectl describe cm coredns -n kube-system
```

## Import your Kyma Certificate into Commerce

Download the local-kyma-dev certification from your OSX Keychain and load into Commerce

```commands
security find-certificate -c local-kyma-dev -p > ~/local-kyma-dev-temp.pem
openssl x509 -outform der -in ~/local-kyma-dev-temp.pem -out ~/local-kyma-dev.cer
cd $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/bin/platform/resources/devcerts
keytool -keystore ydevelopers.jks -storepass 123456 -import -file ~/local-kyma-dev.cer -alias local-kyma-dev
```
(If you need to delete the key: keytool -delete -noprompt -alias local-kyma-dev  -keystore ydevelopers.jks -storepass 123456)

## Add Cors and Kyma properties to CCV2:

Add some properties to $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/config/local.properties:

```commands
curl https://raw.githubusercontent.com/kennylomax/TutorialsAsCode/main/journeys/TutorialAsCode_1.1_WiringUpLocalKymaToALocalSpartacus/localprops.txt > ~/localprops.txt 
```

```commands
cat ~/localprops.txt >> $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/config/local.properties 
```

The important items to note here are the following: -

- kymaintegrationservices.truststore.cacerts.path - This is the location of the cacerts file that is used to store the trusted self-signed SSL certificate that Kyma uses
- ccv2.services.api.url.0 - This is the URL to your local instance of SAP Commerce, as referenced from the K3D landscape, so that Kyma can connect to the SAP Commerce application
- corsfilter.ycommercewebservices fields are to avoid CORS issues with Spartacus

## Stop, re-initialize, then re-start SAP Commerce

```commands
cd $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/bin/platform
./hybrisserver.sh stop
chmod 700 setantenv.sh
. ./setantenv.sh
ant clean all
ant initialize
./hybrisserver.sh start
```

## Set up OCC credentials to enable the Spartacus purchase workflow

[For an explanation why this is necessary, see here](https://sap.github.io/spartacus-docs/installing-sap-commerce-cloud-1905/#configuring-cors)

Import this impex via the hac (hybris Administration Console):

```clickpath:ImportCorsFilters
https://localhost:9002 -> Console -> ImpEx Import 
 -> Import content

INSERT_UPDATE OAuthClientDetails;clientId[unique=true]  ;resourceIds   ;scope  ;authorizedGrantTypes  ;authorities   ;clientSecret  ;registeredRedirectUri
  ;client-side  ;hybris  ;basic  ;implicit,client_credentials   ;ROLE_CLIENT   ;secret  ;http://localhost:9001/authorizationserver/oauth2_implicit_callback;
  ;mobile_android   ;hybris  ;basic  ;authorization_code,refresh_token,password,client_credentials  ;ROLE_CLIENT   ;secret  ;http://localhost:9001/authorizationserver/oauth2_callback;
```

## Open the Kyma dashbord

```commands
kyma dashboard
```

Note at present I can view the [Kyma dashboard](http://localhost:3001?kubeconfigID=config.yaml) on Safari and not Chrome... 

## Monitor Kyma and Commerce Logs

View CCV2 log file 
```
tail -f -n100  $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/log/tomcat/console*.log
```

And view Kyma Events at:
```
kubectl logs -n kyma-system eventing-nats-0
```

## Get the connection token for your Kyma Application

```clickpath:GetKymaConnectionURL
KYMA_DASHBOARD → Integration → Applications → commerce → Connect Application -> Copy to Clipboard
```

## Pair your SAP Commerce with Kyma

```clickpath:PairBackoffice
https://localhost:9002/backoffice → System → API → Destination Target → Default_Template → Wizard →
  -> Token URL = <Paste URL that you copied earlier>
  -> New Destination's Id = mykyma
  -> Register Destination Target
```

Return to 
KymaCockpit-> Integration -> Applications → commerce  
where you should see the "Provided Services and Events"  being populated over the next minute or two.
Once this list is populated with entries including "CC Events v1" and "CC OCC Commerce Webservices v2" you can proceed..

## Creating a binding in Kyma

```clickpath:createKymaBinding
KymaCockpit-> Integration -> Applications → commerce → Create Namespace Binding 
  -> Namespace = default
  -> Create
``` 

## Set up Events

```clickpath:setUpEventsInKyma
Kyma → NamesSpaces -> default -> Service Management -> Catalog -> CC Events v1 -> Add once + -> Create
Kyma → NamesSpaces -> default -> Service Management -> Catalog -> CC OCC Commerce Webservices v2 ->  Add once + -> Create
```

## Creating a Kyma Function

```clickpath:createKymaFunction
Kyma → NamesSpaces -> default -> Workloads -> Functions ->  Create Function -> 
  Name=function1 
  -> Create -> 
  Configuration -> Create Subscription -> 
  Application name=commerce
  Event name=order.created
  Event version=v1
-> Create
  Code ->
    Source = module.exports = { main: function (event, context) { console.log("Hi there"); return "Hello World!";} }
  -> Save
```

## Restart Spartacus

```commands
cd $MY_JOURNEY_DIR/cloud-commerce-sample-setup/js-storefront/spartacusstore
echo y | yarn build 
echo y | yarn start &
```

## Purchase something in Spartacus

```clickpath:MakeFirstPurchaseWithVisa4444333322221111
https://jsapps.{MY_COMMERCE_CLOUD_DOMAIN}...
```

.. and you should see that your function has been called
