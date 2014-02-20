Feature: Financial Documents

  [KFSQA-727] Cornell University requires Chart IT as the default for all FP eDoc Accounting Lines.

  @KFSQA-727
  Scenario Outline: Accounting Line Defaults to Chart IT
    Given  I am logged in as a KFS User for the <docType> document
    And    I start an empty <eDoc> document
    Then   The Chart of Accounts on the accounting line defaults appropriately for the <eDoc> document
  Examples:
    | eDoc                               | docType |
    | Advance Deposit                    | AD      |
    | Auxiliary Voucher                  | AV      |
    | Budget Adjustment                  | BA      |
    | Credit Card Receipt                | CCR     |
    | Disbursement Voucher               | DV      |
    | Distribution Of Income And Expense | DI      |
    | General Error Correction           | GEC     |
#sourcename    | Internal Billing                   | IB      |
    | Indirect Cost Adjustment           | ICA     |
    | Journal Voucher                    | JV      |
    | Non-Check Disbursement             | ND      |
    | Pre-Encumbrance                    | PE      |
    | Service Billing                    | SB      |
    | Transfer Of Funds                  | TF      |
