Feature: CommerceCloud

Background:
  * def delays = 10000
  * def watchInput = function(loc, v) { waitFor(loc).highlight(); script(loc, "_.value = ''"); input(loc, v )  }
  * def watchAppendInput = function(loc, v) { input(loc, v )  }
  * def watchSubmit = function() { waitFor('button[type=submit]').highlight(); click('button[type=submit]') }
  * def watchFor =  function(loc) {  waitFor(loc).highlight().click()   }
  * def watchForOptional =  function(loc) { delay(delays); optional(loc).highlight().click()   }

@preflightChecks
Scenario:
  * driver "https://nodejs.org/en/download/"
  * watchFor( '{a}64-bit / ARM64')
  * delay(delays)
  * waitFor( '{a}64-bit / ARM64')

@LoginToCommerceCloudViaWarning2
Scenario:
"""
https://localhost:9002 -> Advanced -> Proceed to localhost (unsafe) -> username=admin -> password=nimda -> LOGIN
""" 
  * driver 'https://localhost:9002'
  * watchFor( '{button}Advanced')
  * delay(delays)
  * watchFor( '{a}Proceed to localhost (unsafe)')
  * watchInput('input[name=j_username]', "admin")
  * watchInput('input[name=j_password]', "nimda")
  * watchSubmit()
  * delay(delays)

@LoginToSpartacusViaWarning
Scenario:
"""
https://localhost:4200 -> Advanced -> Proceed to localhost (unsafe)
""" 
  * driver 'https://localhost:4200'
  * watchFor( '{button}Advanced')
  * delay(delays)
  * watchFor( '{a}Proceed to localhost (unsafe)')
  * delay(delays)

@BackofficeUserPassword
Scenario:
"""
https://localhost:9002/backoffice -> username=admin -> password=nimda -> Login -> User -> Customers -> summercustomer@hybris.com -> PASSWORD -> New Password=12345 -> Confirm New Password=12345 -> SAVE
"""
  * driver 'https://localhost:9002/backoffice'
  * watchForOptional( '{button}Advanced')
  * watchForOptional( '{a}Proceed to localhost (unsafe)')
  * watchInput('input[name=j_username]', "admin")
  * watchInput('input[name=j_password]', "nimda")
  * watchFor( '{}Login')
  * delay(delays)
  * watchFor( '{}User')
  * watchFor( '{}Customers')
  * watchFor( '{}womenvipsilver@hybris.com')
  * watchFor( '{span}Password')
  * watchInput("//input[@placeholder='New Password']", "12345")
  * watchInput("//input[@placeholder='Confirm New Password']", "12345")
  * watchFor( '{button}Save')
  * delay(delays)



@AddCorsFilterProperties
Scenario:
"""
https://backoffice.{MY_COMMERCE_CLOUD_DOMAIN}/hac/
-> New key...=corsfilter.ycommercewebservices.allowedOrigin
-> New value...=https://jsapps.{MY_COMMERCE_CLOUD_DOMAIN} 
-> add
-> New key...=corsfilter.ycommercewebservices.allowedMethods
-> New value...=GET HEAD OPTIONS PATCH PUT POST DELETE
-> add
-> New key...=corsfilter.ycommercewebservices.allowedHeaders
-> New value...=origin content-type accept authorization cache-control if-none-match x-anonymous-consents
-> add
"""
  * def hacURL = 'https://backoffice.'+MY_COMMERCE_CLOUD_DOMAIN+'/hac/'
  * driver hacURL
  * delay(5000)
  * input('input[name=j_username]', 'admin' )
  * input('input[name=j_password]', MY_COMMERCE_CLOUD_PASSWORD )
  * watchFor( '{}login') 
  * delay(5000)
  * watchFor('/html/body/div[2]/header/div[3]/nav[1]/ul/li[1]/a')
  * mouse().move('/html/body/div[2]/header/div[3]/nav[1]/ul/li[1]/a').click()
  * watchFor('{a}configuration')
  * watchInput( 'input[id=configKey]', 'corsfilter.ycommercewebservices.allowedOrigin')
  * watchInput( 'input[id=configValue]', ['https://jsapps.', MY_COMMERCE_CLOUD_DOMAIN])
  * watchFor( 'button[id=addButton]')
  * watchInput( 'input[id=configKey]', 'corsfilter.ycommercewebservices.allowedMethods')
  * watchInput( 'input[id=configValue]', 'GET HEAD OPTIONS PATCH PUT POST DELETE')
  * watchFor( 'button[id=addButton]')
  * watchInput( 'input[id=configKey]', 'corsfilter.ycommercewebservices.allowedHeaders')
  * watchInput( 'input[id=configValue]', 'origin content-type accept authorization cache-control if-none-match x-anonymous-consents')
  * watchFor( 'button[id=addButton]')
  * delay(69000)

@RegisterInSpartacus
Scenario:
"""
https://jsapps.{MY_COMMERCE_CLOUD_DOMAIN}
"""
  * def spartacusURL = 'https://jsapps.'+MY_COMMERCE_CLOUD_DOMAIN
  * driver spartacusURL
  * watchFor('{a}Sign In / Register')
  * watchFor('{a}Register')
  * watchInput( 'input[name=firstname]', 'Bob')
  * watchInput( 'input[name=lastname]', 'Builder')
  * watchInput( 'input[name=email]', 'bob@builder.com')
  * watchInput( 'input[name=password]', 'Builder123!')
  * watchInput( 'input[name=confirmpassword]', 'Builder123!')
  * watchFor( 'input[name=newsletter]')
  * watchFor( 'input[name=termsandconditions]')
  * watchSubmit()

@MakeFirstPurchaseWithVisa4444333322221111
Scenario:
"""
https://jsapps.{MY_COMMERCE_CLOUD_DOMAIN}
"""
  * def spartacusURL = 'https://jsapps.'+MY_COMMERCE_CLOUD_DOMAIN
  * driver spartacusURL
  * watchFor( '{h3}DSC-T90')
  * watchFor( '{button}Add to cart')
  * watchFor( '{a}proceed to checkout')
  * watchInput( 'input[type=email]', 'bob@builder.com')
  * watchInput( 'input[type=password]', 'Builder123!')
  * watchSubmit()
  * delay(5000)
  * waitFor('/html/body/app-root/cx-storefront/main/cx-page-layout/cx-page-slot[2]/cx-shipping-address/cx-address-form/form/div[1]/div/div[1]/div/label/ng-select').highlight()
  * mouse( '/html/body/app-root/cx-storefront/main/cx-page-layout/cx-page-slot[2]/cx-shipping-address/cx-address-form/form/div[1]/div/div[1]/div/label/ng-select').click()
  * delay(5000)
  * watchFor( '{}Albania')
  * watchInput( 'input[formcontrolname=firstName]', 'Bob')
  * watchInput( 'input[formcontrolname=lastName]', 'Builder')
  * watchInput( 'input[formcontrolname=line1]', 'BobStreet')
  * watchInput( 'input[formcontrolname=town]', 'BobTown')
  * watchInput( 'input[formcontrolname=line1]', 'Bob1')
  * watchInput( 'input[formcontrolname=postalCode]', '80798')
  * watchFor( '{button}Continue')
  * delay(5000)
  * watchFor( '{button}Continue')
  * delay(5000)
  * waitFor( '/html/body/app-root/cx-storefront/main/cx-page-layout/cx-page-slot[2]/cx-payment-method/cx-payment-form/form/div[1]/div/div[1]/div/label/ng-select').highlight()
  * mouse( '/html/body/app-root/cx-storefront/main/cx-page-layout/cx-page-slot[2]/cx-payment-method/cx-payment-form/form/div[1]/div/div[1]/div/label/ng-select').click()
  * watchFor( '{}Visa')
  * watchInput( 'input[formcontrolname=accountHolderName]', 'Bob Builder')
  * watchInput( 'input[formcontrolname=cardNumber]', '4444333322221111')
  * waitFor( '/html/body/app-root/cx-storefront/main/cx-page-layout/cx-page-slot[2]/cx-payment-method/cx-payment-form/form/div[1]/div/div[4]/div[1]/fieldset/label[1]/ng-select').highlight()
  * mouse( '/html/body/app-root/cx-storefront/main/cx-page-layout/cx-page-slot[2]/cx-payment-method/cx-payment-form/form/div[1]/div/div[4]/div[1]/fieldset/label[1]/ng-select').click()
  * watchFor( '{}01')
  * waitFor( '/html/body/app-root/cx-storefront/main/cx-page-layout/cx-page-slot[2]/cx-payment-method/cx-payment-form/form/div[1]/div/div[4]/div[1]/fieldset/label[2]/ng-select').highlight()
  * mouse( '/html/body/app-root/cx-storefront/main/cx-page-layout/cx-page-slot[2]/cx-payment-method/cx-payment-form/form/div[1]/div/div[4]/div[1]/fieldset/label[2]/ng-select').click()
  * watchFor( '{}2024')
  * watchInput( 'input[formcontrolname=cvn]', '123')
  * watchFor( '{button}Continue')
  * delay(5000)
  * watchFor( 'input[formcontrolname=termsAndConditions]')
  * watchFor( '{button}Place Order')
  * delay(5000)
  

  




  
