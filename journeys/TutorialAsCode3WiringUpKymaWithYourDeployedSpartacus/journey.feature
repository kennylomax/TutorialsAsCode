Feature: CommerceCloud

Background:
  * def delays = 10000
  * def waitFrame = function(f) { delay(delays); switchFrame(f) }
  * def resetFrame = function(f) { waitFrame(null); waitFrame(f) }
  * def watchInput = function(loc, v) {  delay(delays); waitFor(loc).highlight(); script(loc, "_.value = ''"); input(loc, v )  }
  * def reframeThenWatchInput = function(f, loc, v) { waitFrame(f);  delay(delays); waitFor(loc).highlight(); script(loc, "_.value = ''"); input(loc, v )  }
  * def watchAppendInput = function(loc, v) {  delay(delays); waitFor(loc).highlight(); input(loc, v, 200 )  }
  * def watchSubmit = function() {  delay(delays); waitFor('button[type=submit]').highlight(); click('button[type=submit]') }
  * def reframeThenWatchFor =  function(f, loc) { waitFrame(f);  delay(delays);  waitFor(loc).highlight().click()  }
  * def watchFor =  function(loc) {    delay(delays);  waitFor(loc).highlight().click()  }
  * def watchForOptional =  function(loc) { delay(delays); optional(loc).highlight().click()   }
  * def btpMouseDownUp = function(loc) { delay(delays); highlight(loc); mouse(loc).down().up() }
  * def btpMouseClick = function(loc) { delay(delays); highlight(loc); mouse(loc).click()}
  * def btpMouseClickDownUp = function(loc) { delay(delays); highlight(loc); mouse(loc).click(); delay(delays); mouse(loc).down().up() }
  * def waitPage = function(p) { delay(delays); delay(delays); switchPage(p) }
  * def wrapup = function() { delay(delays);  delay(delays) }

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
BACKOFFICE → System → API → Destination Target → Default_Template → Wizard →
  -> TOken URL = <Paste URL that you copied earlier>
  -> New Destination's Id = mykmyasystem{UNIQUEID}
  -> Register Destination Target
"""
  * driver BACKOFFICE
  * watchInput('input[name=j_username]', "admin")
  * watchInput('input[name=j_password]', BACKOFFICE_PASSWORD)
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
KymaCockpit-> Integration -> Applications → mp-mykmyasystem20220314a → Create Namespace Binding 
  -> Namespace = 20220314a
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
