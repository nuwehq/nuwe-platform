Feature: HumanAPI

  I can connect with HumanAPI through their javascript "Connect" feature.

  Background:
    Given I have previously signed up using the app

  Scenario: Connect
    When I visit the HumanAPI Connect page
    And I click the Connect button
    Then I can choose a provider in the HumanAPI popup

  Scenario: Callback
    When I visit the HumanAPI Connect page
    And I authorize a provider through HumanAPI
    Then I am connected with HumanAPI
