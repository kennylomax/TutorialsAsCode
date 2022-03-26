import { NgModule } from '@angular/core';
import { MyFirstNativeExtensionComponent } from './my-first-native-extension.component';
import { RegistrationService } from '@upscale/web-storefront-sdk'
 
@NgModule({
  declarations: [
    MyFirstNativeExtensionComponent  // Declare (1 or more..)
  ],
  imports: [
  ],
  exports: [
    MyFirstNativeExtensionComponent  // Export (1 or more..)
  ]
})
export class UpscaleExtensionModule {
  constructor(
    private registrationService: RegistrationService
  ){
    this.registrationService.register('hello-world', MyFirstNativeExtensionComponent);  // Register (1 or more..)
  }
}