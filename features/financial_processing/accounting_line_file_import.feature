Feature: import csv for accounting lines on multiple documents

  [KFSQA-643] Accounting Line Description from Import Template updates General Ledger.
              Cornell University requires an Accounting Line Description uploaded through
              an Import Template to be recorded in the General Ledger.

  @KFSQA-643 @AV @JV @ND @Import-Template @cornell @nightly-jobs
  Scenario Outline: Checking General Ledger for Accounting Line Description using from Import Template with blanket approval
    Given   I am logged in as a KFS User for the <type code> document
    And     I start a <document> document for "<file name>" file import
    And     on the <document> I import the From Accounting Lines from a csv file
    And     I submit the <document> document
    And     I am logged in as a KFS Chart Manager
    And     I view the <document> document
    And     I blanket approve the <document> document
    And     Nightly Batch Jobs run
    And     I am logged in as a KFS User for the <type code> document
    And     I am logged in as a KFS Chart Manager
    When    I view the <document> document on the General Ledger Entry
    Then    the Template Accounting Line Description for <document> equals the General Ledger entry
  Examples:
    | document               |type code| file name                        |
    | Auxiliary Voucher      | AV      | AV_import.csv                    |
    | Non Check Disbursement | ND      | ND_import.csv                    |
    | Journal Voucher        | JV-1    | JV-1_offset_bal_type_import.csv  |

  @KFSQA-643 @AD @CCR @Import-Template @cornell @nightly-jobs
  Scenario Outline: Checking General Ledger for Accounting Line Description using Import Template without blanket approval
    Given   I am logged in as a KFS User for the <type code> document
    And     I start a <document> document for "<file name>" file import
    And     on the <document> I import the From Accounting Lines from a csv file
    And     I submit the <document> document
    And     Nightly Batch Jobs run
    And     I am logged in as a KFS User for the <type code> document
    When    I view the <document> document on the General Ledger Entry
    Then    the Template Accounting Line Description for <document> equals the General Ledger entry
    Examples:
      | document               |type code| file name                        |
      | Advance Deposit        | AD      | AD_import.csv                    |
      | Credit Card Receipt    | CCR     | CCR_import.csv                   |

  @KFSQA-643 @BA @DI @GEC @TF @Import-Template @cornell @nightly-jobs
  Scenario Outline: Checking General Ledger for Accounting Line Description using from and to Import Templates with blanket approval
    Given   I am logged in as a KFS User for the <type code> document
    And     I start a <document> document for from "<From file name>" file import and to "<To file name>" file import
    And     on the <document> I import the From Accounting Lines from a csv file
    And     on the <document> I import the To Accounting Lines from a csv file
    And     I submit the <document> document
    And     I am logged in as a KFS Chart Manager
    When    I view the <document> document
    When    I blanket approve the <document> document
    And     Nightly Batch Jobs run
    And     I am logged in as a KFS User for the <type code> document
    When    I view the <document> document on the General Ledger Entry
    Then    the Template Accounting Line Description for <document> equals the General Ledger entry
  Examples:
    | document                             | type code | From file name                | To file name               |
    | Distribution of Income and Expense   | DI        | DI_import_from.csv            | DI_import_to.csv           |
    | General Error Correction             | GEC       | GEC_import_from.csv           | GEC_import_to.csv          |
    | Transfer of Funds                    | TF        | TF_import_from.csv            | TF_import_to.csv           |
    | Budget Adjustment                    | BA        | BA_import_from.csv            | BA_import_to.csv           |

  @KFSQA-643 @IB @SB @Import-Template @cornell @nightly-jobs
  Scenario Outline: Checking General Ledger for Accounting Line Description using from and to Import Templates without blanket approval
    Given   I am logged in as a KFS User for the <type code> document
    And     I start a <document> document for from "<From file name>" file import and to "<To file name>" file import
    And     on the <document> I import the From Accounting Lines from a csv file
    And     on the <document> I import the To Accounting Lines from a csv file
    And     I submit the <document> document
    And     Nightly Batch Jobs run
    And     I am logged in as a KFS User for the <type code> document
    When    I view the <document> document on the General Ledger Entry
    Then    the Template Accounting Line Description for <document> equals the General Ledger entry
  Examples:
    | document                             | type code | From file name                | To file name               |
    | Internal Billing                     | IB        | IB_expense_import.csv         | IB_income_import.csv       |
    | Service Billing                      | SB        | SB_income_line1_import.csv    | SB_expense_line2_import.csv|