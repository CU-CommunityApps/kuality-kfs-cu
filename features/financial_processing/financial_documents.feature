Feature: Financial Documents

  [KFSQA-652] Initiator or qualified document role to recall a routed document. New 5.x feature
  [KFSQA-727] Cornell University requires Chart IT as the default for all FP eDoc Accounting Lines.

  @KFSQA-652 @coral
  Scenario Outline: Recall enroute Documents
    Given  I am logged in as "<user>"
    #TODO login as user for this document type
    And    I start an empty <eDoc> document
    And I add a Source Accounting Line to the <eDoc> document with the following:
      | Chart Code   | IT |
      | Number       | <source_account> |
      | Object Code  | 6690 |
      | Amount       | <source_amount> |
    And I add a Target Accounting Line to the <eDoc> document with the following:
      | Chart Code   | IT |
      | Number       | <target_account> |
      | Object Code  | 6690 |
      | Amount       | <target_amount> |
    And    I save the <eDoc> document
    And    I submit the <eDoc> document
    And    the <eDoc> document goes to ENROUTE
    When   I recall the financial document
    Then   the <eDoc> document goes to SAVED
  Examples:
    | eDoc                               | user  | source_account | target_account | source_amount | target_amount |
    | Auxiliary Voucher                  | scu1  | H853800        |                | 100           |               |
    | Budget Adjustment                  | sag3  | G003704        | G003704        | 100           | 100           |
    | Distribution Of Income And Expense | ccs1  | G003704        | G013300        | 100           | 100           |
    | General Error Correction           | ccs1  | G003704        | G013300        | 100           | 100           |
    | Internal Billing                   | ccs1  | G003704        | G013300        | 100           | 100           |
    | Indirect Cost Adjustment           | ccs1  | 1093600        | GACLOSE        | 100           | 100           |
    | Journal Voucher                    | dh273 | G003704        |                | 100           |               |
    | Non-Check Disbursement             | rlc56 | G013300        |                | 100           |               |
    | Pre-Encumbrance                    | ccs1  | G003704        |                | 100           |               |
    | Transfer Of Funds                  | ccs1  | A763306        | A763900        | 100           | 100           |
  #TODO grab account from parameter

  @KFSQA-727 @tortoise @needs-clean-up
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

