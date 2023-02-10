Feature: TutorialAsCode

Background:
  * def delays = 5000
  * def watchFor =  function(loc) {    delay(delays);  waitFor(loc).highlight().click()  }

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