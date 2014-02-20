Feature: Indirect Cost Adjustment

  [KFSQA-655] The ICA document is not populating the Indirect Cost Recovery chart specified on the account.

  @KFSQA-655 @wip
  Scenario: Populate an ICA document with the Indirect Cost Recovery chart specified on the account.
    Given   I am logged in as a KFS User
    And     I start an empty Indirect Cost Adjustment document
    And     I enter a Grant Accounting Line and a Receipt Accounting Line
#    And     The Receipt Chart equals the Receipt Grant’s Chart
    And     I submit the Indirect Cost Adjustment document
    And     the Indirect Cost Adjustment document goes to ENROUTE
    And     I am logged in as a KFS Chart Manager
    And     I view the Indirect Cost Adjustment document
    And     I blanket approve the Indirect Cost Adjustment document
    And     I am logged in as a KFS Technical Administrator
    And     the Indirect Cost Adjustment document goes to PROCESSED
    And     Nightly Batch Jobs run
    When    I lookup the document ID for the Indirect Cost Adjustment document from the General Ledger
    Then    the Accounting Line Description for the Indirect Cost Adjustment document equals the General Ledger Accounting Line Description
