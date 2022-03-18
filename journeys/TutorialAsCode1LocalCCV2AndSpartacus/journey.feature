Feature: TutorialAsCode

Background:
  * def delays = 10000
  * def inputIt = function(loc, v) { retry(5, delays); waitFor(loc).highlight(); script(loc, "_.value = ''"); input (loc, v )  }
  * def appendIt = function(loc, v) { retry(5, delays); waitFor(loc).highlight(); inputIt(loc, v )   }
  * def clickIt =  function(loc) { retry(20).highlight(loc).click ()   }
  * def clickOptional = function(loc) { delay(delays); optional(loc).highlight().click()   }
  * def wrapUp = function() { delay(30000) }

@LoginToCommerceCloudViaWarning2
Scenario:
"""
https://localhost:9002 -> Advanced -> Proceed to localhost (unsafe) -> username=admin -> password=nimda -> LOGIN
""" 
  * driver 'https://localhost:9002'
  * clickIt( '{button}Advanced')
  * clickIt( '{a}Proceed to localhost (unsafe)')
  * inputIt( 'input[name=j_username]', "admin")
  * inputIt( 'input[name=j_password]', "nimda")
  * clickIt'button[type=submit]' )
  * wrapUp()

@LoginToSpartacusViaWarning
Scenario:
"""
https://localhost:4200 -> Advanced -> Proceed to localhost (unsafe)
""" 
  * driver 'https://localhost:4200'
  * clickIt( '{button}Advanced')
  * clickIt( '{a}Proceed to localhost (unsafe)')
  * clickIt( '{a}Sign In / Register')
  * wrapUp()

@SpartacusCustomVoucher
Scenario:
"""
https://localhost:4200 -> Photosmart E317 Digital Camera -> custom-product-summary works!
"""
  * driver 'https://localhost:4200'
  * clickOptional( '{button}Advanced')
  * clickOptional( '{a}Proceed to localhost (unsafe)')
  * clickIt( '{^}Photosmart E317 Digital Camera')
  * clickIt( '{}custom-product-summary works!')
  * wrapUp()


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
  * clickIt( '{}Advanced') 
  * clickIt( '{}Proceed to localhost (unsafe)') 
  * inputIt( 'input[name=j_username]', 'admin' )
  * inputIt( 'input[name=j_password]', 'nimda' )
  * clickIt( '{}login') 
  * clickIt( '{a}console')
  * clickIt( '{a}ImpEx import')
  * inputIt( '/html/body/div[1]/div[2]/div/div[1]/div[1]/form/fieldset/div[1]/div[1]/div[5]/div/div[1]/div/div/div/div[3]/div/pre', 'INSERT_UPDATE OAuthClientDetails;clientId[unique=true]    ;resourceIds       ;scope        ;authorizedGrantTypes                                            ;authorities             ;clientSecret    ;registeredRedirectUri')
  * appendIt( '/html/body/div[1]/div[2]/div/div[1]/div[1]/form/fieldset/div[1]/div[1]/div[5]/div/div[1]/div/div/div/div[3]/div/pre', [Key.ENTER,'                                   ;client-side              ;hybris            ;basic        ;implicit,client_credentials                                     ;ROLE_CLIENT             ;secret          ;http://localhost:9001/authorizationserver/oauth2_implicit_callback;'])
  * appendIt( '/html/body/div[1]/div[2]/div/div[1]/div[1]/form/fieldset/div[1]/div[1]/div[5]/div/div[1]/div/div/div/div[3]/div/pre',[Key.ENTER,';mobile_android           ;hybris            ;basic        ;authorization_code,refresh_token,password,client_credentials    ;ROLE_CLIENT             ;secret          ;http://localhost:9001/authorizationserver/oauth2_callback;'])
  * clickIt( '/html/body/div[1]/div[2]/div/div[1]/div[1]/form/fieldset/p/input[2]')
  * clickIt( '/html/body/div[1]/div[2]/div/div[1]/div[1]/form/fieldset/p/input[1]')
  * wrapUp()

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
  * clickIt( '{}Advanced')c
  * clickIt( '{}Proceed to localhost (unsafe)') 
  * inputIt( 'input[name=j_username]', 'admin' )
  * inputIt( 'input[name=j_password]', 'nimda' )
  * clickIt( '{}login') 
  * clickIt( '{a}platform')
  * clickIt( '{a}configuration')
  * inputIt( 'input[id=configKey]', 'corsfilter.ycommercewebservices.allowedOrigins')
  * inputIt( 'input[id=configValue]', 'http://localhost:4200 https://localhost:4200')
  * delay( delays )
  * clickIt( 'button[id=addButton]')
  * delay( delays )
  * inputIt( 'input[id=configKey]', 'corsfilter.ycommercewebservices.allowedMethods')
  * inputIt( 'input[id=configValue]', 'GET HEAD OPTIONS PATCH PUT POST DELETE')
  * delay( delays )
  * clickIt( 'button[id=addButton]')
  * delay( delays )
  * inputIt( 'input[id=configKey]', 'corsfilter.ycommercewebservices.allowedHeaders')
  * inputIt( 'input[id=configValue]', 'origin content-type accept authorization cache-control if-none-match x-anonymous-consents')
  * delay( delays )
  * clickIt( 'button[id=addButton]')
  * delay( delays )
  * clickIt( '{button}apply all')
  * wrapUp()