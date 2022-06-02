Feature: CommerceCloud

Background:
  * def KYMA_DASHBOARD = "http://localhost:3001?kubeconfigID=config.yaml"
  * def delays = 10000
  * def inputIt = function(loc, v) { retry(5, delays); waitFor(loc).highlight(); script(loc, "_.value = ''"); input (loc, v )  }
  * def appendIt = function(loc, v) { retry(5, delays); waitFor(loc).highlight(); inputIt(loc, v )   }
  * def clickIt =  function(loc) { retry(20).highlight(loc).click ()   }
  * def clickOptional = function(loc) { delay(delays); optional(loc).highlight().click()   }
  * def wrapUp = function() { delay(30000) }


  # Perhaps needed for Kyma Dhasboard
  # * driver "https://account.hanatrial.ondemand.com"
  # * delay(delays)
  # * btpMouseDownUp( '{}Go To Your Trial Account')
  # * btpMouseDownUp( '{}trial')
  # * btpMouseDownUp( '{}Link to dashboard')
  # * waitPage('Cluster Overview')

@AddKymaNamespace
Scenario:
"""
KymaCockpit -> Namespaces  -> Create Namespace 
  Name={UNIQUEID} 
-> Create
"""
  * driver KYMA_COCKPIT
  * watchFor( '{span}Namespaces')
  * reframeThenWatchFor( 0,'{span}Create Namespace' )
  * reframeThenWatchInput( 0, '/html/body/div[5]/div/div/div[2]/section/form/div[1]/div/div[2]/div/div/div/input', ""+UNIQUEID )
  * watchFor( '{span}Create')
  * wrapup()

@CreateBTPSystem
Scenario:
"""
BTP_COCKPIT -> Go To Your Trial Account -> System Landscape -> Systems -> Register System -> 
  System Name = mykymasystem
  Type = SAP Commerce Cloud
  -> Register
  -> Copy the token to your clipboard
"""
  * driver BTP_COCKPIT
  * btpMouseDownUp('{}Go To Your Trial Account')
  * btpMouseDownUp('{}System Landscape')
  * btpMouseDownUp('{}Systems')
  * btpMouseDownUp('{}Register System')
  * delay(delays)
  * input('body', "mykymasystem"+UNIQUEID, 100)
  #* watchInput('input[id="newSystemDialogView--systemNameInput-inner"]', "mykymasystem"+UNIQUEID, 100)
  * btpMouseClick('#newSystemDialogView--systemTypeSelect-arrow')
  * btpMouseDownUp("{}SAP Commerce Cloud")
  * btpMouseClick("#newSystemDialogView--registerButton")
  * btpMouseClick("#newSystemDialogView--tokenCopyButton")
  * wrapup()

@CreateBTPFormation
Scenario:
"""
BTP_COCKPIT -> Go To Your Trial Account -> System Landscape -> Formations -> Create Formation  -> 
  Name = myformation{UNIQUEID}
  Select Subaccount=trial
  Select Systems = mykymasystem{UNIQUEID}
  -> Create
"""
  * driver BTP_COCKPIT
  * btpMouseDownUp('{}Go To Your Trial Account')
  * btpMouseDownUp('{}System Landscape')
  * btpMouseDownUp('{}Formations')
  * btpMouseDownUp('{}Create Formation')
  * watchAppendInput('{input:0}', "myformation"+UNIQUEID  )
  * btpMouseDownUp('span[class=sapMSltLabel]')
  * btpMouseDownUp('{*:2}trial')
  # Selected Systems
  * watchInput( '/html/body/div[1]/div[1]/section/div/div/div/div/div/div/div[6]/div/div/input', "mykymasystem"+UNIQUEID )
  * btpMouseDownUp('{*:1}mykymasystem'+UNIQUEID)
  * btpMouseClickDownUp('{}Create')
  * wrapup()

@ConfirmSystemAppearsInKyma
Scenario:
"""
KymaCockpit -> Integration -> Applications ->  mp-mykymasystem{UNIQUEID}
"""
  * driver KYMA_COCKPIT
  * delay(delays)
  * watchFor( '{span}Integration')
  * watchFor( '{span}Applications')
  * reframeThenWatchFor( 0, '{a}mp-mykymasystem'+UNIQUEID)
  * wrapup()


@PairBackoffice
Scenario:
"""
https://localhost:9002/backoffice → System → API → Destination Target → Default_Template → Wizard →
  -> TOken URL = <Paste URL that you copied earlier>
  -> New Destination's Id = mykmyasystem{UNIQUEID}
  -> Register Destination Target
"""
  * driver https://localhost:9002/backoffice
  * watchInput('input[name=j_username]', "admin")
  * watchInput('input[name=j_password]', "nimda")
  * watchFor( '{}Login')
  * watchFor( '{}System')
  * watchFor( '{}API')
  * watchFor( '{}Destination Targets')
  * watchFor( '{}Default_Template')
  * watchFor( "//img[@src='/backoffice/widgetClasspathResource/widgets/actions/registerdestinationtarget/icons/icon_action_register_destination_target_default.png']")
  * watchInput('input[ytestid=newDestinationTargetId]', "mykmyasystem"+UNIQUEID)
  * btpMouseDownUp( "input[ytestid=newDestinationTargetId]")
  * btpMouseDownUp( "input[ytestid=tokenUrl]")
  * watchFor('{button}Register Destination Target')
  * wrapup()

@createKymaBinding
Scenario:
"""
KymaCockpit-> Integration -> Applications → commerce → Create Namespace Binding 
  -> Namespace = default
  -> Create
"""
  * driver KYMA_COCKPIT
  * watchFor( '{}Integration')
  * watchFor( '{}Applications')
  * reframeThenWatchFor( 0, '{}mp-mykymasystem'+UNIQUEID)
  * resetFrame(0)
  * watchFor( '{^}Create Namespace Binding')
  * watchInput("//input[@placeholder='Namespace']", ""+UNIQUEID)
  * watchFor('{b}'+UNIQUEID)
  * watchFor( '{span}Create')
  * wrapup()


@setUpEventsInKyma
Scenario:
"""
Kyma → defaultNamespace -> Catalog -> mykymasystem20220314a -> + Add -> Create
"""
  * driver KYMA_COCKPIT
  * watchFor( '{span}Namespaces')
  * reframeThenWatchFor( 0, '{}'+UNIQUEID)
  * reframeThenWatchFor( null, '{}Service Management')
  * watchFor( '{}Catalog')
  * resetFrame(0)
  * watchFor( '{}mykymasystem'+UNIQUEID)
  * watchFor( '{^}Add')
  * watchFor( '{span}Create')
  * wrapup()

@createKymaFunction
Scenario:
"""
Kyma -> Namespaces -> 20220314a -> Workloads -> Functions ->  Create Function -> Create -> 
  Configuration -> Create Subscription -> order.created -> Save -> 
  Code ->
    Source = module.exports = { main: function (event, context) { console.log("Hi there"); return "Hello World!";} }
  -> Save
"""
  * driver KYMA_COCKPIT
  * delay(delays)
  * watchFor( '{span}Namespaces')
  * reframeThenWatchFor( 0,  '{}'+UNIQUEID)
  * reframeThenWatchFor( null, '{}Workloads')
  * watchFor( '{}Functions')
  * resetFrame(0)
  * watchFor( '{^}Create Function')
  * watchFor( '{span}Create')
  * resetFrame(0)
  * watchFor( '{}Configuration')
  * watchFor( '{^}Create Subscription')
  # Name
  * watchInput('/html/body/div[6]/div/div/div[2]/section/form/div[1]/div[1]/div[2]/div/div/div/input', "submitorder")
  # Application name
  * watchFor( '/html/body/div[6]/div/div/div[2]/section/form/div[1]/div[4]/div[2]/div/div/div/div/div/div/div/div/div/span/button/i')
  * watchFor( '{}mp-mykymasystem'+UNIQUEID)
  # Event name
  * watchInput(  '/html/body/div[6]/div/div/div[2]/section/form/div[1]/div[5]/div[2]/div/div/div/input',  "order.created")
  # Event version
  * watchFor( '/html/body/div[6]/div/div/div[2]/section/form/div[1]/div[6]/div[2]/div/div/div/div/div/div/div/div/div/span/button/i')
  * watchFor( '{}v1')
  * watchFor( '{span}Create')
  * wrapup()


@MakeFirstPurchaseWithVisa4444333322221111
Scenario:
"""
https://jsapps.{MY_COMMERCE_CLOUD_DOMAIN}...
"""
  * def spartacusURL = 'https://jsapps.'+MY_COMMERCE_CLOUD_DOMAIN
  * driver spartacusURL
  * watchFor( '{h3}DSC-T90')
  * watchFor( '{button}Add to cart')
  * watchFor( '{a}proceed to checkout')
  * watchInput( 'input[type=email]', 'bob@thebuilder.com')
  * watchInput( 'input[type=password]', 'Builder123!')
  * watchSubmit()
  * waitFor('/html/body/app-root/cx-storefront/main/cx-page-layout/cx-page-slot[2]/cx-shipping-address/cx-address-form/form/div[1]/div/div[1]/div/label/ng-select').highlight()
  * mouse( '/html/body/app-root/cx-storefront/main/cx-page-layout/cx-page-slot[2]/cx-shipping-address/cx-address-form/form/div[1]/div/div[1]/div/label/ng-select').click()
  * watchFor( '{}Albania')
  * watchInput( 'input[formcontrolname=firstName]', 'Bob')
  * watchInput( 'input[formcontrolname=lastName]', 'Builder')
  * watchInput( 'input[formcontrolname=line1]', 'BobStreet')
  * watchInput( 'input[formcontrolname=town]', 'BobTown')
  * watchInput( 'input[formcontrolname=line1]', 'Bob1')
  * watchInput( 'input[formcontrolname=postalCode]', '80798')
  * watchFor( '{button}Continue')
  * watchFor( '{button}Continue')
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
  * watchFor( 'input[formcontrolname=termsAndConditions]')
  * watchFor( '{button}Place Order')
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


@Was AddCorsKymaProperties
Scenario:
"""
https://localhost:9002 -> Platform -> Configuration
-> New key...=kymaintegrationservices.truststore.cacerts.path -> New value...=$MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/bin/platform/resources/devcerts/ydevelopers.jks -> add
-> New key...=kymaintegrationservices.truststore.password -> New value...=123456 -> add
-> New key...=ccv2.services.api.url.0 -> New value...=https://host.k3d.internal:9002 -> add
-> New key...=apiregistryservices.events.exporting -> New value...=true -> add
-> New key...=corsfilter.ycommercewebservices.allowedOrigins -> New value...=http://localhost:4200 https://localhost:4200 -> add
-> New key...=corsfilter.ycommercewebservices.allowedMethods -> New value...=GET HEAD OPTIONS PATCH PUT POST DELETE -> add
-> New key...=corsfilter.ycommercewebservices.allowedHeaders -> New value...=origin content-type accept authorization cache-control if-none-match x-anonymous-consents -> add
-> apply all
"""
  * driver 'https://localhost:9002'
  * clickIt( '{}Advanced')
  * clickIt( '{}Proceed to localhost (unsafe)') 
  * inputIt( 'input[name=j_username]', 'admin' )
  * inputIt( 'input[name=j_password]', 'nimda' )
  * clickIt( '{}login') 
  * clickIt( '{a}platform')
  * clickIt( '{a}configuration')



  * delay( delays )
  * inputIt( 'input[id=configKey]', 'kymaintegrationservices.truststore.cacerts.path')
  * inputIt( 'input[id=configValue]', '$MY_JOURNEY_DIR/cloud-commerce-sample-setup/core-customize/hybris/bin/platform/resources/devcerts/ydevelopers.jks')
  * delay( delays )
  * clickIt( 'button[id=addButton]')


  * delay( delays )
  * inputIt( 'input[id=configKey]', 'kymaintegrationservices.truststore.password')
  * inputIt( 'input[id=configValue]', '123456')
  * delay( delays )
  * clickIt( 'button[id=addButton]')


  * delay( delays )
  * inputIt( 'input[id=configKey]', 'ccv2.services.api.url.0')
  * inputIt( 'input[id=configValue]', 'https://host.k3d.internal:9002')
  * delay( delays )
  * clickIt( 'button[id=addButton]')


  * delay( delays )
  * inputIt( 'input[id=configKey]', 'apiregistryservices.events.exporting')
  * inputIt( 'input[id=configValue]', 'true')
  * delay( delays )
  * clickIt( 'button[id=addButton]')


  * delay( delays )
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


@GetKymaConnectionURL
Scenario:
"""
KYMA_DASHBOARD → Integration → Applications → commerce → Connect Application -> Copy to Clipboard
"""
* delay( delays )

