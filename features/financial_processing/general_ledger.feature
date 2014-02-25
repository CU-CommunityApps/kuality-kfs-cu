Feature: General Ledger

  [KFSQA-649] Cornell University requires an Accounting Line Description input through an eDoc to be recorded in the General Ledger.

  @KFSQA-649 @smoke @nightly-jobs @wip
  Scenario Outline: Accounting Line Description from eDoc updates General Ledger
    Given I am logged in as a KFS Manager for the <docType> document
    And   I clone Account <source_account> with the following changes:
      | Name                                          | <eDoc> Test Account S |
      | Chart Code                                    | IT                    |
      | Description                                   | <eDoc> Test Account S |
      | Sub-Fund Program Code                         | <SFPC>                |
      | Indirect Cost Recovery Chart Of Accounts Code | <ICR_COA_Code>        |
      | Indirect Cost Recovery Account Number         | <ICR_Number>          |
      | Indirect Cost Recovery Account Line Percent   | <ICR_Line_Percent>    |
      | Indirect Cost Recovery Active Indicator       | <ICR_Active>          |
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
    | eDoc                               | docType | source_account | target_account | SFPC | ICR_COA_Code       | ICR_Number | ICR_Line_Percent | ICR_Active | done? |
    | Advance Deposit                    | AD      | 2003600        |                | DAVE |                    |            |                  |            | true  |
    | Auxiliary Voucher                  | AV      | H853800        |                |      |                    |            |                  |            | true  |
    | Credit Card Receipt                | CCR     | G003704        |                |      |                    |            |                  |            | true  |
    | Disbursement Voucher               | DV      | 1490000        |                |      |                    |            |                  |            | skip  |
    | Distribution Of Income And Expense | DI      | G003704        | G013300        |      |                    |            |                  |            | true  |
    | General Error Correction           | GEC     | G003704        | G013300        |      |                    |            |                  |            | true  |
    | Internal Billing                   | IB      | G003704        | G013300        |      |                    |            |                  |            | true  |
    | Indirect Cost Adjustment           | ICA     | 1093600        | GACLOSE        |      | IT - Ithaca Campus | A463200    | 100              | set        | true  |
    | Journal Voucher                    | JV-1    | G003704        | G013300        |      |                    |            |                  |            | true  |
    | Journal Voucher                    | JV-2    | G003704        |                |      |                    |            |                  |            | true  |
    | Journal Voucher                    | JV-3    | G003704        |                |      |                    |            |                  |            | true  |
    | Non-Check Disbursement             | ND      | G013300        |                |      |                    |            |                  |            | true  |
    | Pre-Encumbrance                    | PE      | G003704        |                |      |                    |            |                  |            | true  |
    | Transfer Of Funds                  | TF      | A763306        | A763900        |      |                    |            |                  |            | true  |

  @KFSQA-649 @smoke @nightly-jobs @wip
  Scenario Outline: Accounting Line Description from eDoc updates General Ledger. These eDocs' accounts don't clone nicely.
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
