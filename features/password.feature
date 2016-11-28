Feature: Password reset

  When I forget my password, I can reset my password.

  Background:
    Given I have previously signed up using the app

  Scenario: request to reset password
    When I click 'Forgot password?'
    And I can enter my email address
    Then I receive an email

  Scenario: resetting my password
    When I click on the link in the email
    Then I can change my password
    And I see "Your password has been changed"
