Feature: FP Auditing

  [KFSQA-631] Cornell University requires an audit trail of changes made by approvers to an eDoc Accounting Line.
              These changes will be stored recorded in the eDdoc Notes and Attachment Tab.

  @KFSQA-631 @wip
  Scenario: Display approver eDoc Accounting Line changes in Notes and Attachment Tab
    Given   I am logged in as a KFS User
    And     I create my Budget Adjustment document without accounting lines
    And     On the Budget Adjustment document I add a From Accounting Line with account number G003704 and object code 4480 and amount 250
    And     On the Budget Adjustment document I add a From Accounting Line with account number G003704 and object code 6510 and amount 250
    And     On the Budget Adjustment document I add a To Accounting Line with account number G013300 and object code 4480 and amount 250
    And     On the Budget Adjustment document I add a To Accounting Line with account number G013300 and object code 6510 and amount 250
    And     I submit the Budget Adjustment document
    And     the Budget Adjustment document goes to ENROUTE
    And     I am logged in as "djj1"
    And     I view my Budget Adjustment document
    And     On the Budget Adjustment I modify the From current amount line item 0 to be 300
    And     On the Budget Adjustment I modify the From current amount line item 1 to be 300
    And     I save the Budget Adjustment document
    And     I am logged in as "sag3"
    And     I view my Budget Adjustment document
    And     On the Budget Adjustment I modify the To current amount line item 0 to be 200
    And     On the Budget Adjustment I modify the To current amount line item 1 to be 200
    #Need to balance budget to get the accounting line change to display
    And     I save the Budget Adjustment document
    And     I approve the Budget Adjustment document
    And     I visit the main page
    When    I view my Budget Adjustment document
    Then    The Notes and Attachment Tab displays “Accounting Line changed from”



#  @KFSQA-631 @wip
#  Scenario Outline: Display approver eDoc Accounting Line changes in Notes and Attachment Tab
#    Given   I am logged in as a KFS User
##    And     I skip adding any accounting lines
#    And     I create my <document type> document
##    And     I create a <document type> document
##    And     I enter to an Accounting Line on the <document type> document with account number <account number> and object code <object code> and amount <amount>
##    And     I enter a To Accounting Line with account number <account number> and object code <object code> and amount <amount>
#    And     On the <document type> I add a From Accounting Line with account number <account number> and object code <object code> and amount <amount>
#    And     On the <document type> I add a To Accounting Line with account number <to account number> and object code <to object code> and amount <to amount>
#    And     I submit the <document type> document
#    And     the <document type> document goes to ENROUTE
##    And     I get the route person
#    And     I am logged in as "<approver>"
#    And     I view the <document type> document
#    And I sleep for 30
#    And     On the <document type> I modify the From Accounting Line with <change from amount>
#    And     On the <document type> I modify the From Accounting Line with <change to amount>
#
##    And     On the <document type> I modify the To Accounting Line with <change from amount>
#    And     I approve the <document type> document
#    When    I view the <document type> document
#    Then    The Notes and Attachment Tab displays “Accounting Line changed from”
#
#
#
#    Examples:
#      |  document type                       |approver| account number   | object code | amount | to account number | to object code | to amount| change from amount | change to amount |
##      |  Auxiliary Voucher                   |lrz8    | H853800          | 6690        | 100    | H853800           | 6690           | 100      | 150                 | 50               |
#      |  Budget Adjustment                   |sag3    | G003704          | 4480        | 250    | G013300           | 4480           | 250      | 300                 | 200               |
##      |  Distribution Of Income And Expense  |sag3    | G003704          | 4480        | 255    | G013300           | 4480           | 255      |  33                | 33               |##
##      |  Disbursement Voucher               |djj1| 4255063        | 3704        | 100    |
##      |  General Error Correction           || 4255063        | 3704        | 100    |
#      |  Internal Billing                   || 4255063        | 3704        | 100    |
#      |  Indirect Cost Adjustment           || 4255063        | 3704        | 100    |
#      |  Pre Encumbrance                    | 4255063        | 3704        | 100    |
#      |  Transfer of Funds                  | 4255063        | 3704        | 100    |



