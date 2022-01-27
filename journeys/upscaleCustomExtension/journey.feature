Feature: UpscaleNativeExtension

Background:
  * def delays = 10000
  * def watchInput = function(loc, v) { waitFor(loc).highlight(); script(loc, "_.value = ''"); input(loc, v )  }
  * def watchSubmit = function() { waitFor('input[type=submit]').highlight(); click('input[type=submit]') }
  * def watchFor =  function(loc) {  waitFor(loc).highlight().click()   }
  * def watchForOptional =  function(loc) { delay(delays); optional(loc).highlight().click()   }

@logvariables
Scenario:
  * print "MY_UPSCALE_WORKBENCH is "+MY_UPSCALE_WORKBENCH
  * print "MY_UPSCALE_EMAIL is "+MY_UPSCALE_EMAIL
  * print "MY_JOURNEY_DIR is "+MY_JOURNEY_DIR
  * print "MY_UPSCALE_PASSWORD is "+MY_UPSCALE_PASSWORD
  * print "MY_GITHUB_TOKEN is "+MY_GITHUB_TOKEN
  * print "MY_GITHUB_USERNAME is "+MY_GITHUB_USERNAME
  * print "MY_DOWNLOAD_FOLDER is "+MY_DOWNLOAD_FOLDER
  * print "NOW is "+NOW 
  * assert  MY_UPSCALE_WORKBENCH != "" 

@login
Scenario:
  * driver MY_UPSCALE_WORKBENCH
  * call read('journey.feature@logvariables')
  * watchInput('input[id=email]', MY_UPSCALE_EMAIL)
  * watchInput('input[id=password]', MY_UPSCALE_PASSWORD)
  * watchSubmit()
  * delay(delays)

@CreateCustomExtension
Scenario:
"""
YourUpscaleWorkbenchURL -> Advanced Settings -> Extensions -> + -> Custom component ->
  Name=my-extension${NOW}
  Source URL=http://localhost:3000
  -> Save
"""
  * call read('journey.feature@login')
  * watchFor('{}Advanced Settings')
  * watchFor('a[id=side-navigation-subitem-extensions]')
  * delay(delays)
  * watchFor('div[class=new-button]')
  * watchFor('{}Custom component')
  * delay(delays)
  * below('{}Name').highlight().input('my-extension'+NOW)
  * below('{}Source URL').highlight().input('http://localhost:3000')
  * watchFor('{span}Save')
  * delay(delays)


@AddEventBindings
Scenario:
"""
YourUpscaleWorkbenchURL -> Advanced Settings -> Extensions -> <your Extension> -> Add event subscription 
  -> Choose event type to subscribe to -> browse_category_click -> Subscribe -> Choose an attribute to map in the event 
    -> category.id -> Add field -> Choose an attribute to map in the event -> category.name -> Add field -> Add event subscription 
  -> Choose event type to subscribe to -> browse_product_click -> Subscribe ->  Choose an attribute to map in the event
    -> product.id -> Add field -> Choose an attribute to map in the event -> product  -> Add field 
  -> Save
YourUpscaleWorkbenchURL -> Experiences -> Coffeefy Mobile Commerce Experience -> Browse -> Component -> Custom 
  ->  Extension ID=<the Extension ID noted in the previous click path>
  -> Show fallback image -> Fallback image URL = https://avatars.githubusercontent.com/u/2531208
  -> Save
"""
  * call read('journey.feature@login')
  * watchFor('{}Advanced Settings')
  * watchFor('a[id=side-navigation-subitem-extensions]')
  * watchForOptional("//span[@class='ng-star-inserted'][last()]" )
  * delay(delays)
  * locate('{}my-extension'+NOW).parent.lastChild.highlight()
  * def extensionID = locate('{}my-extension'+NOW).parent.lastChild.text.trim()
  * print 'extensionID is '+extensionID
  * watchFor('{}my-extension'+NOW)
  * watchFor('{}Add event subscription')
  * watchFor('{}Choose event type to subscribe to')
  * watchFor('{span}browse_category_click')
  * watchFor('{}Subscribe')
  * watchFor('{}Choose an attribute to map in the event')
  * watchFor('{span}category.id')
  * watchFor('{span}Add field')
  * watchFor('{}Choose an attribute to map in the event')
  * watchFor('{span}category.name')
  * watchFor('{span}Add field')
  * watchFor('{}Add event subscription')
  * watchFor('{}Choose event type to subscribe to')
  * watchFor('{span}browse_product_click')
  * watchFor('{}Subscribe')
  * watchFor('{:2}Choose an attribute to map in the event')
  * watchFor('{span}product.id')
  * watchFor('{span:2}Add field')
  * watchFor('{:2}Choose an attribute to map in the event')
  * watchFor('{span}product')
  * watchFor('{span:2}Add field')
  * watchFor('{span}Save')
  * delay(delays)
  
  * watchFor('{span}Experiences')
  * watchFor('{div}Coffeefy Mobile Commerce Experience')
  * watchFor('{}Browse')
  * watchFor('{}Component')
  * watchFor('{}Custom')
  * watchInput('input[id=extensionId]', extensionID )
  * watchInput('input[id=nativeComponentIdentifier]', '')
  * watchFor('{^}Show fallback image')
  * watchInput('input[id=fallbackImageUrl]', 'https://avatars.githubusercontent.com/u/2531208')
  * watchFor('{button}Save')
  * watchFor('{}Component updated.')
  * delay(delays)

@PreviewAndSendEvents
Scenario:
"""
YourUpscaleWorkbenchURL -> Experiences -> Coffeefy Mobile Commerce Experience -> Preview -> Preview -> I Agree -> Coffee Makers -> Drinkware -> Cups -> JURA 65037
"""
  * call read('journey.feature@login')
  * watchFor('{span}Experiences')
  * watchFor('{div}Coffeefy Mobile Commerce Experience')
  * watchFor('{^}Preview')
  * watchFor('{:2}Preview')
  * delay(delays)
  * switchPage('Upscale Commerce Experience Preview')
  * watchForOptional('{button}I Agree')
  * switchPage('Upscale Commerce Experience Preview')
  * watchFor('{^}Grinders')
  * watchFor('{^}Saeco, CA6804/47, Coffee grinder')
  * delay(delays)

@CheckForEvents
Scenario:
"""
http://localhost:3000/events -> <Confirm you see Upscale events listed>
"""
http
  * driver "http://localhost:3000/events"
  * waitFor('{^}eventType')
  * delay(delays)

