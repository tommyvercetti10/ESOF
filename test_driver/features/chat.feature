Feature: Chat
  As a user
  I want to chat with my tutor
  so that I can get my doubts explained

  Scenario: Successfully sending a message
    Given the user is in a chat room
    When the user attempts to send a message
    Then the message widget with the text sent by the user should be displayed
  Scenario: Unsuccessfully sending a message
    Given the user is in a chat room
    When the user attempts to send an empty message
    Then an error message "Message cannot be empty." should be displayed

