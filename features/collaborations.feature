Feature: Collaborators

  I can add collaborators to my app

  Background:
    Given I sign up as a Developer
    And I am signed in as a Developer
    And I have a Developer App
    And there is a service called Parse Core

  Scenario: add a new collaborator
    When I go to my app's details page
    And I enter another developer's email address
    And I click Add Collaborator
    Then I see a collaborator is added

  Scenario: add a collaborator only if user already exists
    When I go to my app's details page
    And I enter a nonexistent email address
    And I click Add Collaborator
    Then I see "User not found"

  Scenario: remove a collaborator
    Given I have a collaborator I want to remove
    When I go to my app's details page
    And I click Remove
    Then the collaborator is deleted from my list of collaborators

  Scenario: collaborator receives email notification after added to app
    When I add a collaborator
    Then the collaborator receives an email notification
