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
  * def btpMouseClick = function(loc) { delay(delays); highlight(loc); mouse(loc).click }

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
  * delay(delays); 
