Feature: Services

  I can add services to my app

  Background:
    Given I sign up as a Developer
    And I am signed in as a Developer
    And I have a Developer App
    And these subscription plans:
      | Name    | Price   |
      | DEV     | 0,00    |
      | Scale   | 499,00  |
    And these services:
      | Category  | Name          | LibName     | Needs remote credentials  | Description |
      | Tools     | Pusher        | pusher      | false                     | Realtime push notifications for your app |
      | Data      | Factual UPC   | factual_upc | true                      | Over 600,000 consumer packaged goods in a UPC centric database |
      | Data      | Parse Core    | parse_core  | false                     | Backend as a Service |
    And I am on the Scale plan

  Scenario: add new service
    When I go to my app's details page
    And I enable Pusher
    Then Pusher is activated for my app

  Scenario: I need the correct subscription
    When I have the DEV plan

  Scenario: add credentials for Factual UPC service
    When I go to my app's details page
    And I enable Factual UPC
    And I enter my factual credentials
    Then Factual UPC is activated for my app

  Scenario: I can add Parse as a service
    When I go to my app's details page
    And I enable Nuwe Parse
    Then Parse is activated for my app
