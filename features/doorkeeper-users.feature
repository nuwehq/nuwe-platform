Feature: Developer-users

  Users who use my app can authorize me to access their data

  Background:
    Given I sign up as a Developer
    And I am signed in as a Developer
    And I have a Developer App
    And there is a service called Parse Core

  Scenario: users authorize my app
    When a user authorizes my app
    Then I can access their data
    And I can see the user count


  Scenario: test authorizing the app
    When I authorize my app
    Then it asks for authorization


  Scenario: After logging in, I can see my profile page
    When I go to my profile page
    Then it shows me my profile
