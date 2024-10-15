Feature: User Profile
  As a registered user
  I want to view and interact with my profile
  So that I can manage my personal information and view my activities

  Scenario: Displaying the user profile
    Given I am a logged-in user
    When I navigate to the Profile View
    Then I should see my profile image
    And I should see my username
    And I should see my status
    And options to edit my profile

  Scenario: Editing the user profile
    Given I am on the Profile View
    When I click the "Edit Profile" button
    And I change my profile details
    And I submit the changes
    Then the changes should be reflected in the Profile View

  Scenario: Toggling to view posts
    Given I am on the Profile View
    When I click the "Posts" button
    Then I should see a list of my posts
    And not see comments

  Scenario: Toggling to view comments
    Given I am on the Profile View
    When I click the "Comments" button
    Then I should see a list of comments
    And not see posts