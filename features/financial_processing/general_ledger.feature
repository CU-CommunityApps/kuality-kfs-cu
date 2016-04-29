Feature: General Ledger

  [KFSQA-649] Cornell University requires an Accounting Line Description input through an eDoc to be recorded in the General Ledger.
  [KFSQA-647] Cornell needs a to ensure that all eight Main Menu->Balance Inquiries-->General Ledger are working.

  @KFSQA-649 @smoke @nightly-jobs @coral @solid
  Scenario Outline: Accounting Line Description from eDoc updates General Ledger, part 1
    Given I am logged in as a KFS Chart Administrator
    And   I clone Account <source_account> with the following changes:
      | Name        | <eDoc> Test Account S |
      | Chart Code  | IT                    |
      | Description | <eDoc> Test Account S |
    And   I clone Account <target_account> with the following changes:
      | Name                              | <eDoc> Test Account T |
      | Chart Code                        | IT                    |
      | Description                       | <eDoc> Test Account T |
    And   I am logged in as a KFS User for the <docType> document
    When  I start an empty <eDoc> document
    And   I add balanced Accounting Lines to the <eDoc> document
    And   I save the <eDoc> document
    And   I submit the <eDoc> document
    Then  the document should have no errors
    And   I route the <eDoc> document to final
    #Remaining validation will be performed after the nightly batch jobs are executed for this feature file
    Then  references to test KFSQA-649 instance data for <docType> are saved for validation after batch job execution
  Examples:
    | eDoc                               | docType | source_account | target_account |
    | Advance Deposit                    | AD      | 2003600        |                |
    | Auxiliary Voucher                  | AV      | H853800        |                |
    | Credit Card Receipt                | CCR     | G003704        |                |
    | Distribution Of Income And Expense | DI      | G003704        | G013300        |
    | General Error Correction           | GEC     | G003704        | G013300        |
    | Internal Billing                   | IB      | G003704        | G013300        |
    | Transfer Of Funds                  | TF      | A763306        | A763900        |
  #TODO grab accounts from parameter
#TODO Determine why these five tests are failing and add back into test suite for solid tests.
#    | Journal Voucher                    | JV-1    | G003704        | G013300        |
#    | Journal Voucher                    | JV-2    | G003704        |                |
#    | Journal Voucher                    | JV-3    | G003704        |                |
#    | Non-Check Disbursement             | ND      | G013300        |                |
#    | Pre-Encumbrance                    | PE      | G003704        |                |



  @KFSQA-649 @smoke @nightly-jobs @tortoise
  Scenario Outline: Accounting Line Description from eDoc updates General Ledger, part 4. These eDocs' accounts don't clone nicely.
    Given I am logged in as a KFS Chart Administrator
    And   I use these Accounts:
      | <source_account> |
      | <target_account> |
    And   I am logged in as a KFS User for the <docType> document
    When  I start an empty <eDoc> document
    And   I add balanced Accounting Lines to the <eDoc> document
    And   I save the <eDoc> document
    And   I submit the <eDoc> document
    And   I route the Indirect Cost Adjustment document to final
    Given Nightly Batch Jobs run
    And   I am logged in as a KFS Chart Administrator
    When  I lookup the document ID for the <eDoc> document from the General Ledger
    Then  the Accounting Line Description for the <eDoc> document equals the General Ledger Accounting Line Description
    Examples:
      | eDoc              | docType | source_account | target_account |
      | Budget Adjustment | BA      | G003704        | G003704        |
      | Service Billing   | SB      | U243700        | G013300        |
  #TODO grab account from parameter

  @KFSQA-649 @smoke @nightly-jobs @tortoise @broken
  Scenario: Accounting Line Description from eDoc updates General Ledger, part 2
    Given I am logged in as a KFS System Manager
    And   I clone Account 1490000 with the following changes:
      | Name        | Disbursement Voucher Test Account S |
      | Chart Code  | IT                                  |
      | Description | Disbursement Voucher Test Account S |
    #TODO KYLE try using the default account for DV
    And   I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document with Payment to Vendor 12076-0 and Reason Code B
    #TODO loookup/calculate this
    And   I add balanced Accounting Lines to the Disbursement Voucher document
    And   I save the Disbursement Voucher document
    And   I submit the Disbursement Voucher document
    And   I route the Disbursement Voucher document to final
    And   Nightly Batch Jobs run
    And   I am logged in as a KFS Chart Administrator
    When  I lookup the document ID for the Disbursement Voucher document from the General Ledger
    Then  the Accounting Line Description for the Disbursement Voucher document equals the General Ledger Accounting Line Description

  @KFSQA-649 @smoke @nightly-jobs @tortoise
  Scenario: Accounting Line Description from eDoc updates General Ledger, part 3
    Given I am logged in as a KFS System Manager
    And   I clone a random Account with the following changes:
      | Name                                          | Indirect Cost Adjustment Test Account S |
      | Chart Code                                    | IT                                      |
      | Description                                   | Indirect Cost Adjustment Test Account S |
      | Indirect Cost Recovery Chart Of Accounts Code | IT - Ithaca Campus                      |
      | Indirect Cost Recovery Account Number         | A463200                                 |
      | Indirect Cost Recovery Account Line Percent   | 100                                     |
      | Indirect Cost Recovery Active Indicator       | set                                     |
    And   I clone a random Account with the following changes:
      | Name                              | Indirect Cost Adjustment Test Account T |
      | Chart Code                        | IT                                      |
      | Description                       | Indirect Cost Adjustment Test Account T |
    And   I am logged in as a KFS User for the ICA document
    When  I start an empty Indirect Cost Adjustment document
    And   I add balanced Accounting Lines to the Indirect Cost Adjustment document
    And   I save the Indirect Cost Adjustment document
    And   I submit the Indirect Cost Adjustment document
    And   I route the Indirect Cost Adjustment document to final
    And   the Indirect Cost Adjustment document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |
    Given Nightly Batch Jobs run
    And   I am logged in as a KFS Chart Administrator
    When  I lookup the document ID for the Indirect Cost Adjustment document from the General Ledger
    Then  the Accounting Line Description for the Indirect Cost Adjustment document equals the General Ledger Accounting Line Description

  @nightly-jobs @solid
  Scenario: Run Nightly batch jobs required for General Ledger Tests Verification
    Given   Nightly Batch Jobs run
    Then    There are no incomplete Batch Job executions

  @KFSQA-649 @validation-after-batch @solid
  Scenario Outline: Validation for Accounting Line Description from eDoc updates General Ledger, part 1
    Given All Nightly Batch Jobs have completed successfully
    And   I can retrieve references to test KFSQA-649 instance data for <docType> saved for validation after batch job execution
    And   I am logged in as a KFS Chart Administrator
    When  I lookup the document ID for the <eDoc> document from the General Ledger
    Then  the Accounting Line Description for the <eDoc> document equals the General Ledger Accounting Line Description
  Examples:
  | eDoc                               | docType |
  | Advance Deposit                    | AD      |
  | Auxiliary Voucher                  | AV      |
  | Credit Card Receipt                | CCR     |
  | Distribution Of Income And Expense | DI      |
  | General Error Correction           | GEC     |
  | Internal Billing                   | IB      |
  | Transfer Of Funds                  | TF      |
