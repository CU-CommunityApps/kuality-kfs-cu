Feature: Notes And Attachments Tab

  [KFSQA-644] Cornell University sequential easy-to-follow tab flow between
              fields in the Notes and Attachment Tab of all FP Docs.

  @KFSQA-644 @AD @pending
  Scenario: Sequential tab flow of Notes and Attachment Tab
    Given I am logged in as a KFS User for the BA document
    When  I start an empty Budget Adjustment document
    And   I collapse all tabs
    And   I expand the Notes and Attachments tab
    And   I note how many attachments the Budget Adjustment document has already
    And   I enter text into the Note Text field of the Budget Adjustment document
    And   I press the tab key
    # If we try to tab out of a file field with Watir, we lose the setting for some reason.
    # This test will be set to pending until this bug has been solved.
    Then  my cursor is on the Attach File field
    When  I add a file attachment to the Notes and Attachment Tab of the Budget Adjustment document
    When  I press the tab key
    Then  my cursor is on the Cancel Attachment button
    When  I press the tab key
    Then  my cursor is on the Add a Note button
    When  I add the Notes and Attachment line to the Budget Adjustment document
    Then  the Budget Adjustment document's Notes and Attachments Tab displays the added attachment
    When  I enter a Valid Notification Recipient for the Budget Adjustment document
    And   I press the tab key
    Then  my cursor is on the Send FYI button