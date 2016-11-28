Feature: Collaborator permissions

  As a colloborator I have access to apps

  Background:
    Given I am logged in collaborator
    And I have been added to an app
    And there is a service called Parse Core

  Scenario: a collaborator sees the app in their index
    When I visit my applications page
    Then I see the app
    When I visit the app's show page
    Then I cannot delete the application
