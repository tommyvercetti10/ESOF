Feature: Display post
  As a user
  I want to view post details
  So that I can engage with content within the app

  Scenario: Viewing a post with all details loaded
    Given the post data is available
    And the user data associated with the post is available
    When I open the PostView
    Then I should see the user's image, username, and post timestamp
    And I should see the post text

  Scenario: PostView shows loading indicator while fetching data
    Given the post data is being fetched
    When I open the PostView
    Then I should see a loading indicator
    And the post details should be displayed after loading is complete

