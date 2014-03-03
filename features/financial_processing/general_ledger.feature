Feature: General Ledger

  [KFSQA-649] Cornell University requires an Accounting Line Description input through an eDoc to be recorded in the General Ledger.
  [KFSQA-647] Cornell needs a to ensure that all eight Main Menu->Balance Inquiries-->General Ledger are working.

  @KFSQA-649 @smoke @nightly-jobs @pending
  Scenario Outline: Accounting Line Description from eDoc updates General Ledger
    Given I am logged in as a KFS Chart Manager
    #Given I am logged in as a KFS Chart Administrator
    And   I clone Account <source_account> with the following changes:
      | Name                                          | <eDoc> Test Account S |
      | Chart Code                                    | IT                    |
      | Description                                   | <eDoc> Test Account S |
      | Indirect Cost Recovery Chart Of Accounts Code | <ICR_COA_Code>        |
      | Indirect Cost Recovery Account Number         | <ICR_Number>          |
      | Indirect Cost Recovery Account Line Percent   | <ICR_Line_Percent>    |
      | Indirect Cost Recovery Active Indicator       | <ICR_Active>          |
    And   I clone Account <target_account> with the following changes:
      | Name                              | <eDoc> Test Account T |
      | Chart Code                        | IT                    |
      | Description                       | <eDoc> Test Account T |
    #And   I am logged in as a KFS User for the <docType> document
    Given I am logged in as a KFS Chart Administrator
    When  I start an empty <eDoc> document
    And   I add balanced Accounting Lines to the <eDoc> document
    And   I submit the <eDoc> document
    And   I blanket approve the <eDoc> document
    And   the <eDoc> document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |
    Given I am logged in as a KFS Chart Administrator
    And   Nightly Batch Jobs run
    When  I lookup the document ID for the <eDoc> document from the General Ledger
    Then  the Accounting Line Description for the <eDoc> document equals the General Ledger Accounting Line Description
  Examples:
    | eDoc                               | docType | source_account | target_account | ICR_COA_Code       | ICR_Number | ICR_Line_Percent | ICR_Active | done? |
#    | Advance Deposit                    | AD      | 2003600        |                |                    |            |                  |            | true  |
#    | Auxiliary Voucher                  | AV      | H853800        |                |                    |            |                  |            | true  |
#    | Budget Adjustment                  | BA      | G003704        | G013300        |                    |            |                  |            | M     |
#    | Credit Card Receipt                | CCR     | G003704        |                |                    |            |                  |            | S     |
    | Disbursement Voucher               | DV      | 5193120        |                |                    |            |                  |            | false |
#    | Distribution Of Income And Expense | DI      | G003704        | G013300        |                    |            |                  |            | true  |
#    | General Error Correction           | GEC     | G003704        | G013300        |                    |            |                  |            | true  |
#    | Internal Billing                   | IB      | G003704        | G013300        |                    |            |                  |            | true  |
#    | Indirect Cost Adjustment           | ICA     | 1093600        | GACLOSE        | IT - Ithaca Campus | A463200    | 100              | set        | true  |
#    | Journal Voucher                    | JV-1    | G003704        | G013300        |                    |            |                  |            | S     |
#    | Journal Voucher                    | JV-2    | G013300        |                |                    |            |                  |            | ?     |
#    | Journal Voucher                    | JV-3    | G003704        |                |                    |            |                  |            | ?     |
#    | Non-Check Disbursement             | ND      | G013300        |                |                    |            |                  |            | S     |
#    | Pre-Encumbrance                    | PE      | G003704        |                |                    |            |                  |            | true  |
#    | Service Billing                    | SB      | U243700        | G013300        |                    |            |                  |            | S     |
#    | Transfer Of Funds                  | TF      | A763306        | A763900        |                    |            |                  |            | true  |

  @KFSQA-647 @smoke
  Scenario Outline: Obtain query results for Balance Inquiries to indicate KFS is running .
    Given   I am logged in as a KFS User
    When    I perform a <GL Balance Inquiry Lookup> Lookup using account number <account_number>
    Then    the lookup should return results
  Examples:
    | GL Balance Inquiry Lookup      | account_number |
    | Available Balances             | 1*             |
    | Balances by Consolidation      | 1000710        |
    | Cash Balances                  | 1*             |
    | Current Fund Balance           | 1000710        |
    | General Ledger Balance         | 1*             |
    | General Ledger Entry           | 1*             |
    | General Ledger Pending Entry   | 1*             |
    | Open Encumbrances              | 1*             |