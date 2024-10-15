Feature: User Sign-In

  Scenario: Successfully signing in with correct credentials
    Given the "Login" page is displayed
    When the user enters "user@example.com" into the email field
    And the user enters "correctpassword" into the password field
    And the user clicks on the "Login" button
    Then the user should be redirected to the home page

  Scenario: Failing to sign in with incorrect credentials
    Given the "Login" page is displayed
    When the user enters "user@example.com" into the email field
    And the user enters "wrongpassword" into the password field
    And the user clicks on the "Login" button
    Then an error dialog should be displayed with the message "The password is incorrect"

  Scenario: Navigating to forgot password
    Given the "Login" page is displayed
    When the user clicks on the "Forgot password ?" link
    Then the "Recover Password" page should be displayed

  Scenario: Navigating to sign up page
    Given the "Login" page is displayed
    When the user clicks on the "Create an account" link
    Then the "Sign Up" page should be displayed
