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

@SpartacusCustomVoucher
Scenario:
"""
https://localhost:4200 -> Photosmart E317 Digital Camera -> custom-product-summary works!
"""
  * driver 'https://localhost:4200'
  * watchForOptional( '{button}Advanced')
  * watchForOptional( '{a}Proceed to localhost (unsafe)')
  * delay(delays)
  * delay(delays)
  * watchFor( '{^}Photosmart E317 Digital Camera')
  * watchFor( '{}custom-product-summary works!')
  * delay(delays)


  
