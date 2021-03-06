Feature: CommerceCloud

Background:
  * def delays = 10000
  * def inputIt = function(loc, v) { retry(5, delays); waitFor(loc).highlight(); script(loc, "_.value = ''"); input(loc, v )  }
  * def appendIt = function(loc, v) { retry(5, delays); waitFor(loc).highlight(); input(loc, v )   }
  * def clickIt =  function(loc) { retry(5, delays); waitFor(loc).highlight().click ()   }
  * def clickNth =  function(loc, n) { delay(delays);  locateAll(loc)[n].highlight().click ()   }
  * def clickOptional =  function(loc) { retry(3, delays); optional(loc).highlight().click()   }
  * def wrapUp = function() { delay(30000) }
  * def switchToPage = function(p) { delay(delays); switchPage(p);delay(delays); }

@LoginToCommerceCloudViaWarning2
Scenario:
"""
https://localhost:9002 -> Advanced -> Proceed to localhost (unsafe) -> username=admin -> password=nimda -> LOGIN
""" 
  * driver 'https://localhost:9002'
  * clickIt( '{button}Advanced')
  * clickIt( '{a}Proceed to localhost (unsafe)')
  * inputIt('input[name=j_username]', "admin")
  * inputIt('input[name=j_password]', "nimda")
  * clickIt( 'button[type=submit]' )
  * wrapUp()

@LoginToSpartacusViaWarning
Scenario:
"""
https://localhost:4200 -> Advanced -> Proceed to localhost (unsafe)
""" 
  * driver 'https://localhost:4200'
  * clickIt( '{button}Advanced')
  * clickIt( '{a}Proceed to localhost (unsafe)')
  * wrapUp()

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
  * clickIt( '{}Repository')
  * inputIt("//input[@data-placeholder='Repository URL']", "github.tools.sap/"+MY_GITHUB_USERNAME+"/concerttours-ccloud")
  * inputIt("//input[@data-placeholder='Username']", ""+MY_GITHUB_USERNAME )
  * inputIt("//input[@data-placeholder='Token']", ""+MY_GITHUB_TOKEN )
  * clickIt( '{button}Save')
  * wrapUp()

@TriggerABuild
Scenario:
"""
https://portal.commerce.ondemand.com -> Builds -> Create 
  -> Name = Build${NOW} 
  -> Git Branch or Tag = main
  -> Save
"""
  * driver 'https://portal.commerce.ondemand.com'
  * clickIt( '{}Repository')
  * clickIt( '{}Builds')
  * clickIt( '{^a}Create')
  * inputIt("//input[@data-placeholder='Name']", 'Build'+NOW  )
  * inputIt("//input[@data-placeholder='Git Branch or Tag']", 'main' )
  * clickIt( '{button}Save')
  * wrapUp()

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
  * clickIt( '{}Builds')
  * clickIt("{mat-cell:0}" )
  * clickIt( '{}Deploy to Environment')
  * clickNth("//div[starts-with(@class, 'mat-select-arrow ')]",2) 
  * clickIt( '{}Recreate (fastest, with downtime)')  
  * clickNth("//div[starts-with(@class, 'mat-select-arrow ')]",1) 
  * clickIt( '{}Initialize database')
  * clickNth("//div[starts-with(@class, 'mat-select-arrow ')]",0) 
  * clickIt( '{}dev')  
  * clickIt( '{button}Deploy')
  * clickIt( '{button:2}Deploy')
  * wrapUp()


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
  * clickIt( '{a}dev')
  * clickIt( '{}API')
  * clickOptional( '{}Deny all')
  * clickOptional( '{}Allow all')
  * clickIt( '{}Save')
  * clickIt( '{}Cancel')
  * clickIt( '{}Backoffice')
  * clickOptional( '{}Deny all')
  * clickOptional( '{}Allow all')
  * clickIt( '{}Save')
  * clickIt( '{}Cancel')
  * clickIt( '{}JS Storefront')
  * clickOptional( '{}Deny all')
  * clickOptional( '{}Allow all')
  * clickIt( '{}Save')
  * clickIt( '{}Cancel')
  * clickIt( '{}Storefront')
  * clickOptional( '{}Deny all')
  * clickOptional( '{}Allow all')
  * clickIt( '{}Save')
  * clickIt( '{}Cancel')
  * clickNth("//fd-icon[starts-with(@class, 'icon-external-link ')]", 2) 
  * wrapUp()

@GetAdminPwdAndLoginToBackoffice
Scenario:
"""
https://portal.commerce.ondemand.com ->  Environments -> dev -> API -> view all -> hcs_admin -> Properties -> admin -> Copy to clipboard
<New Browser Tab> -> https://portal.commerce.ondemand.com -> Environments -> dev -> Backoffice URL ->
  -> username = admin
  -> Password = Password from clipboard
  -> Login
<New Browser Tab> -> Backoffice URL with the tail "backoffice/" replaced by "hac/"->
  -> username = admin
  -> Password = Password from clipboard
  -> Login
"""
  * driver 'https://portal.commerce.ondemand.com'
  * clickIt( '{a}dev')
  * clickIt( '{}View all (7)')
  * clickIt( '{}hcs_admin')
  * clickIt( '{}Properties')
  
  * clickNth("//fd-icon[contains(@class, 'sap-icon--show')]",0 )
  * clickIt('{}Copy to Clipboard')
  
  * driver 'https://portal.commerce.ondemand.com'
  * clickIt( '{a}dev')
  * clickNth("//fd-icon[starts-with(@class, 'icon-external-link ')]",1)

  * switchToPage('SAP CX Backoffice | Login')
  * inputIt('input[name=j_username]', 'admin' )
  * clickIt( '{}Login') 
  * clickIt( '{}Home') 

  * switchToPage('SAP Commerce Cloud')
  * clickNth("//fd-icon[starts-with(@class, 'icon-external-link ')]",1 )
  
  * switchToPage('SAP CX Backoffice')
  * def hacUrl = driver.url.replace("backoffice/", "hac/"); 

  * driver hacUrl
  * inputIt('input[name=j_username]', 'admin' )
  * clickIt( '{}login') 
  * wrapUp()
  
@ImportCorsFilters
Scenario:
"""
https://portal.commerce.ondemand.com -> Environments -> dev -> Backoffice URL -> <adjust url's /backoffice/xxx to /hac to reach the hac> -> Console -> ImpEx Import  
-> Import content
INSERT_UPDATE OAuthClientDetails;clientId[unique=true]  ;resourceIds   ;scope  ;authorizedGrantTypes  ;authorities   ;clientSecret  ;registeredRedirectUri
  ;client-side  ;hybris  ;basic  ;implicit,client_credentials   ;ROLE_CLIENT   ;secret  ;http://localhost:9001/authorizationserver/oauth2_implicit_callback;
  ;mobile_android   ;hybris  ;basic  ;authorization_code,refresh_token,password,client_credentials  ;ROLE_CLIENT   ;secret  ;http://localhost:9001/authorizationserver/oauth2_callback;
"""
  * driver 'https://portal.commerce.ondemand.com'
  * clickIt( '{a}dev')
  * clickNth("//fd-icon[starts-with(@class, 'icon-external-link ')]",1)
  * switchToPage('SAP CX Backoffice | Login')
  * def hacUrl = driver.url.replace("backoffice/login.zul", "hac/"); 
  * driver hacUrl
  * inputIt('input[name=j_username]', 'admin' )
  * clickIt( '{button}login') 
  * clickIt( '{a}console')
  * clickIt( '{a}ImpEx import')
  * inputIt( '/html/body/div[2]/div[2]/div/div[1]/div[1]/form/fieldset/div[1]/div[1]/div[5]/div/div[1]/div/div/div/div[3]/div/pre', 'INSERT_UPDATE OAuthClientDetails;clientId[unique=true]    ;resourceIds       ;scope        ;authorizedGrantTypes                                            ;authorities             ;clientSecret    ;registeredRedirectUri')
  * appendIt('/html/body/div[2]/div[2]/div/div[1]/div[1]/form/fieldset/div[1]/div[1]/div[5]/div/div[1]/div/div/div/div[3]/div/pre', [Key.ENTER,'                                   ;client-side              ;hybris            ;basic        ;implicit,client_credentials                                     ;ROLE_CLIENT             ;secret          ;http://localhost:9001/authorizationserver/oauth2_implicit_callback;'])
  * appendIt('/html/body/div[2]/div[2]/div/div[1]/div[1]/form/fieldset/div[1]/div[1]/div[5]/div/div[1]/div/div/div/div[3]/div/pre',[Key.ENTER,';mobile_android           ;hybris            ;basic        ;authorization_code,refresh_token,password,client_credentials    ;ROLE_CLIENT             ;secret          ;http://localhost:9001/authorizationserver/oauth2_callback;'])
  * clickIt( '/html/body/div[2]/div[2]/div/div[1]/div[1]/form/fieldset/p/input[2]')
  * clickIt( '/html/body/div[2]/div[2]/div/div[1]/div[1]/form/fieldset/p/input[1]')
  * wrapUp()


@RegisterInSpartacus
Scenario:
"""
https://portal.commerce.ondemand.com ->  Environments -> dev -> JS Storefront URL -> Sign In / Register -> Register ->
  -> Register yourself
  -> Check both checkboxes
  -> Register
"""
  * driver 'https://portal.commerce.ondemand.com'
  * clickIt( '{a}dev')
  * clickNth("//fd-icon[starts-with(@class, 'icon-external-link ')]",2)
  * switchToPage('Homepage')
  * clickIt( '{a}Sign In / Register')
  * clickIt( '{a}Register')
  * inputIt( 'input[name=firstname]', 'Test')
  * inputIt( 'input[name=lastname]', 'User')
  * inputIt( 'input[name=email]', 'test@user.com')
  * inputIt( 'input[name=password]', 'Testing123!')
  * inputIt( 'input[name=confirmpassword]', 'Testing123!')
  * clickIt( 'input[name=newsletter]')
  * clickIt( 'input[name=termsandconditions]')
  * clickIt( 'button[type=submit]' )
  * wrapUp()


@MakeFirstPurchaseWithVisa4444333322221111
Scenario:
"""
https://portal.commerce.ondemand.com ->  Environments -> dev -> JS Storefront URL -> <Purchase something>
"""
  * driver 'https://portal.commerce.ondemand.com'
  * clickIt( '{a}dev')
  * clickNth("//fd-icon[starts-with(@class, 'icon-external-link ')]",2)
  * switchToPage('Homepage')
  * clickIt( '{h3}DSC-T90')
  * clickIt( '{button}Add to cart')
  * clickIt( '{a}proceed to checkout')
  * inputIt( 'input[type=email]', 'test@user.com')
  * inputIt( 'input[type=password]', 'Testing123!')
  * clickIt( 'button[type=submit]' )
  * delay(delays)
  * mouse(  '/html/body/app-root/cx-storefront/main/cx-page-layout/cx-page-slot[2]/cx-shipping-address/cx-address-form/form/div[1]/div/div[1]/div/label/ng-select/div').down().up()
  * clickIt( '{}Albania')
  * inputIt( 'input[formcontrolname=firstName]', 'Test')
  * inputIt( 'input[formcontrolname=lastName]', 'User')
  * inputIt( 'input[formcontrolname=line1]', 'AStreet')
  * inputIt( 'input[formcontrolname=town]', 'ATown')
  * inputIt( 'input[formcontrolname=line1]', 'TU1')
  * inputIt( 'input[formcontrolname=postalCode]', '80798')
  * clickIt( '{button}Continue')
  * clickIt( '{button}Continue')
  * delay(delays)
  * mouse( '/html/body/app-root/cx-storefront/main/cx-page-layout/cx-page-slot[2]/cx-payment-method/cx-payment-form/form/div[1]/div/div[1]/div/label/ng-select/div').down().up()
  * clickIt( '{}Visa')
  * inputIt( 'input[formcontrolname=accountHolderName]', 'Test User')
  * inputIt( 'input[formcontrolname=cardNumber]', '4444333322221111')
  * mouse( '/html/body/app-root/cx-storefront/main/cx-page-layout/cx-page-slot[2]/cx-payment-method/cx-payment-form/form/div[1]/div/div[4]/div[1]/fieldset/label[1]/ng-select/div').down().up()
  * clickIt( '{}01')
  * mouse( '/html/body/app-root/cx-storefront/main/cx-page-layout/cx-page-slot[2]/cx-payment-method/cx-payment-form/form/div[1]/div/div[4]/div[1]/fieldset/label[2]/ng-select/div').down().up()
  * clickIt( '{}2024')
  * inputIt( 'input[formcontrolname=cvn]', '123')
  * clickIt( '{button}Continue')
  * clickIt( 'input[formcontrolname=termsAndConditions]')
  * clickIt( '{button}Place Order')
  * wrapUp()
