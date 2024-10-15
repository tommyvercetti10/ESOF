Feature: Display comments

  Scenario: User views a comment in the CommentView
    Given the application is connected to the network
    And there is a comment by the author with ID "user123"
    And the user with ID "user123" has a username "JaneDoe" and photo URL "http://example.com/photo.jpg"
    And the comment was posted 5 minutes ago
    And the comment text is "Great service, thanks!"
    And the comment rating is 4.5

    When the CommentView is loaded for the comment

    Then a loading spinner should be displayed
    And the loading spinner should disappear after the user is loaded
    And a profile picture with URL "http://example.com/photo.jpg" should be displayed
    And the username "JaneDoe" should be displayed
    And the text "5 minutes ago" should be displayed in italics
    And the comment text "Great service, thanks!" should be visible
    And the rating "4.5/5 ☆" should be displayed in bold