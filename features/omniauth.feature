Feature: Omniauth

  Developers can log into the Nuwe developers platform using their Github account

  Scenario: Github signup
    Given that I have never logged in before
    #Then I can log into the platform

  Scenario: Github signup
    Given that I have logged in before
    #Then I can log into the platform


  Scenario: When I log in, but I am not a Developer
    #Given I am not a developer
    #And I log into the platform
    #Then I see "Would you like to sign up as a developer?"
    #When I fill in my name and click agree
    #Then I see "Create a new App"

  Scenario: When I log in, and I am a Developer
    #Given I am a developer
    #And I log into the platform
    #Then I see "Create a new App"