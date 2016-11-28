Feature: Admin

  I can edit services

  Background:
    Given I am signed in as an Admin
    And I have a Developer App
    And there is a service called Parse Core

  Scenario: edit a service
    Given these services:
      | Category  | Name        | LibName     | Needs remote credentials  | Description |
      | Tools     | Pusher      | pusher      | false                     | Realtime push notifications for your app |
      | Data      | Factual UPC | factual_upc | true                      | Over 600,000 consumer packaged goods in a UPC centric database |
    When I go to my app's details page
    And I click on 'Edit' for Factual UPC
    And I change the description of the service
    And I click 'Save'
    Then I see "updated"

  Scenario: add a new service
    When I go to my app's details page
    And I click on 'Add a New Service'
    And I enter the name of the service
    And I click 'Save'
    Then I see "This service has been added."
