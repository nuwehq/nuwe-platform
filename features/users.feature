Feature: Users

  Users can log in or create a new account

  Scenario: When I'm a user, I am not a Developer
    Given that I am a User
    When I log in on the Developer platform
    Then I see "Would you like to sign up as a developer?"
    When I fill in my name and click agree
    Then I see "Create a new App"


  Scenario: When I'm not logged in, I am redirected from an app page
    Given that I am a User
    When I try to access an application page
    Then I am redirected to the login screen

  Scenario: When I'm not logged in, I am redirected from the index page
    Given that I am a User
    When I try to access the applications' index page
    Then I am redirected to the login screen

  Scenario: I can sign up for a new account
    Given that I am not a User
    When I sign up with new account details
    Then I have a Nuwe account
