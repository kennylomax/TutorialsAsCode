# Tutorials as Code - Customizing Spartacus

* Extend Spartacus with a custom component.

## Prerequisites
You have vanillaspartacus running against your deployed Commerce as per
https://wiki.one.int.sap/wiki/display/prodandtech/Running+local+Spartacus+against+your+deployed+Commerce

## Compile and start Spartacus

Build your Spartacus Storefront and run it locally

```commands
cd $MY_JOURNEY_DIR/cloud-commerce-sample-setup/js-storefront/spartacusstore
echo y | npm install
npm install --global yarn
echo y | yarn build 
echo y | yarn start 
```

Access Spartaus @ https://localhost:4200  and look around. 

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
cd vanillaspartacus
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

Open Spartacus, select an item in Spartacus, and confirm you see the custom component in the Spartacus storefront..

```clickpath:SpartacusCustomVoucher
https://localhost:4200 -> Photosmart E317 Digital Camera -> custom-product-summary works!
```

https://user-images.githubusercontent.com/6401254/158601033-3dade944-38a3-4fee-b8cb-12b1e1a1c20c.mp4
