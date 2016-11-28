Feature: Medical Devices

  As a developer, I would like to connect a device to my developer app.

  Background:
    Given I sign up as a Developer
    And I am signed in as a Developer
    And I have a Developer App
    And there is a service called Parse Core

  Scenario: add a new device
    When I go to my app's details page
    And I click on "Add a New Device"
    And I enter a name for my device
    And I click on Add Device
    Then I see a new device added to my list of devices

  Scenario: delete existing device
    When I have already added a device
    And I go to my app's details page
  	And I click the Delete Device button
  	Then the device is deleted from my list of devices

  Scenario: delete with device file
    When I have already added a device
    And the device has received uploads
    And I go to my app's details page
    And I click the Delete Device button
    Then the device is deleted from my list of devices

  Scenario: edit existing device
    When I have already added a device
    And I go to my app's details page
    And I click Edit Device button
    And I change the name of my device
    And I click on Update Device
    Then the device name is changed
