Feature: Internal Billing

  [KFSQA-667] IB e2e Test Business Process (Basic)

  @KFSQA-667 @wip
  Scenario: Ensure IB e2e Test Business Process (Basic) works
    Given   I am logged in as a KFS User for the Internal Billing document
    And     I start an empty Internal Billing document
    And     I add a source Accounting Line to the Internal Billing document with a bad object code
    And     I should get an error that starts with "The Object Sub-Type Code"
    And     I add a source Accounting Line to the Internal Billing document with the following:
      | Chart Code   | IT |
      | Number       | G003704 |
      | Object Code  | 4020  |
      | Amount       | 300 |
#    And     I enter Two Expense Lines
    And     I add a target Accounting Line to the Internal Billing document with the following:
      | Chart Code   | IT |
      | Number       | G013300 |
      | Object Code  | 4020  |
      | Amount       | 100 |
    And     I add a target Accounting Line to the Internal Billing document with the following:
      | Chart Code   | IT |
      | Number       | G013300 |
      | Object Code  | 4020  |
      | Amount       | 100 |
    And     I submit the Internal Billing document
    And     I should get an error saying "The document is out of balance."
    And     I add a target Accounting Line to the Internal Billing document with the following:
      | Chart Code   | IT |
      | Number       | G013300 |
      | Object Code  | 4020  |
      | Amount       | 100 |
    And     I submit the Internal Billing document
    And     the Internal Billing document goes to ENROUTE
    And     I am logged in as a KFS Fiscal Officer
    And     I view the Internal Billing document
    And     I blanket approve the Internal Billing document
    And     the Internal Billing document goes to FINAL
    And     I am logged in as a KFS Technical Administrator
    And     Nightly Batch Jobs run
    And     I am logged in as a KFS Chart Manager
    When    I lookup the document ID for the Internal Billing document from the General Ledger
    Then    the Accounting Line Description for the Internal Billing document equals the General Ledger Accounting Line Description
#    When    I lookup the Document ID from the General Ledger
#    Then    The Accounting Lines entered equals the General Ledger Accounting Line