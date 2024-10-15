Feature: User Sign-Up

  Scenario: Successfully signing up with new credentials
    Given the "Sign Up" page is displayed
    When the user enters "newuser" into the username field
    And the user enters "newuser@example.com" into the email field
    And the user enters "securepassword" into the password field
    And the user agrees to the terms and conditions
    And the user clicks on the "Sign Up" button
    Then the user should be registered successfully
    And the user should be redirected to the home page
    
  Scenario: Navigating to terms and conditions
    Given the "Sign Up" page is displayed
    When the user clicks on the "terms and conditions" link
    Then the "Terms and Conditions" page should be displayed

  Scenario: Redirecting to the Sign-In page from the Sign-Up page
    Given the "Sign Up" page is displayed
    When the user clicks on the "Login" link
    Then the "Sign In" page should be displayed

  Scenario: Failing to sign up without agreeing to terms and conditions
    Given the "Sign Up" page is displayed
    When the user enters "newuser" into the username field
    And the user enters "newuser@example.com" into the email field
    And the user enters "securepassword" into the password field
    And the user does not agree to the terms and conditions
    And the user clicks on the "Sign Up" button
    Then an error dialog should be displayed with the message "You must agree with the terms and conditions to continue!"
