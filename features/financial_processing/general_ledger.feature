Feature: General Ledger

  [KFSQA-649] Cornell University requires an Accounting Line Description input through an eDoc to be recorded in the General Ledger.
  [KFSQA-647] Cornell needs a to ensure that all eight Main Menu->Balance Inquiries-->General Ledger are working.

  @KFSQA-649 @smoke @nightly-jobs @coral
  Scenario Outline: Accounting Line Description from eDoc updates General Ledger, part 1
    Given I am logged in as a KFS Manager for the <docType> document
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
    Given I am logged in as a KFS Manager for the <docType> document
    And   I view the <eDoc> document
    And   I blanket approve the <eDoc> document if it is not already FINAL
    And   the <eDoc> document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |
    Given Nightly Batch Jobs run
    And   I am logged in as a KFS Chart Administrator
    When  I lookup the document ID for the <eDoc> document from the General Ledger
    Then  the Accounting Line Description for the <eDoc> document equals the General Ledger Accounting Line Description
  Examples:
    | eDoc                               | docType | source_account | target_account |
    | Advance Deposit                    | AD      | 2003600        |                |
    | Auxiliary Voucher                  | AV      | H853800        |                |
    | Credit Card Receipt                | CCR     | G003704        |                |
    | Distribution Of Income And Expense | DI      | G003704        | G013300        |
    | General Error Correction           | GEC     | G003704        | G013300        |
    | Internal Billing                   | IB      | G003704        | G013300        |
    | Journal Voucher                    | JV-1    | G003704        | G013300        |
    | Journal Voucher                    | JV-2    | G003704        |                |
    | Journal Voucher                    | JV-3    | G003704        |                |
    | Non-Check Disbursement             | ND      | G013300        |                |
    | Pre-Encumbrance                    | PE      | G003704        |                |
    | Transfer Of Funds                  | TF      | A763306        | A763900        |
  #TODO grab accounts from parameter

  @KFSQA-649 @smoke @nightly-jobs @tortoise
  Scenario Outline: Accounting Line Description from eDoc updates General Ledger, part 4. These eDocs' accounts don't clone nicely.
    Given I am logged in as a KFS Manager for the <docType> document
    And   I use these Accounts:
      | <source_account> |
      | <target_account> |
    And   I am logged in as a KFS User for the <docType> document
    When  I start an empty <eDoc> document
    And   I add balanced Accounting Lines to the <eDoc> document
    And   I save the <eDoc> document
    And   I submit the <eDoc> document
    Given I am logged in as a KFS Manager for the <docType> document
    And   I view the <eDoc> document
    And   I blanket approve the <eDoc> document if it is not already FINAL
    And   the <eDoc> document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |
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
    Given I am logged in as a KFS Manager for the DV document
    And   I clone Account 1490000 with the following changes:
      | Name        | Disbursement Voucher Test Account S |
      | Chart Code  | IT                                  |
      | Description | Disbursement Voucher Test Account S |
    #TODO KYLE try using the default account for DV
    And   I am logged in as a KFS User for the DV document
    When  I start an empty Disbursement Voucher document with Payment to Vendor 12076-0 and Reason Code B
    #TODO loookup/calculate this
    And   I add balanced Accounting Lines to the Disbursement Voucher document
    And   I save the Disbursement Voucher document
    Then  I submit the Disbursement Voucher document
    When  I route the Disbursement Voucher document to final
    Given I am logged in as a KFS Manager for the DV document
    And   I view the Disbursement Voucher document
    And   I blanket approve the Disbursement Voucher document if it is not already FINAL
    And   the Disbursement Voucher document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |
    Given Nightly Batch Jobs run
    And   I am logged in as a KFS Chart Administrator
    When  I lookup the document ID for the Disbursement Voucher document from the General Ledger
    Then  the Accounting Line Description for the Disbursement Voucher document equals the General Ledger Accounting Line Description

  @KFSQA-649 @smoke @nightly-jobs @tortoise
  Scenario: Accounting Line Description from eDoc updates General Ledger, part 3
    Given I am logged in as a KFS Manager for the ICA document
    And   I clone Account 1093600 with the following changes:
      | Name                                          | Indirect Cost Adjustment Test Account S |
      | Chart Code                                    | IT                                      |
      | Description                                   | Indirect Cost Adjustment Test Account S |
      | Indirect Cost Recovery Chart Of Accounts Code | IT - Ithaca Campus                      |
      | Indirect Cost Recovery Account Number         | A463200                                 |
      | Indirect Cost Recovery Account Line Percent   | 100                                     |
      | Indirect Cost Recovery Active Indicator       | set                                     |
    And   I clone Account GACLOSE with the following changes:
      | Name                              | Indirect Cost Adjustment Test Account T |
      | Chart Code                        | IT                                      |
      | Description                       | Indirect Cost Adjustment Test Account T |
    And   I am logged in as a KFS User for the ICA document
    When  I start an empty Indirect Cost Adjustment document
    And   I add balanced Accounting Lines to the Indirect Cost Adjustment document
    And   I save the Indirect Cost Adjustment document
    And   I submit the Indirect Cost Adjustment document
    Given I am logged in as a KFS Manager for the ICA document
    And   I view the Indirect Cost Adjustment document
    And   I blanket approve the Indirect Cost Adjustment document if it is not already FINAL
    And   the Indirect Cost Adjustment document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |
    Given Nightly Batch Jobs run
    And   I am logged in as a KFS Chart Administrator
    When  I lookup the document ID for the Indirect Cost Adjustment document from the General Ledger
    Then  the Accounting Line Description for the Indirect Cost Adjustment document equals the General Ledger Accounting Line Description