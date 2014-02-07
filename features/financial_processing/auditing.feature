Feature: FP Auditing

  [KFSQA-631] Cornell University requires an audit trail of changes made by approvers to an eDoc Accounting Line.
              These changes will be stored recorded in the eDdoc Notes and Attachment Tab.

  @KFSQA-631 @wip
  Scenario: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for Budget Adjustment
    Given   I am logged in as a KFS User
    And     I create a Budget Adjustment document without accounting lines
    And     I enter from an Accounting Line on the Budget Adjustment document with account number G003704 and object code 4480 and amount 250
    And     I enter from an Accounting Line on the Budget Adjustment document with account number G003704 and object code 6510 and amount 250
    And     I enter to an Accounting Line on the Budget Adjustment document with account number G013300 and object code 4480 and amount 250
    And     I enter to an Accounting Line on the Budget Adjustment document with account number G013300 and object code 6510 and amount 250
    And     I submit the Budget Adjustment document
    And     the Budget Adjustment document goes to ENROUTE
    And     I am logged in as "djj1"
    And     I view my Budget Adjustment document
    And     On the Budget Adjustment I modify the From Object Code line item 0 to be 4486
    And     I save the Budget Adjustment document
    Then    The Notes and Attachment Tab displays “Accounting Line changed from”

  @KFSQA-631 @wip
  Scenario: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for Auxiliary Voucher
    Given   I am logged in as "scu1"
    And     I create a Auxiliary Voucher document without accounting lines
    And     I enter an Accounting Line on the Auxiliary Voucher document with account number H853800 and object code 6690 and debit amount 100
    And     I enter an Accounting Line on the Auxiliary Voucher document with account number H853800 and object code 6690 and credit amount 100
    And     I submit the Auxiliary Voucher document
    And     the Auxiliary Voucher document goes to ENROUTE
    And     I am logged in as "lrz8"
    And     I view the Auxiliary Voucher document
    And     On the Auxiliary Voucher I modify the Object Code line item 0 to be 6641
    And     I save the Auxiliary Voucher document
    Then    The Notes and Attachment Tab displays “Accounting Line changed from”

  @KFSQA-631 @wip
  Scenario: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for Distribution of Income and Expense
    Given   I am logged in as "sag3"
    And     I create a Distribution of Income and Expense document without accounting lines
    And     I enter from an Accounting Line on the Distribution of Income and Expense document with account number G003704 and object code 4480 and amount 255.55
    And     I enter to an Accounting Line on the Distribution of Income and Expense document with account number G013300 and object code 4480 and amount 255.55
    And     I submit the Distribution of Income and Expense document
    And     the Distribution of Income and Expense document goes to ENROUTE
    And     I am logged in as "djj1"
    And     I view the Distribution of Income and Expense document
    And     On the Distribution of Income and Expense I modify the From Object Code line item 0 to be 4486
    And     I save the Distribution of Income and Expense document
    Then    The Notes and Attachment Tab displays “Accounting Line changed from”


  @KFSQA-631 @wip
  Scenario: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for General Error Correction
    Given   I am logged in as "sag3"
    And     I create a General Error Correction document without accounting lines
    And     I enter a from Accounting Line on the General Error Correction document with account number G003704 and object code 4480 and amount 255.55 and reference origin code 01 and reference number 777001
    And     I enter a to Accounting Line on the General Error Correction document with account number G013300 and object code 4480 and amount 255.55 and reference origin code 01 and reference number 777002
    And     I submit the General Error Correction document
    And     the General Error Correction document goes to ENROUTE
    And     I am logged in as "djj1"
    And     I view the General Error Correction document
    And     On the General Error Correction I modify the From Object Code line item 0 to be 4486
    And     I save the General Error Correction document
    Then    The Notes and Attachment Tab displays “Accounting Line changed from”



#  @KFSQA-631 @wip @not_ready_needs_remediation_still
#  Scenario: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for Indirect Cost Adjustment
#    Given   I am logged in as "imm3"
#    And     I create a Indirect Cost Adjustment document without accounting lines
#    And     I enter a from Accounting Line on the Indirect Cost Adjustment document with account number 1278003 and amount 100
# note: After adding a to was aded 1003053, 4290
#    And     I enter a to Accounting Line on the Indirect Cost Adjustment document with account number Y404171 amount 100
#    And     I submit the Indirect Cost Adjustment document
#    And     the Indirect Cost Adjustment document goes to ENROUTE
#    And     I am logged in as "sld8"
#    And     I view the Indirect Cost Adjustment document
#    And     On the Indirect Cost Adjustment I modify the From Account Number line item 0 to be 1003015
#    And     I save the Indirect Cost Adjustment document
#    Then    The Notes and Attachment Tab displays “Accounting Line changed from”




  @KFSQA-631 @wip
  Scenario Outline: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for All with basic from and to accounting lines
    Given   I am logged in as "<initiator>"
    And     I create a <document type> document without accounting lines
    And     I enter from an Accounting Line on the <document type> document with account number <from account number> and object code <from object code> and amount <from amount>
    And     I enter to an Accounting Line on the <document type> document with account number <to account number> and object code <to object code> and amount <to amount>
    And     I submit the <document type> document
    And     the <document type> document goes to ENROUTE
    And     I am logged in as "<approver>"
    And     I view the <document type> document
    And     On the <document type> I modify the <From or To> Object Code line item <line item> to be <modify object code>
    And     I save the <document type> document
    Then    The Notes and Attachment Tab displays “Accounting Line changed from”
  Examples:
|  document type                      |initiator | approver|from account number|from object code| from amount| to account number | to object code| to amount | From or To | line item| modify object code  |
#|  Distribution of Income and Expense | sag3     | djj1    | G003704           | 4480           | 255.55     | G013300           | 4480          |255.55    | From       |  0       |4486                 |
|  Internal Billing                   | djj1     | sag3    | G003704           | 4023           | 950000.67  |G013300            |4023           |950000.67  | To         |  0       |4024                 |
|Pre Encumbrance                      |
         |

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
#     |  document type                      |approver| account number   | object code | amount | to account number | to object code | to amount| change from amount | change to amount |
#     |  Auxiliary Voucher                  |lrz8    | H853800          | 6690        | 100    | H853800           | 6690           | 100      | 150                 | 50               |
#     |  Budget Adjustment                  |sag3    | G003704          | 4480        | 250    | G013300           | 4480           | 250      | 300                 | 200               |
#     |  Distribution Of Income And Expense |sag3    | G003704          | 4480        | 255    | G013300           | 4480           | 255      |  33                | 33               |##
#     |  Disbursement Voucher               |djj1    | 4255063        | 3704        | 100    |
#     |  General Error Correction           |        | 4255063        | 3704        | 100    |
#     |  Internal Billing                   |        | 4255063        | 3704        | 100    |
#     |
#     |  Pre Encumbrance                    |        |  4255063        | 3704        | 100    |
#     |  Transfer of Funds                  |        |  4255063        | 3704        | 100    |
         N D

#                 Examples:
#    | document type | account number | object code | amount | approver | to account number | to object code | to amount |
#
#
#  Internal Billing
#    special need for adding accounting lines
#   action(:add_income_accounting_line) {|b| b.frm.button(name: 'methodToCall.insertSourceLine.anchoraccountingSourceAnchor') }
#   action(:add_expense_accounting_line) {|b| b.frm.button(name: 'methodToCall.insertTargetLine.anchoraccountingTargetAnchor') }