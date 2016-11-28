Feature: Developer_apps

  I can create and edit my apps

  Background:
    Given I sign up as a Developer
    And I am signed in as a Developer
    And I have a Developer App
    And there is a service called Parse Core

  Scenario: create new app
    When I visit Developer Apps page
    And I click Create button
    And I enter a name for my App
    Then I see a new app added to my list of apps
    And the App received an Application ID and a Secret

  Scenario: edit existing app
    When I visit Developer Apps page
    Then I click Edit button
    Then I change the name of my App

  Scenario: show existing app details
  	When I visit Developer Apps page
  	And I click on an Details button
  	Then I see the App details page

  Scenario: delete existing app
  	When I visit Developer Apps page
  	And I click on an Details button
  	And I see the App details page
  	And I click the Delete button
  	Then the app is Deleted from my list of apps

  Scenario: app requests
    When I visit Developer Apps page
    And there have been twenty requests this month
    And ten requests last month
    Then I expect to see twenty requests

  Scenario: app over user limit
    When I visit Developer Apps page
    And there have been more users than allowed in my subscription
    Then I expect to see a warning message

  Scenario: app over request limit
    When I visit Developer Apps page
    And there have been more requests than allowed in my subscription
    Then I expect to see a warning message

  Scenario: show only apps that belong to me
    When I visit another Developer Apps page
    And the app does not belong to me
    Then I expect to not see the Developer Apps page
