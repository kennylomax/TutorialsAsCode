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



@CreateCCRepo
Scenario:
"""
https://portal.commerce.ondemand.com -> Repository 
  -> Repository URL = github.tools.sap/$MY_GITHUB_USERNAME/concerttours-ccloud.git
  -> Username = $MY_GITHUB_USERNAME
  -> Token = $MY_GITHUB_TOKEN
  -> Save
"""
  * driver 'https://portal.commerce.ondemand.com'
  * delay(60000)
  * watchFor( '{}Repository')
  * delay(10000)

  * watchInput("//input[@data-placeholder='Repository URL']", "github.tools.sap/"+MY_GITHUB_USERNAME+"/concerttours-ccloud")
  * watchInput("//input[@data-placeholder='Username']", ""+MY_GITHUB_USERNAME )
  * watchInput("//input[@data-placeholder='Token']", ""+MY_GITHUB_TOKEN )
  * watchFor( '{button}Save')
  * delay(delays)


@TriggerABuild
Scenario:
"""
https://portal.commerce.ondemand.com -> Builds -> Create 
  -> Name = Build${NOW} 
  -> Git Branch or Tag = main
  -> Save
"""
  * driver 'https://portal.commerce.ondemand.com'
  * delay(10000)
  * watchFor( '{}Repository')
  * delay(10000)
  * watchFor( '{}Builds')
  * watchFor( '{button}Create')
  * watchInput("//input[@data-placeholder='Name']", 'Build'+NOW  )
  * watchInput("//input[@data-placeholder='Git Branch or Tag']", 'main' )
  * watchFor( '{button}Save')
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
https://jsapps.{MY_COMMERCE_CLOUD_DOMAIN} -> Sign In / Register -> Register ->
  -> Register yourself
  -> Check both checkboxes
  -> Register
"""
  * def spartacusURL = 'https://jsapps.'+MY_COMMERCE_CLOUD_DOMAIN
  * driver spartacusURL
  * watchFor('{a}Sign In / Register')
  * watchFor('{a}Register')
  * watchInput( 'input[name=firstname]', 'Bob')
  * watchInput( 'input[name=lastname]', 'Builder')
  * watchInput( 'input[name=email]', 'bob@tbuilder.com')
  * watchInput( 'input[name=password]', 'Builder123!')
  * watchInput( 'input[name=confirmpassword]', 'Builder123!')
  * watchFor( 'input[name=newsletter]')
  * watchFor( 'input[name=termsandconditions]')
  * watchSubmit()

@DeployBuild
Scenario:
"""
https://portal.commerce.ondemand.com -> Builds -> LatestBuild  ->  Deploy to Environment    
  -> Target Environment = dev 
  -> Data Migration Mode = Initialize database
  -> Deployment Mode = Recreate (fastest, with downtime)
  -> Deploy -> Deploy
"""
  * driver 'https://portal.commerce.ondemand.com'
  * delay(60000)
  * watchFor( '{}Builds')
  * delay(20000)
  * watchFor("{mat-cell:0}" )
  * watchFor( '{}Deploy to Environment')
  * delay(10000)
  
  * locateAll("//div[starts-with(@class, 'mat-select-arrow ')]")[2].highlight().click() 
  * delay(1000)
  * watchFor('{}Recreate (fastest, with downtime)')
  
  * locateAll("//div[starts-with(@class, 'mat-select-arrow ')]")[1].highlight().click() 
  * delay(1000)
  * watchFor('{}Initialize database')

  * locateAll("//div[starts-with(@class, 'mat-select-arrow ')]")[0].highlight().click() 
  * delay(1000)
  * watchFor('{}dev')  
  * delay(1000)
    
  * watchFor( '{button}Deploy')
  * watchFor( '{button:2}Deploy')
  * delay(delays)



@AllowAccessToCloudCommerceAndAccessSpartacus
Scenario:
"""
https://portal.commerce.ondemand.com -> Environments 
  -> dev -> Deny all -> Allow all -> Save
  -> API -> Deny all -> Allow all -> Save
  -> Backoffice -> Deny all -> Allow all -> Save
  -> JS Storefront -> Deny all -> Allow all -> Save
  -> Storefront -> Deny all -> Allow all -> Save
  -> JS Storefront URL
"""
  * driver 'https://portal.commerce.ondemand.com'
  * delay(20000)
  * watchFor( '{a}dev')
  * watchFor( '{}API')
  * watchForOptional( '{}Deny all')
  * watchForOptional( '{}Allow all')
  * watchFor( '{}Save')
  * watchFor( '{}Cancel')
  * watchFor( '{}Backoffice')
  * watchForOptional( '{}Deny all')
  * watchForOptional( '{}Allow all')
  * watchFor( '{}Save')
  * watchFor( '{}Cancel')
  * watchFor( '{}JS Storefront')
  * watchForOptional( '{}Deny all')
  * watchForOptional( '{}Allow all')
  * watchFor( '{}Save')
  * watchFor( '{}Cancel')
  * watchFor( '{}Storefront')
  * watchForOptional( '{}Deny all')
  * watchForOptional( '{}Allow all')
  * watchFor( '{}Save')
  * watchFor( '{}Cancel')
  * delay(2000)
  * locateAll("//fd-icon[starts-with(@class, 'icon-external-link ')]")[2].click() 
  * delay(10000)
  
  
@GetAdminPwdAndLoginToBackoffice
Scenario:
"""
https://portal.commerce.ondemand.com ->  Environments -> dev -> API -> view all -> hcs_admin -> Properties -> admin -> Copy to clipboard
<New Browser Tab> -> https://portal.commerce.ondemand.com -> Environments -> Backoffice URL ->
  -> username = admin
  -> Password = Password from clipboard
  -> Login
<New Browser Tab> -> Backoffice URL with the tail "backoffice/" replaced by "hac/"->
  -> username = admin
  -> Password = Password from clipboard
  -> Login
"""
  * driver 'https://portal.commerce.ondemand.com'
  * delay(20000)
  * watchFor( '{a}dev')
  * watchFor( '{}View all (7)')
  * delay(10000)
  * watchFor( '{}hcs_admin')
  * watchFor( '{}Properties')
  * delay(10000)
  * locateAll("//a[contains(@class, 'sap-icon--show')]")[0].click() 
  * delay(5000)
  * mouse('{}Copy to Clipboard').click()
  * delay(5000)
  * driver 'https://portal.commerce.ondemand.com'
  * delay(40000)
  * watchFor( '{a}dev')
  * delay(20000)
  * locateAll("//fd-icon[starts-with(@class, 'icon-external-link ')]")[1].click() 
  * switchPage('SAP CX Backoffice | Login')
  * delay(2000)
  * input('input[name=j_username]', 'admin' )
  * delay(5000)
  * watchFor( '{}Login') 
  * delay(delays)
  * watchFor( '{}Home') 
  * switchPage('SAP Commerce Cloud')
  * delay(5000)
  * locateAll("//fd-icon[starts-with(@class, 'icon-external-link ')]")[1].click() 
  * delay(5000)
  * switchPage('SAP CX Backoffice')
  * delay(5000)
  * def getHacUrl = function(locator){ return driver.url.replace("backoffice/", "hac/");  }
  * def hacUrl = getHacUrl()
  * driver hacUrl
  * delay(5000)
  * input('input[name=j_username]', 'admin' )
  * delay(5000)
  * watchFor( '{}login') 
  * delay(10000)

@ImportCorsFilters
Scenario:
"""
https://backoffice/hac/
-> Console -> ImpEx Import 
-> Import content
"""
  * def hacURL = 'https://backoffice.'+MY_COMMERCE_CLOUD_DOMAIN+'/hac/'
  * driver hacURL
  * delay(5000)
  * input('input[name=j_username]', 'admin' )
  * input('input[name=j_password]', MY_COMMERCE_CLOUD_PASSWORD )
  * watchFor( '{}login') 
  * delay(5000)
  * watchFor('/html/body/div[2]/header/div[3]/nav[1]/ul/li[4]/a')
  * mouse().move('/html/body/div[2]/header/div[3]/nav[1]/ul/li[4]/a').click()
  * watchFor('{a}ImpEx import')
  * watchInput( '//html/body/div[2]/div[2]/div/div[1]/div[1]/form/fieldset/div[1]/div[1]/div[5]/div/div[1]/div/div/div/div[3]/div/pre', 'INSERT_UPDATE OAuthClientDetails;clientId[unique=true]    ;resourceIds       ;scope        ;authorizedGrantTypes                                            ;authorities             ;clientSecret    ;registeredRedirectUri')
  * watchAppendInput('//html/body/div[2]/div[2]/div/div[1]/div[1]/form/fieldset/div[1]/div[1]/div[5]/div/div[1]/div/div/div/div[3]/div/pre', [Key.ENTER,'                                   ;client-side              ;hybris            ;basic        ;implicit,client_credentials                                     ;ROLE_CLIENT             ;secret          ;http://localhost:9001/authorizationserver/oauth2_implicit_callback;'])
  * watchAppendInput( '//html/body/div[2]/div[2]/div/div[1]/div[1]/form/fieldset/div[1]/div[1]/div[5]/div/div[1]/div/div/div/div[3]/div/pre',[Key.ENTER,';mobile_android           ;hybris            ;basic        ;authorization_code,refresh_token,password,client_credentials    ;ROLE_CLIENT             ;secret          ;http://localhost:9001/authorizationserver/oauth2_callback;'])
  * watchFor('/html/body/div[2]/div[2]/div/div[1]/div[1]/form/fieldset/p/input[2]')
  * delay(5000)
  * watchFor('/html/body/div[2]/div[2]/div/div[1]/div[1]/form/fieldset/p/input[1]')
  * delay(69000)


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
  * watchInput( 'input[type=email]', 'bob@thebuilder.com')
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
  

  







  
