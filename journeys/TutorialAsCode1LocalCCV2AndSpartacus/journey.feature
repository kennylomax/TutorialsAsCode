Feature: TutorialAsCode

Background:
  * def delays = 10000
  * def input = function(loc, v) { waitFor(loc).highlight(); script(loc, "_.value = ''"); input(loc, v )  }
  * def append = function(loc, v) { input(loc, v )  }
  * def click = function(loc) {  waitFor(loc).highlight().click()   }
  * def clickOptional = function(loc) { delay(delays); optional(loc).highlight().click()   }
  * def wrapup = function() { delay(delays);  delay(delays) }

@LoginToCommerceCloudViaWarning2
Scenario:
"""
https://localhost:9002 -> Advanced -> Proceed to localhost (unsafe) -> username=admin -> password=nimda -> LOGIN
""" 
  * driver 'https://localhost:9002'
  * click( '{button}Advanced')
  * click( '{a}Proceed to localhost (unsafe)')
  * input( 'input[name=j_username]', "admin")
  * input( 'input[name=j_password]', "nimda")
  * click('button[type=submit]' )
  * wrapup()

@LoginToSpartacusViaWarning
Scenario:
"""
https://localhost:4200 -> Advanced -> Proceed to localhost (unsafe)
""" 
  * driver 'https://localhost:4200'
  * click( '{button}Advanced')
  * click( '{a}Proceed to localhost (unsafe)')
  * click( '{a}Sign In / Register')
  * wrapup()

@SpartacusCustomVoucher
Scenario:
"""
https://localhost:4200 -> Photosmart E317 Digital Camera -> custom-product-summary works!
"""
  * driver 'https://localhost:4200'
  * clickOptional( '{button}Advanced')
  * clickOptional( '{a}Proceed to localhost (unsafe)')
  * click( '{^}Photosmart E317 Digital Camera')
  * click( '{}custom-product-summary works!')
  * wrapup()


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
  * click( '{}Advanced') 
  * click( '{}Proceed to localhost (unsafe)') 
  * input( 'input[name=j_username]', 'admin' )
  * input( 'input[name=j_password]', 'nimda' )
  * click( '{}login') 
  * click( '{a}console')
  * click( '{a}ImpEx import')
  * input( '/html/body/div[1]/div[2]/div/div[1]/div[1]/form/fieldset/div[1]/div[1]/div[5]/div/div[1]/div/div/div/div[3]/div/pre', 'INSERT_UPDATE OAuthClientDetails;clientId[unique=true]    ;resourceIds       ;scope        ;authorizedGrantTypes                                            ;authorities             ;clientSecret    ;registeredRedirectUri')
  * delay( delays )
  * append( '/html/body/div[1]/div[2]/div/div[1]/div[1]/form/fieldset/div[1]/div[1]/div[5]/div/div[1]/div/div/div/div[3]/div/pre', [Key.ENTER,'                                   ;client-side              ;hybris            ;basic        ;implicit,client_credentials                                     ;ROLE_CLIENT             ;secret          ;http://localhost:9001/authorizationserver/oauth2_implicit_callback;'])
  * delay( delays )
  * append( '/html/body/div[1]/div[2]/div/div[1]/div[1]/form/fieldset/div[1]/div[1]/div[5]/div/div[1]/div/div/div/div[3]/div/pre',[Key.ENTER,';mobile_android           ;hybris            ;basic        ;authorization_code,refresh_token,password,client_credentials    ;ROLE_CLIENT             ;secret          ;http://localhost:9001/authorizationserver/oauth2_callback;'])
  * delay( delays )
  * click( '/html/body/div[1]/div[2]/div/div[1]/div[1]/form/fieldset/p/input[2]')
  * click( '/html/body/div[1]/div[2]/div/div[1]/div[1]/form/fieldset/p/input[1]')
  * wrapup()

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
-> apply all
"""
  * driver 'https://localhost:9002'
  * click( '{}Advanced') 
  * click( '{}Proceed to localhost (unsafe)') 
  * input( 'input[name=j_username]', 'admin' )
  * input( 'input[name=j_password]', 'nimda' )
  * click( '{}login') 
  * click( '{a}platform')
  * click( '{a}configuration')
  * input( 'input[id=configKey]', 'corsfilter.ycommercewebservices.allowedOrigins')
  * input( 'input[id=configValue]', 'http://localhost:4200 https://localhost:4200')
  * delay( delays )
  * click( 'button[id=addButton]')
  * delay( delays )
  * input( 'input[id=configKey]', 'corsfilter.ycommercewebservices.allowedMethods')
  * input( 'input[id=configValue]', 'GET HEAD OPTIONS PATCH PUT POST DELETE')
  * delay( delays )
  * click( 'button[id=addButton]')
  * delay( delays )
  * input( 'input[id=configKey]', 'corsfilter.ycommercewebservices.allowedHeaders')
  * input( 'input[id=configValue]', 'origin content-type accept authorization cache-control if-none-match x-anonymous-consents')
  * delay( delays )
  * click( 'button[id=addButton]')
  * delay( delays )
  * click( '{button}apply all')
  * wrapup()