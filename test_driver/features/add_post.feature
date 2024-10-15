Feature: Adding New Posts
  As a user
  I want to add new posts to my profile
  So that I can share updates with my followers

  Scenario: Successfully adding a new post
    Given I am logged in as a user with a username
    When I navigate to the Add Post view
    And I enter text into the post input field
    And I click the "Post" button
    Then the post should be added to my profile
    And I should see a confirmation message

  Scenario: Display of loading indicator while posting
    Given I am logged in as a user with a username
    And I am on the Add Post view
    When I enter text into the post input field
    And I click the "Post" button
    Then a loading indicator should be displayed while the post is being processed
    And the loading indicator should disappear once the post is added
