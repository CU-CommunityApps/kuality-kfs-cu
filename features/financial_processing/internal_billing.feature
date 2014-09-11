Feature: Internal Billing

  [KFSQA-667] IB e2e Test Business Process (Basic)

  @KFSQA-667 @E2E @FP @IB @nightly-jobs @tortoise @needs-clean-up
  Scenario: Ensure IB e2e Test Business Process (Basic) works
    Given   I am logged in as a KFS User for the Internal Billing document
    And     I start an empty Internal Billing document
    And     I add a source Accounting Line to the Internal Billing document with a bad object code
    And     I should get an error that starts with "The Object Sub-Type Code"
    And     I add a Source Accounting Line to the Internal Billing document with Amount 200
#    And     I enter Two Expense Lines
    And     I add a Target Accounting Line to the Internal Billing document with Amount 50
    And     I submit the Internal Billing document
    And     I should get an error saying "The document is out of balance."
    And     I add a Target Accounting Line to the Internal Billing document with Amount 150
    And     I submit the Internal Billing document
    And     the Internal Billing document goes to ENROUTE
    And     I am logged in as a KFS Fiscal Officer
    And     I view the Internal Billing document
    And     I blanket approve the Internal Billing document
    And     the Internal Billing document goes to FINAL
    And     I am logged in as a KFS Technical Administrator
    And     Nightly Batch Jobs run
    When    I am logged in as a KFS Chart Manager
    Then    the Internal Billing document accounting lines equal the General Ledger entries
