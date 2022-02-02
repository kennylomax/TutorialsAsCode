Feature: CommerceCloud

Background:
  * def delays = 10000
  * def watchInput = function(loc, v) { waitFor(loc).highlight(); script(loc, "_.value = ''"); input(loc, v )  }
  * def watchSubmit = function() { waitFor('button[type=submit]').highlight(); click('button[type=submit]') }
  * def watchFor =  function(loc) {  waitFor(loc).highlight().click()   }
  * def watchForOptional =  function(loc) {  optional(loc).highlight().click()   }

@preflightChecks
Scenario:
  * driver "https://nodejs.org/en/download/"
  * watchFor( '{a}64-bit / ARM64')
  * delay(delays)
  * waitFor( '{a}64-bit / ARM64')

# pushd; popd;

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
  * delay(delays)
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
  * watchFor( '{button}Advanced')
  * delay(delays)
  * watchFor( '{a}Proceed to localhost (unsafe)')
  * delay(delays)
  * delay(delays)
  * watchFor( '{^}Photosmart E317 Digital Camera')
  * watchFor( '{}custom-product-summary works!')
  * delay(delays)

#pushd ${TESTING_HOME}; mvn clean test -Dkarate.options='--tags @CreateCCRepo' -Dtest=\!JourneyTest#runThruTutorial;  popd;
@CreateCCRepo
Scenario:
"""
https://portal.commerce.ondemand.com -> Repository 
  -> Repository URL = github.com/$MY_GITHUB_USERNAME/concerttours-ccloud
  -> Username = $MY_GITHUB_USERNAME
  -> Token = $MY_GITHUB_TOKEN
  -> Save
"""
  * driver 'https://portal.commerce.ondemand.com'
  * delay(60000)
  * watchFor( '{}Repository')
  * delay(10000)
  * watchInput("//input[@data-placeholder='Repository URL']", "github.com/"+MY_GITHUB_USERNAME+"/concerttours-ccloud")
  * watchInput("//input[@data-placeholder='Username']", ""+MY_GITHUB_USERNAME )
  * watchInput("//input[@data-placeholder='Token']", ""+MY_GITHUB_TOKEN )
  * watchFor( '{button}Save')
  * delay(delays)

@TriggerABuild
Scenario:
"""
https://portal.commerce.ondemand.com -> Builds -> Create 
  -> Name = Build${NOW} 
  -> Git Branch or Tag = main
  -> Save
"""
  * driver 'https://portal.commerce.ondemand.com'
  * delay(10000)
  * watchFor( '{}Repository')
  * delay(10000)
  * watchFor( '{}Builds')
  * watchFor( '{button}Create')
  * watchInput("//input[@data-placeholder='Name']", 'Build'+NOW  )
  * watchInput("//input[@data-placeholder='Git Branch or Tag']", 'main' )
  * watchFor( '{button}Save')
  * delay(delays)
  
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
  * delay(60000)
  * watchFor( '{}Builds')
  * delay(20000)
  * watchFor("{mat-cell:0}" )
  * watchFor( '{}Deploy to Environment')
  * delay(10000)
  
  * locateAll("//div[starts-with(@class, 'mat-select-arrow ')]")[2].highlight().click() 
  * delay(1000)
  * watchFor('{}Recreate (fastest, with downtime)')
  
  * locateAll("//div[starts-with(@class, 'mat-select-arrow ')]")[1].highlight().click() 
  * delay(1000)
  * watchFor('{}Initialize database')

  * locateAll("//div[starts-with(@class, 'mat-select-arrow ')]")[0].highlight().click() 
  * delay(1000)
  * watchFor('{}dev')  
  * delay(1000)
    
  * watchFor( '{button}Deploy')
  * watchFor( '{button:2}Deploy')
  * delay(delays)



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
  * delay(20000)
  * watchFor( '{a}dev')
  * watchFor( '{}API')
  * watchForOptional( '{}Deny all')
  * watchForOptional( '{}Allow all')
  * watchFor( '{}Save')
  * watchFor( '{}Cancel')
  * watchFor( '{}Backoffice')
  * watchForOptional( '{}Deny all')
  * watchForOptional( '{}Allow all')
  * watchFor( '{}Save')
  * watchFor( '{}Cancel')
  * watchFor( '{}JS Storefront')
  * watchForOptional( '{}Deny all')
  * watchForOptional( '{}Allow all')
  * watchFor( '{}Save')
  * watchFor( '{}Cancel')
  * watchFor( '{}Storefront')
  * watchForOptional( '{}Deny all')
  * watchForOptional( '{}Allow all')
  * watchFor( '{}Save')
  * watchFor( '{}Cancel')
  * delay(2000)
  * locateAll("//fd-icon[starts-with(@class, 'icon-external-link ')]")[2].click() 
  * delay(10000)
  
  
@GetAdminPwdAndLoginToBackoffice
Scenario:
"""
https://portal.commerce.ondemand.com ->  Environments -> dev -> API -> view all -> hcs_admin -> Properties -> admin -> Copy to clipboard
https://portal.commerce.ondemand.com -> Environments -> Backoffice URL ->
  -> username = Admin
  -> Password = Password from clipboard
  -> Login
"""
  * driver 'https://portal.commerce.ondemand.com'
  * delay(20000)
  * watchFor( '{a}dev')
  * watchFor( '{}View all (7)')
  * delay(10000)
  * watchFor( '{}hcs_admin')
  * watchFor( '{}Properties')
  * delay(10000)
  * locateAll("//a[contains(@class, 'sap-icon--show')]")[0].click() 
  * delay(1000)
  * watchFor( '{}Copy to Clipboard')

  * driver 'https://portal.commerce.ondemand.com'
  * delay(20000)
  * watchFor( '{a}dev')
  * delay(20000)
  * locateAll("//fd-icon[starts-with(@class, 'icon-external-link ')]")[1].click() 
  * switchPage('SAP CX Backoffice | Login')
  * watchInput('input[name=j_username]', robot.clipboard)
  * watchInput('input[name=j_password]', robot.clipboard)
  * watchFor( '{}Login')
  * delay(delays)
