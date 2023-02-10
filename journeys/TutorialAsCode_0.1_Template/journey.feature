Feature: TutorialAsCode

Background:
  * def delays = 10000
  * def clickIt =  function(loc) {  retry(5, delays); highlight(loc).click ()   }
  * def watchFor =  function(loc) {    delay(delays);  waitFor(loc).highlight().click()  }
  * def btpMouseClick = function(loc) { delay(delays); highlight(loc); mouse(loc).click()   }

@confirmThatYouSeeYourName
Scenario:
"""
https://localhost:3000 -> ClickMe -> confirmThatYouSeeYourName :)
"""
  * karate.waitForHttp('http://localhost:3000')
  * driver 'http://localhost:3000'
  * watchFor('{^}ClickMe')
  * watchFor('{^}'+AN_EXAMPLE_ENVIRONMENT_VARIABLE)
  * delay(delays)