# Tutorials as Code - Getting CCV2 and Spartacus to run locally, then customizing Spartacus

Last checked on 20220413

In this journey we

* Get CCV2 and Spartacus running locally,
* Extend Spartacus with a custom component.

Other journeys deploy this to [SAP Commerce Cloud](https://portal.commerce.ondemand.com/), then wire up to [Kyma](https://github.com/kyma-project/kyma) for further fun.

## Prerequisites

- Use[ JDK  11.x.x](https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html). To switch java versions on a Mac, see[ here](https://medium.com/@devkosal/switching-java-jdk-versions-on-macos-80bc868e686a)
- Download a SAP Commerce**2105** ZIP from[ SAP Software Downloads web site](https://launchpad.support.sap.com/#/softwarecenter/template/products/_APP=00200682500000001943&_EVENT=NEXT&HEADER=Y&FUNCTIONBAR=Y&EVENT=TREE&NE=NAVIGATE&ENR=67837800100800007216&V=MAINT&TA=ACTUAL/SAP%20COMMERCE) into your downloads folder
- Download the file journeysetupexample.sh to journeysetup.sh, personalize the data in journeysetup.sh and then source its contents:

```
curl https://raw.githubusercontent.com/kennylomax/TutorialsAsCode/main/journeys/TutorialAsCode_1.0_LocalCCV2AndSpartacus/journeysetupexample.sh > journeysetup.sh 

.. then personalize its contents and then..

source journeysetup.sh
```

# Journey

## Clone and modify the Cloud Commerce Sample Setup

Create a new directory and clone the Cloud Commerce Sample Setup into it:

```commands
mkdir -p $MY_JOURNEY_DIR
cd $MY_JOURNEY_DIR
git clone https://github.com/SAP-samples/cloud-commerce-sample-setup.git
```

Unzip your downloaded Commerce

```commands
mkdir -p $MY_JOURNEY_DIR/$SAP_COMMERCE
cd $MY_JOURNEY_DIR/$SAP_COMMERCE
cp $MY_DOWNLOAD_FOLDER/$SAP_COMMERCE.ZIP .
unzip $SAP_COMMERCE.ZIP
```

Move folders hybris/bin/modules and hybris/bin/platform from your unzipped SAP Commerce core directory to your core-customize/hybris/bin:

```commands
cd $MY_JOURNEY_DIR/$SAP_COMMERCE
export SAP_COMMERCE_BIN=$MY_JOURNEY_DIR/$SAP_COMMERCE/hybris/bin
mv $SAP_COMMERCE_BIN/modules $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/bin
mv $SAP_COMMERCE_BIN/platform $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/bin
```

## Build your Cloud Commerce Sample Setup

Set up Apache Ant, then run an ant command to add Addons to your SAP Commerce:

```commands
cd $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/bin/platform
chmod 700 setantenv.sh
. ./setantenv.sh
cd $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/bin/platform; ant addoninstall -Daddonnames="smarteditaddon,textfieldconfiguratortemplateaddon,assistedservicestorefront,assistedservicepromotionaddon,customerticketingaddon,orderselfserviceaddon,adaptivesearchsamplesaddon,multicountrysampledataaddon,pcmbackofficesamplesaddon,personalizationaddon" -DaddonStorefront.yacceleratorstorefront="yacceleratorstorefront"
```

## Set up OCC credentials to enable the Spartacus purchase workflow

[For an explanation why this is necessary, see here](https://sap.github.io/spartacus-docs/installing-sap-commerce-cloud-1905/#configuring-cors)

Adjust the property corsfilter.acceleratorservices.allowedOrigins to avoid CORS issues when Spartacus makes calls to the acceleratorservices API.

```commands
echo "corsfilter.ycommercewebservices.allowedOrigins=http://localhost:4200 https://localhost:4200" >> $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/config/local.properties
echo "corsfilter.ycommercewebservices.allowedMethods=GET HEAD OPTIONS PATCH PUT POST DELETE" >> $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/config/local.properties
echo "corsfilter.ycommercewebservices.allowedHeaders=origin content-type accept authorization cache-control if-none-match x-anonymous-consents" >> $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/config/local.properties
echo "corsfilter.acceleratorservices.allowedOrigins=*" >> $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/config/local.properties
echo "corsfilter.acceleratorservices.klx4=klx4" >> $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/config/local.properties

```

Build, initialize and then run SAP Commerce locally

```commands
cd $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/bin/platform
chmod 700 setantenv.sh
. ./setantenv.sh
ant clean all
ant initialize
```

## Run and access your Cloud Commerce Sample Setup

You can start it in the background as below, or run in the forgroung with **./hybrisserver.sh**, to ensure you see all log output.  But then place in the background once it has started (**ctrl-z; bg** )

```commands
./hybrisserver.sh start
```

Note: if on a Mac..

- you may get Security notificaitons.  If so, open the "SystemPreferences->Security & Privacy", and respond to the security checks that appear when you run the previous command. You will then have to run*./hybrisserver.sh* start a second time.  If on linux, you do not have to run this command a second time:

Wait for Commerce to come online.. (not optimal but until I figure out how to do this in Karate..)

```commands
until $(curl -k --output /dev/null --silent --fail https://localhost:9002); do printf "."; sleep 5; done
```

Access SAP Commerce @ https://localhost:9002

## Compile and start Spartacus

Build your Spartacus Storefront and run it locally

```commands
cd $MY_JOURNEY_DIR/cloud-commerce-sample-setup/js-storefront/spartacusstore
echo y | npm install
npm install --global yarn
echo y | yarn build 
echo y | yarn start &
```

Wait for Spartacus to come online.. (not optimal but until I figure out how to do this in Karate..)

```commands
until $(curl -k --output /dev/null --silent --fail https://localhost:4200); do printf "."; sleep 5; done
```

Access Spartaus @ https://localhost:4200  and look around. (Note you cannot yet register a user, or purchase anything in Spartacus, due to CORS issues that we will address below)

```clickpath:LoginToSpartacusViaWarning
https://localhost:4200 -> Advanced -> Proceed to localhost (unsafe) -> Sign In / Register
```

## Customize your Spartacus Storefront with new functionality

Install angular CLI:

```command
echo y | npm install -g @angular/cli
```

Generate a new module custom-voucher..

```commands
cd $MY_JOURNEY_DIR/cloud-commerce-sample-setup/js-storefront/spartacusstore
ng g m custom-voucher
```

.. and add it to the list of imports in **$MY_JOURNEY_DIR/cloud-commerce-sample-setup/js-storefront/spartacusstore/src/app/app.module.ts**

```file
import { HttpClientModule } from "@angular/common/http";
import { NgModule } from "@angular/core";
import { BrowserModule, BrowserTransferStateModule } from "@angular/platform-browser";
import { EffectsModule } from "@ngrx/effects";
import { StoreModule } from "@ngrx/store";
import { AppRoutingModule } from "./app-routing.module";
import { AppComponent } from "./app.component";
import { SpartacusModule } from "./spartacus/spartacus.module";
import { ServiceWorkerModule } from "@angular/service-worker";
import { environment } from "../environments/environment";
import { CustomVoucherModule } from "./custom-voucher/custom-voucher.module";

@NgModule({
  declarations: [
  AppComponent
  ],
  imports: [ 
  CustomVoucherModule, 
  BrowserModule.withServerTransition({ appId: "serverApp" }),
  HttpClientModule,
  AppRoutingModule,
  StoreModule.forRoot({}),
  EffectsModule.forRoot([]),
  SpartacusModule,
  ServiceWorkerModule.register("ngsw-worker.js", {
  enabled: environment.production,
  // Register the ServiceWorker as soon as the app is stable
  // or after 30 seconds (whichever comes first).
  registrationStrategy: "registerWhenStable:30000"
  }),
  BrowserTransferStateModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
```

Create a new component

```commands
ng g c custom-voucher/custom-product-summary
```

Create a new service

```commands
ng g s custom-voucher/voucher
```

Adjust the file
**$MY_JOURNEY_DIR/cloud-commerce-sample-setup/js-storefront/spartacusstore/src/app/custom-voucher/custom-voucher.module.ts** to:

```file
import { NgModule } from "@angular/core";
import { CommonModule } from "@angular/common";
import { CustomProductSummaryComponent } from "./custom-product-summary/custom-product-summary.component";
 
import { CmsConfig, ConfigModule } from "@spartacus/core"
 
@NgModule({
  declarations: [
  CustomProductSummaryComponent
  ],
  imports: [
  CommonModule,
  ConfigModule.withConfig({
  cmsComponents : {
  ProductSummaryComponent: {
  component: CustomProductSummaryComponent
  }}
  } as CmsConfig )
  ]
})
export class CustomVoucherModule { }
```

Confirm that you can see your new module in the spartacus storefront

Adjust the file **$MY_JOURNEY_DIR/cloud-commerce-sample-setup/js-storefront/spartacusstore/src/app/custom-voucher/custom-product-summary/custom-product-summary.component.html** to

```file
<p>custom-product-summary works!</p>
<ng-container *ngIf="product$ | async as product">
  <h1>Product Info: {{product.summary}}</h1>
</ng-container>
 
 
<ng-container *ngIf="user$ | async as user">
  <h1>User info: {{user.name}}</h1>
</ng-container>
 
<ng-container *ngIf="voucher">
  <div class="alert alert-success">
    Voucher Info : {{voucher[0].code}}
  </div>
</ng-container>
```

Adjust the file **$MY_JOURNEY_DIR/cloud-commerce-sample-setup/js-storefront/spartacusstore/src/app/custom-voucher/custom-product-summary/custom-product-summary.component.ts** to

```file
import { Component, OnInit } from "@angular/core";
import { Product, User } from "@spartacus/core";
import { CurrentProductService } from "@spartacus/storefront";
import { UserAccountFacade } from "@spartacus/user/account/root";
import { Observable } from "rxjs";
import { VoucherService } from "../voucher.service";

@Component({
  selector: "app-custom-product-summary",
  templateUrl: "./custom-product-summary.component.html",
  styleUrls: ["./custom-product-summary.component.scss"]
})
export class CustomProductSummaryComponent implements OnInit {

  product$ : Observable<Product|null>  = this.currentProductService.getProduct();
  user$ : Observable<User|undefined>  = this.userService.get();
  voucher:any = {}
  constructor( private currentProductService: CurrentProductService, private userService:UserAccountFacade, private voucherService:VoucherService) { }

  ngOnInit(): void {
  this.getVoucherDetails()
  }

  getVoucherDetails(){
  this.voucherService.getVoucher("an", "example").subscribe(
  res =>  {  this.voucher = res;}, 
  err=> {console.log(err);}, 
  () => {console.log("Get response is completed");}
  )
  }
}
```

Adjust the file **$MY_JOURNEY_DIR/cloud-commerce-sample-setup/js-storefront/spartacusstore/src/app/custom-voucher/voucher.service.ts** to

```file
import { HttpClient, HttpParams } from "@angular/common/http";
import { Injectable } from "@angular/core";

@Injectable({
  providedIn: "root"
})
export class VoucherService {

  constructor(private httpClient:HttpClient) { }

  public getVoucher (_userId: any, _productId: any){
  // const params = new HttpParams().set("userId", userId).set("productId",productId);
  return this.httpClient.get( "https://my-json-server.typicode.com/kennylomax/spartacusdemojson/vouchers?id=1" )
  }
}

```

## Rebuild and restart Spartarcus

```commands
cd $MY_JOURNEY_DIR/cloud-commerce-sample-setup/js-storefront/spartacusstore
echo y | yarn build 
echo y | yarn start &
```

Wait for Spartacus to come online.. (not optimal but until I figure out how to do this in Karate..)

```commands
until $(curl -k --output /dev/null --silent --fail https://localhost:4200); do printf "."; sleep 5; done
```

Open Spartacus, select an item in Spartacus, and confirm you see the custom component in the Spartacus storefront..

```clickpath:SpartacusCustomVoucher
https://localhost:4200 -> Photosmart E317 Digital Camera -> custom-product-summary works!
```

https://user-images.githubusercontent.com/6401254/158601033-3dade944-38a3-4fee-b8cb-12b1e1a1c20c.mp4

(Note for testing team: Karate can run this clickpath for version CXCOMM201100P_15-70005693 but  gives an error when running CXCOMM210500P_8-70005661..  GET .../occ/v2/electronics-spa/cms/pages?lang=en&curr=USD net::ERR_CERT_AUTHORITY_INVALID.  To be investigated..)

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

You should now be able to select and purchase an article in Spartacus, using the fake VISA card number 4444333322221111.

## Next

For a comprehensive, hands-on walk-through of CCV2 capabilities:

- use the Learning System and supporting EBook from our Training Depts'[SAP Commerce Cloud Developer Part 1 and Part 2 courses](https://learning-journeys-prod.cfapps.eu10.hana.ondemand.com/#/learning-journeys/learningJourney/5009ab8a7a261014b60ce7241ebd605a)  These give you a preconfigured CCV2 environment, and exercises to work through :)`<img width="791" alt="Screenshot 2022-03-11 at 10 47 37" src="https://user-images.githubusercontent.com/6401254/157843905-63ba9a77-e433-4eed-97bd-c2132a0e8c02.png">`
- and/or try[Commerce 123](https://help.sap.com/viewer/3fb5dcdfe37f40edbac7098ed40442c0/2105/en-US/a1ef894ac89545e79c470c726b487d13.html) which is similar to the (in)famous Cuppy Trail of yore.
- and/or try more TutorialsAsCode journeys
