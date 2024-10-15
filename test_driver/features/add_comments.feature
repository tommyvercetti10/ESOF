Feature: Adding comments in the AddCommentsView widget

  Scenario: Successfully adding a comment
    Given the user is authenticated and on the "Add Comment" page
    And the user has a profile picture URL "http://example.com/profile.jpg"
    When the user enters "This product is amazing!" into the comment field
    And the user sets the comment rating to 4.5 stars
    And the user taps the send button
    Then the comment should be submitted to the receiver's comment list
    And the application should display a loading indicator while processing
    And the user should be redirected back to the previous page after submission

  Scenario: Attempting to send an empty comment
    Given the user is authenticated and on the "Add Comment" page
    When the user taps the send button without entering any text
    Then the send button should not be active
    And no action should be taken
