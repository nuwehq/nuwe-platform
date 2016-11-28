Feature: Alerts

  I can send alerts to users of my app

  Background:
    Given I sign up as a Developer
    And I am signed in as a Developer
    And I have a Developer App
    And That App hase Parse server enabled
    And users authorize my app
    And there is a service called Parse Core

  Scenario: create a notification to send to all users
    When I go to my app's details page
    And I click on the Create a Notification button
    And I create an alert
    And I click on the Send Notification button

  Scenario: index all my notifications
    When I create an email notification for a user
    And I am on the notification page
    Then I can see a list of my notifications

  @push_notifications
  Scenario: send a push notification to all users
    When a user has push notifications active

  @push_notifications
  Scenario: send a push notification to a user
    When a user has push notifications active

  Scenario: send a email notification to all users
    When I create an email notification for all users
    Then all users receive a email notification

  Scenario: send a email notification to a user
    When I create an email notification for a user
    Then a user receives a email notification

  Scenario: update an email notification to a user
    When I create an email notification for a user
    And I edit the notifaction on the alert page
    Then the notifation is edited

  Scenario: if user has not authorized my app, they do not receive an email
    When I create an email notification for a nonexistent user
    Then no email notification is created

  Scenario: if a user has multiple Access Grants, they do not receive multiple emails
    When I create an email notification for a user
    And a user has authorized my application multiple times
    Then a user does not receive more than one email notification

  Scenario: if users have multiple Access Grants, they do not receive multiple emails
    When I create an email notification for all users
    And a user has authorized my application multiple times
    Then users do not receive more than one email notification

  Scenario: I can upload my pem certificate for iOS notifications
    When I go to my app's details page
    Then I can upload my pem certificate
