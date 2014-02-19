Feature: Financial Documents

  [KFSQA-727] Cornell University requires Chart IT as the default for all FP eDoc Accounting Lines.

  @KFSQA-727 @wip
  Scenario Outline: Accounting Line Defaults to Chart IT
    Given  I am logged in as a KFS Chart Manager
    And    I start an empty <eDoc> document
    Then   The Chart of Accounts on the accounting line defaults appropriately for the <eDoc> document
  Examples:
    | eDoc                               |
    | Advance Deposit                    |
#    | Auxiliary Voucher                  |
    | Budget Adjustment                  |
#    | Credit Card Receipt                |
#    | Disbursement Voucher               |
#    | Distribution Of Income And Expense |
    | General Error Correction           |
#    | Internal Billing                   |
#    | Indirect Cost Adjustment           |
#    | Journal Voucher                    |
#    | Non-Check Disbursement             |
    | Pre-Encumbrance                    |
#    | Service Billing                    |
#    | Transfer Of Funds                  |
