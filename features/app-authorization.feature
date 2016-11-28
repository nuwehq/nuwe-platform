Feature: App Authorization

  I can connect third-party apps such as Moves. These usually utilize OAuth2 for the authentication.

  Background:
    Given I have previously signed up using the app

  Scenario Outline: OAuth2 providers
    When I authorize myself with <provider>
    Then <provider> is added to my list of active apps

    Examples:
      | provider        |
      | Moves           |
      | Fitbit          |
      | Withings        |
