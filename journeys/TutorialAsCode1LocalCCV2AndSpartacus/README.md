# Tutorials as Code - Getting CCV2 and Spartacus to run locally, then customizing Spartacus
In this journey we
* Get CCV2 and Spartacus running locally, then extend Spartacus with a custom component
* Other journeys deploy this to [SAP Commerce Cloud](https://portal.commerce.ondemand.com/), then wire up to [Kyma](https://github.com/kyma-project/kyma) for further fun

## Prerequisites for OSX

- Use [JDK  11.0.12](https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html)   To switch java versions on a Mac, see [here](https://medium.com/@devkosal/switching-java-jdk-versions-on-macos-80bc868e686a)

- Download a SAP Commerce **2105** ZIP from [SAP Software Downloads web site](https://launchpad.support.sap.com/#/softwarecenter/template/products/_APP=00200682500000001943&_EVENT=NEXT&HEADER=Y&FUNCTIONBAR=Y&EVENT=TREE&NE=NAVIGATE&ENR=67837800100800007216&V=MAINT&TA=ACTUAL/SAP%20COMMERCE) into your downloads folder
- Download the file journeysetupexample.sh to journeysetup.sh, 
  - curl https://raw.githubusercontent.com/kennylomax/TutorialsAsCode/main/journeys/TutorialAsCode1LocalCCV2AndSpartacus/journeysetupexample.sh > journeysetup.sh 
  - personalize its contents, and then
  - source its contents: source journeysetup.sh 

# Journey

## Get Commerce Cloud and Spartacus running locally 
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
Move folders  hybris/bin/modules and hybris/bin/platform in your unzipped SAP Commerce core directory to your core-customize/hybris/bin:

```commands
cd $MY_JOURNEY_DIR/$SAP_COMMERCE
export SAP_COMMERCE_BIN=$MY_JOURNEY_DIR/$SAP_COMMERCE/hybris/bin
mv $SAP_COMMERCE_BIN/modules $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/bin
mv $SAP_COMMERCE_BIN/platform $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/bin
```

Set up Apache Ant, then run an ant command to add Addons to your SAP Commerce:

```commands
cd $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/bin/platform
chmod 700 setantenv.sh
. ./setantenv.sh
cd $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/bin/platform; ant addoninstall -Daddonnames="smarteditaddon,textfieldconfiguratortemplateaddon,assistedservicestorefront,assistedservicepromotionaddon,customerticketingaddon,orderselfserviceaddon,adaptivesearchsamplesaddon,multicountrysampledataaddon,pcmbackofficesamplesaddon,personalizationaddon" -DaddonStorefront.yacceleratorstorefront="yacceleratorstorefront"
```

Adjust the property corsfilter.acceleratorservices.allowedOrigins to avoid CORS issues when Spartacus makes calls to the acceleratorservices API. 
```commands
echo "corsfilter.acceleratorservices.allowedOrigins=*" >> $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/config/local.properties
```

Build, initialize and then run SAP Commerce locally
```commands
cd $MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/bin/platform
ant clean all
ant initialize
``` 

Start SAP Commerce

You can start it in the background as below, or run in the forgroung with **./hybrisserver.sh**, to ensure you see all log output.  But then place in the background once it has started (**ctrl-z; bg** ) 
```commands
./hybrisserver.sh start
```

Note: if on a Mac..
- you may get Security notificaitons.  If so, open the "SystemPreferences->Security & Privacy", and respond to the security checks that appear when you run the previous command. You will then have to run *./hybrisserver.sh* start a second time.  If on linux, you do not have to run this command a second time:


Wait for Commerce to come online.. (not optimal but until I figure out how to do this in Karate..)

```commands
until $(curl -k --output /dev/null --silent --fail https://localhost:9002); do printf "."; sleep 5; done
```

Access SAP Commerce @ https://localhost:9002 
```clickpath:LoginToCommerceCloudViaWarning2
https://localhost:9002 -> Advanced -> Proceed to localhost (unsafe) -> username=admin -> password=nimda -> LOGIN
``` 

https://user-images.githubusercontent.com/6401254/152189954-370d501d-b120-4149-8656-fb196ed7f378.mp4


## Get Spartacus running locally 
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

Access SAP Commerce @ https://localhost:4200 
```clickpath:LoginToSpartacusViaWarning
https://localhost:4200 -> Advanced -> Proceed to localhost (unsafe)
``` 


https://user-images.githubusercontent.com/6401254/152190009-6c76813f-1264-415b-8693-ab6ff2ea415c.mp4


Access your Spartacus Storefront @ https://localhost:4200/ and look around :)

Note we have not yet set up OCC  Credentials, as [discussed here](https://sap.github.io/spartacus-docs/installing-sap-commerce-cloud-1905/#configuring-cors), so you will not be able, for example, to register a user.   This is done in the next tutorial.


## Modify your Spartacus storefront

Install angular CLI:

```commands
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

Assign a password to a customer in the backoffice:
```clickpath:BackofficeUserPassword
https://localhost:9002/backoffice -> username=admin -> password=nimda -> Login -> User -> Customers -> summercustomer@hybris.com -> PASSWORD -> New Password=12345 -> Confirm New Password=12345 -> SAVE
``` 

https://user-images.githubusercontent.com/6401254/152190081-0bcb10d5-76d9-4876-a1cd-4a73f0936a6f.mp4


Login to Spartacus as that user, select an item and confirm you see voucher details..

Confirm that you can see your new module in the spartacus storefront

(Note for testing team: Karate can run this clickpath for version CXCOMM201100P_15-70005693 but  gives an error when running CXCOMM210500P_8-70005661..  GET .../occ/v2/electronics-spa/cms/pages?lang=en&curr=USD net::ERR_CERT_AUTHORITY_INVALID.  To be investigated..)

```clickpath:SpartacusCustomVoucher
https://localhost:4200 -> Photosmart E317 Digital Camera -> custom-product-summary works!
``` 

https://user-images.githubusercontent.com/6401254/152190148-3814ea1a-52ca-4223-aae2-e277332f6cba.mp4



## Check your CCV2 Spartacus code into Github.tools.sap
Create a new git repository named concerttours-ccloud in your https://github.tools.sap/ account

Remove the existing .git folder from your cloud-commerce-sample-setup

```commands
cd $MY_JOURNEY_DIR/cloud-commerce-sample-setup
rm -rf .git
```

Commit your code to your Github repository:

```commands
cd $MY_JOURNEY_DIR/cloud-commerce-sample-setup
echo "# concerttours-ccloud" >> README.md
git init
git add *
git commit -m "first commit"
git branch -M main
git remote add origin https://$MY_GITHUB_USERNAME:$MY_GITHUB_TOKEN@github.tools.sap/$MY_GITHUB_USERNAME/concerttours-ccloud.git
git push -u origin main
```
