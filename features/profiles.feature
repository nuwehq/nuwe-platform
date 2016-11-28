Feature: Profiles

  Users can create and edit a Profile

  Background:
    Given that I am a User

  Scenario: edit Profile details
    When I log in on the Developer platform
    And I visit Profile page
    And I change my title
    And I click Update
    Then I see "updated"