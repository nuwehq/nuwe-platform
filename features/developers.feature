Feature: Developers

  Developers can sign in to NuAPI and register apps.

  Scenario: registration
    When I sign up as a developer

  Scenario: developers have a 'developer' role
    When I sign up as a developer
    Then I'm added to the "developer" role
