Feature: Measurements Data

  As a developer, I can view measurements data for users

  Background:
    Given I sign up as a Developer
    And I am signed in as a Developer
    And I have a Developer App
    And a user authorizes my app
    And there is a service called Parse Core

  Scenario: view a user's height measurement data
    When a user has added height measurements
    When I go to my app's details page
    And I click on "Measurements"
    And I click on "Height"
    Then I see the user's height data

  Scenario: view a user's step measurement data
    When a user has added step measurements
    When I go to my app's details page
    And I click on "Measurements"
    And I click on "Step"
    Then I see the user's step data

  Scenario: view a user's BPM measurement data
    When a user has added BPM measurements
    When I go to my app's details page
    And I click on "Measurements"
    And I click on "BPM"
    Then I see the user's BPM data

  Scenario: view a user's weight measurement data
    When a user has added weight measurements
    When I go to my app's details page
    And I click on "Measurements"
    And I click on "Weight"
    Then I see the user's weight data

  Scenario: view a user's blood pressure measurement data
    When a user has added blood pressure measurements
    When I go to my app's details page
    And I click on "Measurements"
    And I click on "Blood Pressure"
    Then I see the user's blood pressure data

  Scenario: view a user's blood oxygen measurement data
    When a user has added blood oxygen measurements
    When I go to my app's details page
    And I click on "Measurements"
    And I click on "Blood Oxygen"
    Then I see the user's blood oxygen data

  Scenario: view a user's body fat measurement data
    When a user has added body fat measurements
    When I go to my app's details page
    And I click on "Measurements"
    And I click on "Body Fat"
    Then I see the user's body fat data

  Scenario: view a user's BMR measurement data
    When a user has BMR measurements
    When I go to my app's details page
    And I click on "Measurements"
    And I click on "BMR"
    Then I see the user's BMR data

  Scenario: view a user's BMI measurement data
    When a user has BMI measurements
    When I go to my app's details page
    And I click on "Measurements"
    And I click on "BMI"
    Then I see the user's BMI data
