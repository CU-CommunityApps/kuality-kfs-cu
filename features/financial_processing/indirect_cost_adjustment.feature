Feature: Indirect Cost Adjustment

  [KFSQA-655] The ICA document is not populating the Indirect Cost Recovery chart specified on the account.
  [KFSQA-750] ICA Accounting Line Description from Import Template updates General Ledger

  @KFSQA-655 @CG @nightly-jobs @tortoise @needs-clean-up
  Scenario: Populate an ICA document with the Indirect Cost Recovery chart specified on the account.
    Given   I am logged in as a KFS User
    And     I start an empty Indirect Cost Adjustment document
    And     I enter a Grant Accounting Line and a Receipt Accounting Line
#    And     The Receipt Chart equals the Receipt Grant’s Chart
    And     I submit the Indirect Cost Adjustment document
    And     I route the Indirect Cost Adjustment document to final
    Given   Nightly Batch Jobs run
    And     I am logged in as a KFS Chart Manager
    When    I lookup the document ID for the Indirect Cost Adjustment document from the General Ledger
    Then    the Accounting Line Description for the Indirect Cost Adjustment document equals the General Ledger Accounting Line Description

  @KFSQA-750 @ICA @Import-Templates @nightly-jobs
  Scenario: Cornell University requires an Accounting Line Description uploaded through an Import Template to be recorded in the General Ledger.
    Given I am logged in as a KFS User for the ICA document
    When  I start an empty Indirect Cost Adjustment document
    And   I upload a Grant line template for the Indirect Cost Adjustment document
    And   I upload a Receipt line template for the Indirect Cost Adjustment document
    And   I submit the Indirect Cost Adjustment document
    And   I route the Indirect Cost Adjustment document to final
    Given Nightly Batch Jobs run
    And   I am logged in as a KFS Technical Administrator
    When  I lookup the document ID for the Indirect Cost Adjustment document from the General Ledger
    Then  the Grant Template Accounting Line Description for Indirect Cost Adjustment equals the General Ledger entry
    And   the Receipt Template Accounting Line Description for Indirect Cost Adjustment equals the General Ledger entry