Feature: Notes And Attachments Tab

  [KFSQA-644] Cornell University sequential easy-to-follow tab flow between
              fields in the Notes and Attachment Tab of all FP Docs.

  @KFSQA-644 @wip
  Scenario Outline: Sequential tab flow of Notes and Attachment Tab
    Given I am logged in as a KFS User for the <docType> document
    When  I start an empty <eDoc> document
    And   I enter text into the Note Text field of the <eDoc> document
    And   I press the Tab key
    Then  my cursor is on the Attach File field
    When  I attach a file to the Notes and Attachments Tab line of the <eDoc> document
    Then  my cursor is on the Cancel Attachment button
    When  I press the Tab key
    Then  my cursor is on the Add a Note button
    When  I click the Add a Note button
    And   I save the <eDoc> document
    And   I enter a a Valid Notification Recipient for the <eDoc> document
    And   I press the Tab key
    Then  my cursor is on the Delete a Note button
    When  I press the Tab key
    Then  my cursor is on the Send FYI button
    When  I click the Send FYI button
    And   I stop here
    Then  I will see a display of "Note notification was successfully sent."
  Examples:
      | eDoc                               | docType |
      | Advance Deposit                    | AD      |
#      | Auxiliary Voucher                  | AV      |
#      | Credit Card Receipt                | CCR     |
#      | Distribution Of Income And Expense | DI      |
#      | General Error Correction           | GEC     |
#      | Internal Billing                   | IB      |
#      | Journal Voucher                    | JV-1    |
#      | Journal Voucher                    | JV-2    |
#      | Journal Voucher                    | JV-3    |
#      | Non-Check Disbursement             | ND      |
#      | Pre-Encumbrance                    | PE      |
#      | Transfer Of Funds                  | TF      |
#      | Budget Adjustment                  | BA      |
#      | Service Billing                    | SB      |
#      | Disbursement Voucher               | DV      |
#      | Indirect Cost Adjustment           | ICA     |