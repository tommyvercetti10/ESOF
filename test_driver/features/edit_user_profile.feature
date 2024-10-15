Feature: Edit User Profile
  As a registered user
  I want to be able to update my profile photo and status
  So that I can keep my profile up to date

  Scenario: Successfully updating the profile photo
    Given I am on the Edit Profile page
    When I click on the "Edit Photo" button
    And I select a new photo
    Then the profile photo should be updated on my profile

  Scenario: Successfully updating the user status
    Given I am on the Edit Profile page
    When I enter "Excited to use BrainShare!" into the status field
    And I click the "Submit" button
    Then my status should be updated to "Excited to use BrainShare!"

