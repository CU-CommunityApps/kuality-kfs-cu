Feature: Notes And Attachments Tab

  [KFSQA-644] Cornell University sequential easy-to-follow tab flow between
              fields in the Notes and Attachment Tab of all FP Docs.

  @KFSQA-644 @wip
  Scenario Outline: Sequential tab flow of Notes and Attachment Tab
    Given I am logged in as a KFS User for the <docType> document
    When  I start an empty <eDoc> document
    And   I open the Notes and Attachments Tab
    And   I enter text into the Note Text field
    And   I press Tab
    Then  my cursor is on the Browse button
    When  I attach a file to the Notes and Attachments Tab line
    Then  my cursor is on the Cancel button
    When  I press Tab
    Then  my cursor is on the Add button
    When  I click the Add button
    And   I select Save
    When  I enter a a Valid Notification Recipient < Valid Notification Recipient> and press tab
    And   I arrive at delete and I press tab
    When  I arrive at Send and press Send
    Then  I will see a display of” Note notification was successfully sent.”
  Examples:
      | eDoc                               | docType |
      | Advance Deposit                    | AD      |
      | Auxiliary Voucher                  | AV      |
      | Credit Card Receipt                | CCR     |
      | Distribution Of Income And Expense | DI      |
      | General Error Correction           | GEC     |
      | Internal Billing                   | IB      |
      | Journal Voucher                    | JV-1    |
      | Journal Voucher                    | JV-2    |
      | Journal Voucher                    | JV-3    |
      | Non-Check Disbursement             | ND      |
      | Pre-Encumbrance                    | PE      |
      | Transfer Of Funds                  | TF      |
      | Budget Adjustment                  | BA      |
      | Service Billing                    | SB      |
      | Disbursement Voucher               | DV      |
      | Indirect Cost Adjustment           | ICA     |