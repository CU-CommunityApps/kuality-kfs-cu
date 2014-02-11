Feature: General Ledger

  [KFSQA-649] Cornell University requires an Accounting Line Description input through an eDoc to be recorded in the General Ledger.

  @remove-me
  Scenario: Test test
    Given I am logged in as a KFS User
    And   I clone a random Account with the following changes:
      | Name        | Test Account |
      | Chart Code  | IT           |
      | Description | Test Account |
    When  I start an empty General Error Correction document
    And   I add a to Accounting Line for the General Error Correction document
    And   I enter a to Accounting Line Description on the General Error Correction document
    And   I remove to Accounting Line #1 from the General Error Correction document
    And   I add a to Accounting Line for the General Error Correction document
    And   I enter a to Accounting Line Description on the General Error Correction document
    Then  the document status is ENROUTE

  @KFSQA-649 @smoke @wip
  Scenario Outline: Accounting Line Description from eDoc updates General Ledger
    Given I am logged in as a KFS User the <docType> document
    And   I clone a random Account with the following changes:
      | Name        | <eDoc> Test Account |
      | Chart Code  | IT                  |
      | Description | <eDoc> Test Account |
    When  I start an empty <eDoc> document
    And   I add balanced Accounting Lines to the <eDoc> document
    And   I enter a to Accounting Line Description on the <eDoc> document
    And   I submit the <eDoc> document
    And   I blanket approve the <eDoc> document
    And   the <eDoc> document goes to PROCESSED
    Given I am logged in as a KFS Chart Administrator
    And   Nightly Batch Jobs run
    When  I lookup the document ID for the <eDoc> document from the General Ledger
    Then  the Accounting Line Description for the <eDoc> document equals the General Ledger Accounting Line Description
  Examples:
    | eDoc                               | docType |
#    | Advance Deposit                    | AD      |
#    | Auxiliary Voucher                  | AV      |
#    | Budget Adjustment                  | BA      |
#    | Credit Card Receipt                | CCR     |
#    | Disbursement Voucher               | DV      |
#    | Distribution Of Income And Expense | DI      |
    | General Error Correction           | GEC     |
#    | Internal Billing                   | IB      |
#    | Indirect Cost Adjustment           | ICA     |
#    | Journal Voucher                    | JV-1    |
#    | Journal Voucher                    | JV-2    |
#    | Journal Voucher                    | JV-3    |
#    | Non-Check Disbursement             | ND      |
#    | Pre-Encumbrance                    | PE      |
#    | Service Billing                    | SB      |
#    | Transfer Of Funds                  | TF      |
