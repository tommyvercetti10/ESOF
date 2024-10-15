Feature: Password Recovery
  As a user
  I want to be able to recover my password
  So that I can regain access to my account if I forget my password

  Scenario: Sending a password reset email with a valid email address
    Given I am on the Recover Password page
    When I enter a valid email "user@example.com" in the email field
    And I press the "Send Email" button
    Then a password reset email should be sent to "user@example.com"
    And I should be redirected back to the previous page

  Scenario: Attempt to send a password reset email with an invalid email address
    Given I am on the Recover Password page
    When I enter an invalid email "user" in the email field
    And I press the "Send Email" button
    Then an error message should be displayed indicating "Something went wrong"


