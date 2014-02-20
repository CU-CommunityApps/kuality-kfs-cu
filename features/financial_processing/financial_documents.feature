Feature: Financial Documents

  [KFSQA-652] Initiator or qualified document role to recall a routed document. New 5.x feature

  @KFSQA-652 @wip
  Scenario Outline: Recall enroute Documents
    Given  I am logged in as "<user>"
    #for all these eDocs
    And    I start an empty <eDoc> document
    And I add a source Accounting Line to the <eDoc> document with the following:
      | Chart Code   | IT |
      | Number       | <source_account> |
      | Object Code  | 6690 |
      | Amount       | <source_amount> |
    And I add a target Accounting Line to the <eDoc> document with the following:
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
#final    | Advance Deposit                    | ccs1  | 2003600        |                | -100          | 0             |
    | Auxiliary Voucher                  | scu1  | H853800        |                | 100           |               |
    | Budget Adjustment                  | sag3  | G003704        | G013300        | 100           | 100           |
#final    | Credit Card Receipt                | ccs1  | G003704        |                | -100           |               |
#final    | Disbursement Voucher               | ccs1  | 5193120        |                | 100           |               |
    | Distribution Of Income And Expense | ccs1  | G003704        | G013300        | 100           | 100           |
    | General Error Correction           | ccs1  | G003704        | G013300        | 100           | 100           |
    | Internal Billing                   | ccs1  | G003704        | G013300        | 100           | 100           |
    | Indirect Cost Adjustment           | ccs1  | 1093600        | GACLOSE        | 100           | 100           |
    | Journal Voucher                    | dh273 | G003704        |                | 100           |               |
    | Non-Check Disbursement             | rlc56 | G013300        |                | 100           |               |
    | Pre-Encumbrance                    | ccs1  | G003704        |                | 100           |               |
    | Service Billing                    | chl52 | U243700        | G013300        | 100           | 100           |
    | Transfer Of Funds                  | ccs1  | A763306        | A763900        | 100           | 100           |
