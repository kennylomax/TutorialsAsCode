import { Component, OnInit } from '@angular/core';
import {
    AuthenticationService, ConsentService, ShoppingCartService
} from '@upscale/web-storefront-sdk'
 
import {Product, ProductService} from '@upscale/service-client-angular'
 
@Component({
  selector: 'lib-my-first-native-extension',
  template: `
    <img src="https://upload.wikimedia.org/wikipedia/commons/c/cd/Pivot_Wave.gif">
    <p>
      my-first-native-extension works!
    </p>
  `,
  styles: [
  ]
})
 
export class MyFirstNativeExtensionComponent implements OnInit {
  constructor(
      //Shared servives with PWA
    private consentService: ConsentService,
    private shoppingCartService: ShoppingCartService,
    private authenticationService: AuthenticationService,
    private productService: ProductService
  ) {
  }
 
  ngOnInit(): void {
    console.log("Extension is working")
    this.consentService.consentsStatus.subscribe( o => {
      console.log("Consent: ",o)
    })
    this.shoppingCartService.draftOrder.subscribe( o=>{
      console.log("Shopping cart: ",o)
    })
    this.authenticationService.loginStatus.subscribe( o=>{
      console.log("Auth: ",o)
    })
    // You can also call into upscale APIs eg:  this.productService.getProductById('someId').subscribe((product:Product)=>{})
  }
}