Feature: Subscription

  I can purchase a subscription for my app

  Background:
    Given I sign up as a Developer
    And I am signed in as a Developer
    And I have a Developer App
    And these subscription plans:
      | Name    | Price   |
      | DEV     | 0.00    |
      | Scale   | 449.00  |

  Scenario: purchase a subscription
    When I choose a subscription

  Scenario: see current subscription
    When I visit Developer Apps page
    And I am on the Scale plan
    Then I see that my subscription is selected
