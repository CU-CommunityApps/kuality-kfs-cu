Feature: FP Auditing

  [KFSQA-631] Cornell University requires an audit trail of changes made by approvers to an eDoc Accounting Line.
              These changes will be stored recorded in the eDdoc Notes and Attachment Tab.

  @KFSQA-631 @wip
  Scenario Outline: Display approver eDoc Accounting Line changes in Notes and Attachment Tab
    Given   I am logged in as a KFS User
    And     I create a <document type> document
#    And     I enter to an Accounting Line on the <document type> document with account number <account number> and object code <object code> and amount <amount>
#    And     I submit the <document type> document
#    And     The <document type> documnent goes to ENROUTE
#    And     I am logged in as a KFS Chart User
#    And     I view the <document type> documnent
#    And     I modify an Accounting Line
#    And     I approve the <document type> documnent
    When    I view the <document type> documnent
#    Then    The Notes and Attachment Tab displays “Accounting Line changed from”
    Examples:
      |  document type                      | account number | object code | amount |
      |  Auxiliary Voucher                  | 4255063        | 3704        | 100    |
      |  Budget Adjustment                  | 4255063        | 3704        | 100    |
      |  Distribution of Income and Expense | 4255063        | 3704        | 100    |
      |  Disbursement Voucher               | 4255063        | 3704        | 100    |
      |  General Error Correction           | 4255063        | 3704        | 100    |
      |  Internal Billing                   | 4255063        | 3704        | 100    |
      |  Indirect Cost Adjustment           | 4255063        | 3704        | 100    |
      |  Pre Encumbrance                    | 4255063        | 3704        | 100    |
      |  Transfer of Funds                  | 4255063        | 3704        | 100    |