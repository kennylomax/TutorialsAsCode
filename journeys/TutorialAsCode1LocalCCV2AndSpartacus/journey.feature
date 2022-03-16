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
  * delay(delays)

@BackofficeUserPassword
Scenario:
"""
https://localhost:9002/backoffice -> username=admin -> password=nimda -> Login -> User -> Customers -> womenvipsilver@hybris.com -> PASSWORD -> New Password=12345 -> Confirm New Password=12345 -> SAVE
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

@SpartacusCustomVoucher
Scenario:
"""
https://localhost:4200 -> Photosmart E317 Digital Camera -> custom-product-summary works!
"""
  * driver 'https://localhost:4200'
  * watchForOptional( '{button}Advanced')
  * watchForOptional( '{a}Proceed to localhost (unsafe)')
  * delay(60000)
  * watchFor( '{^}Photosmart E317 Digital Camera')
  * watchFor( '{}custom-product-summary works!')
  * delay(delays)


@ImportCorsFilters
Scenario:
"""
https://localhost:9002 -> Console -> ImpEx Import 
 -> Import content
INSERT_UPDATE OAuthClientDetails;clientId[unique=true]  ;resourceIds   ;scope  ;authorizedGrantTypes  ;authorities   ;clientSecret  ;registeredRedirectUri
  ;client-side  ;hybris  ;basic  ;implicit,client_credentials   ;ROLE_CLIENT   ;secret  ;http://localhost:9001/authorizationserver/oauth2_implicit_callback;
  ;mobile_android   ;hybris  ;basic  ;authorization_code,refresh_token,password,client_credentials  ;ROLE_CLIENT   ;secret  ;http://localhost:9001/authorizationserver/oauth2_callback;
"""
  * driver 'https://localhost:9002'
  * watchFor( '{}Advanced') 
  * watchFor( '{}Proceed to localhost (unsafe)') 
  * delay(delays)
  * input('input[name=j_username]', 'admin' )
  * input('input[name=j_password]', 'nimda' )
  * watchFor( '{}login') 
  * delay(delays)
  * watchFor('{a}console')
  * watchFor('{a}ImpEx import')
  * watchInput( '/html/body/div[1]/div[2]/div/div[1]/div[1]/form/fieldset/div[1]/div[1]/div[5]/div/div[1]/div/div/div/div[3]/div/pre', 'INSERT_UPDATE OAuthClientDetails;clientId[unique=true]    ;resourceIds       ;scope        ;authorizedGrantTypes                                            ;authorities             ;clientSecret    ;registeredRedirectUri')
  * watchAppendInput('/html/body/div[1]/div[2]/div/div[1]/div[1]/form/fieldset/div[1]/div[1]/div[5]/div/div[1]/div/div/div/div[3]/div/pre', [Key.ENTER,'                                   ;client-side              ;hybris            ;basic        ;implicit,client_credentials                                     ;ROLE_CLIENT             ;secret          ;http://localhost:9001/authorizationserver/oauth2_implicit_callback;'])
  * watchAppendInput( '/html/body/div[1]/div[2]/div/div[1]/div[1]/form/fieldset/div[1]/div[1]/div[5]/div/div[1]/div/div/div/div[3]/div/pre',[Key.ENTER,';mobile_android           ;hybris            ;basic        ;authorization_code,refresh_token,password,client_credentials    ;ROLE_CLIENT             ;secret          ;http://localhost:9001/authorizationserver/oauth2_callback;'])
  * watchFor('/html/body/div[1]/div[2]/div/div[1]/div[1]/form/fieldset/p/input[2]')
  * delay(delays)
  * watchFor('/html/body/div[1]/div[2]/div/div[1]/div[1]/form/fieldset/p/input[1]')
  * delay(delays)

@AddCorsFilterProperties
Scenario:
"""
https://localhost:9002 -> Platform -> Configuration
-> New key...=corsfilter.ycommercewebservices.allowedOrigins
-> New value...=http://localhost:4200 https://localhost:4200
-> add
-> New key...=corsfilter.ycommercewebservices.allowedMethods
-> New value...=GET HEAD OPTIONS PATCH PUT POST DELETE
-> add
-> New key...=corsfilter.ycommercewebservices.allowedHeaders
-> New value...=origin content-type accept authorization cache-control if-none-match x-anonymous-consents
-> add
"""
  * driver 'https://localhost:9002'
  * watchFor( '{}Advanced') 
  * watchFor( '{}Proceed to localhost (unsafe)') 
  * delay(delays)
  * input('input[name=j_username]', 'admin' )
  * input('input[name=j_password]', 'nimda' )
  * watchFor( '{}login') 
  * delay(5000)
  * watchFor('{a}platform')
  * watchFor('{a}configuration')
  * watchInput( 'input[id=configKey]', 'corsfilter.ycommercewebservices.allowedOrigins')
  * watchInput( 'input[id=configValue]', 'http://localhost:4200 https://localhost:4200')
  * watchFor( 'button[id=addButton]')
  * watchInput( 'input[id=configKey]', 'corsfilter.ycommercewebservices.allowedMethods')
  * watchInput( 'input[id=configValue]', 'GET HEAD OPTIONS PATCH PUT POST DELETE')
  * watchFor( 'button[id=addButton]')
  * watchInput( 'input[id=configKey]', 'corsfilter.ycommercewebservices.allowedHeaders')
  * watchInput( 'input[id=configValue]', 'origin content-type accept authorization cache-control if-none-match x-anonymous-consents')
  * watchFor( 'button[id=addButton]')
  * delay(10000)