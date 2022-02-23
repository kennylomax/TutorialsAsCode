Feature: CommerceCloud

Background:
  * def delays = 10000
  * def setVal = function(loc, v){ script(loc, "_.value = v");}
  * def watchInput = function(loc, v) {  delay(delays); waitFor(loc).highlight(); script(loc, "_.value = ''"); input(loc, v )  }
  * def watchAppendInput = function(loc, v) {  delay(delays); waitFor(loc).highlight(); input(loc, v, 200 )  }
  * def watchSubmit = function() {  delay(delays); waitFor('button[type=submit]').highlight(); click('button[type=submit]') }
  * def watchFor =  function(loc) {    delay(delays);  waitFor(loc).highlight().click()  }
  * def watchForOptional =  function(loc) { delay(delays); optional(loc).highlight().click()   }
  * def btpMouseDownUp = function(loc) { delay(delays); highlight(loc); mouse(loc).down().up() }
  * def btpMouseClick = function(loc) { delay(delays); highlight(loc); mouse(loc).click()}

@AddKymaNamespace
Scenario:
"""
KYMA_COCKPIT -> Add new namespace ->
  name=mykymanamespace
"""
  * driver KYMA_COCKPIT
  * delay(delays)
  * watchFor( '/html/body/div/div[2]/div[2]/div[1]/div/div[1]/button')
  * watchFor( '{}+ New Namespace')
  * switchFrame(0)
  * input('body', ["mykymanamespace",Key.ENTER],500)
  * delay(delays)

@CreateBTPSystem
Scenario:
"""
https://account.hanatrial.ondemand.com -> Go To Your Trial Account -> System Landscape -> Systems -> Register System -> 
  System Name = Something
  Type = SAP Commerce Cloud
  -> Register
  -> Copy the token to your clipboard
"""
  * driver "https://account.hanatrial.ondemand.com"
  * btpMouseDownUp('{}Go To Your Trial Account')
  * btpMouseDownUp('{}System Landscape')
  * btpMouseDownUp('{}Systems')
  * btpMouseDownUp('{}Register System')

  * delay(delays)
  * input('body', "mykymasystem",200)
  * mouse('#newSystemDialogView--systemTypeSelect-arrow').click()
  * mouse("{}SAP Commerce Cloud").down().up()
  * highlight("#newSystemDialogView--registerButton")
  * mouse("#newSystemDialogView--registerButton").click()
  * delay(delays)
  * mouse("#newSystemDialogView--tokenCopyButton").click()
  * delay(delays)


@CreateBTPFormation
Scenario:
"""
https://account.hanatrial.ondemand.com -> Go To Your Trial Account -> System Landscape -> Formations -> Create Formation  -> 
  Name = $(NOW) 
  Select Subaccount=trial
  Select Systems = mykymasystem
  -> Create
"""
  * driver "https://account.hanatrial.ondemand.com"
  * btpMouseDownUp('{}Go To Your Trial Account')
  * btpMouseDownUp('{}System Landscape')
  * btpMouseDownUp('{}Formations')
  * btpMouseDownUp('{}Create Formation')
  * watchAppendInput('{input:0}', "myformation")
  * btpMouseDownUp('span[class=sapMSltLabel]')
  * btpMouseDownUp('{*:2}trial')
  * watchAppendInput( '{input:3}', ["m",Key.ENTER])
  * btpMouseClick('{}Create')
  # We need Click and DownUp - otherwise the data is not read correctly...
  * btpMouseDownUp('{}Create')  
  * delay(delays); 


@ConfirmSystemAppearsInKyma
Scenario:
"""
KYMA_COCKPIT -> Integration -> Applications/Systems ->  mp-mykymasystem 
"""
  * driver KYMA_COCKPIT
  * delay(delays)
  * watchFor( '{}Applications/Systems')
  * delay(delays)
  * switchFrame(0)
  * watchFor( '{a}mp-mykymasystem')
  * delay(delays)4
  

@PairBackoffice
Scenario:
"""
BACKOFFICE → System → API → Destination Target → Default_Template → Wizard → Paste URL
"""
  * driver BACKOFFICE
  * delay(delays)
  * watchInput('input[name=j_username]', "admin")
  * watchInput('input[name=j_password]', BACKOFFICE_PASSWORD)
  * watchFor( '{}Login')
  * delay(delays)
  * watchFor( '{}System')
  * watchFor( '{}API')
  * watchFor( '{}Destination Targets')
  * watchFor( '{}Default_Template')
  * watchFor( "//img[@src='/backoffice/widgetClasspathResource/widgets/actions/registerdestinationtarget/icons/icon_action_register_destination_target_default.png']")
  * watchInput('input[ytestid=newDestinationTargetId]', "mykmyasystem")
  * btpMouseDownUp( "input[ytestid=newDestinationTargetId]")
  * btpMouseDownUp( "input[ytestid=tokenUrl]")
  * watchFor('{button}Register Destination Target')
  * delay(delays)
  
@createKymaBinding
Scenario:
"""
Kyma → Application/Systems → Create Application → CreateBinding → Namespace
"""
  * driver KYMA_COCKPIT
  * delay(delays)
  * watchFor( '{}Integration')
  * watchFor( '{}Applications/Systems')
  * delay(delays)
  * switchFrame(0)
  * watchFor( '{}mp-mykymasystem')
  * switchFrame(null)
  * delay(delays)
  * switchFrame(0)
  * watchFor( '{^}Namespace Bindings')
  * watchFor( '{^}Create Binding')
  * delay(delays)
  * watchInput("//input[@placeholder='Select namespace']", ["default",Key.ENTER])
  * watchFor('{}Create Namespace Binding')
  * watchFor( '{button}Create')
  * delay(delays)

@setUpEventsInKyma
Scenario:
"""
Kyma → defaultNamespace -> Catalog -> mykymasystem -> CC Events v1 -> + Add -> Create
"""
  * driver KYMA_COCKPIT
  * delay(delays)
  * switchFrame(0)
  * watchFor( '{}default')
  * switchFrame(null)
  * watchFor( '{}Service Management')
  * watchFor( '{}Catalog')
  * switchFrame(null)
  * delay(delays)
  * switchFrame(0)
  * delay(delays)
  * watchFor( '{}mykymasystem')
  * watchFor( '{}CC Events v1')
  * watchFor( '{^}Add')
  * watchFor( '{button}Create')
  * delay(delays)


@createKymaFunction
Scenario:
"""
Kyma -> defaultNamespace -> Workloads -> Functions ->  Create Function -> Create -> 
  Configuration -> Create Event Subscription -> order.created -> Save -> 
  Code ->
    Source = module.exports = { main: function (event, context) { console.log("Hi there"); return "Hello World!";} }
  -> Save
"""
  * driver KYMA_COCKPIT
  * delay(delays)
  * switchFrame(0)
  * watchFor( '{}default')
  * switchFrame(null)
  * watchFor( '{}Workloads')
  * watchFor( '{}Functions')
  * switchFrame(null)
  * delay(delays)
  * switchFrame(0)
  * delay(delays)
  * watchFor( '{^}Create Function')
  * watchFor( '{button}Create')
  * switchFrame(null)
  * delay(delays)
  * switchFrame(0)
  * watchFor( '{}Configuration')
  * watchFor( '{^}Create Event Subscription')
  * switchFrame(0)
  * delay(delays)
  * watchInput('/html/body/div[5]/div/div/div/div[2]/div/div[1]/div[2]/section/section/div/div/div/input', "Submit Order Event")
  * watchFor( '/html/body/div[5]/div/div/div/div[2]/div/div[2]/table/tbody/tr[1]/td[2]/div/label/input')
  * watchFor( '{button}Save')
  * watchFor( '{}Code')
  * delay(delays)
  * watchFor( '{button}Save')
  


