Feature: FP Auditing

  [KFSQA-631] Cornell University requires an audit trail of changes made by approvers to an eDoc Accounting Line.
              These changes will be stored recorded in the eDdoc Notes and Attachment Tab.



  @KFSQA-631 @wip
  Scenario: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for Budget Adjustment
    Given   I am logged in as a KFS User
    When     I start an empty Budget Adjustment document
#    And     I create a Budget Adjustment document without accounting lines
    And     I add accounting lines to test the notes tab for the Budget Adjustment doc
    And     I submit the Budget Adjustment document
    And     the Budget Adjustment document goes to ENROUTE
    And     I am logged in as "djj1"
    And     I view my Budget Adjustment document
    And     On the Budget Adjustment I modify the From Object Code line item 0 to be 4486
    And     I save the Budget Adjustment document
    Then    The Notes and Attachment Tab displays "Accounting Line changed from"

  @KFSQA-631 @wip
  Scenario: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for Auxiliary Voucher
    Given   I am logged in as "scu1"
    And     I start an empty Auxiliary Voucher document
#    And     I create a Auxiliary Voucher document without accounting lines
    And     I add accounting lines to test the notes tab for the Auxiliary Voucher doc
    And     I submit the Auxiliary Voucher document
    And     the Auxiliary Voucher document goes to ENROUTE
    And     I am logged in as "lrz8"
    And     I view the Auxiliary Voucher document
    And     On the Auxiliary Voucher I modify the From Object Code line item 0 to be 6641
    And     I save the Auxiliary Voucher document
    Then    The Notes and Attachment Tab displays "Accounting Line changed from"

  @KFSQA-631 @wip
  Scenario: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for General Error Correction
    Given   I am logged in as "sag3"
    And     I start an empty General Error Correction document
#    And     I create a General Error Correction document without accounting lines
    And     I add accounting lines to test the notes tab for the General Error Correction doc
    And     I submit the General Error Correction document
    And     the General Error Correction document goes to ENROUTE
    And     I am logged in as "djj1"
    And     I view the General Error Correction document
    And     On the General Error Correction I modify the From Object Code line item 0 to be 4486
    And     I save the General Error Correction document
    Then    The Notes and Attachment Tab displays "Accounting Line changed from"

  @KFSQA-631 @wip
  Scenario: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for Pre Encumbrance
    Given   I am logged in as "sag3"
    And     I start an empty Pre Encumbrance document
#    And     I create a Pre Encumbrance document without accounting lines
    And     I add accounting lines to test the notes tab for the Pre Encumbrance doc
    And     I save the Pre Encumbrance document
    And     I submit the Pre Encumbrance document
    And     the Pre Encumbrance document goes to ENROUTE
    And     I am logged in as "djj1"
    And     I view the Pre Encumbrance document
    And     On the Pre Encumbrance I modify the From Object Code line item 0 to be 6510
    And     I save the Pre Encumbrance document
    Then    The Notes and Attachment Tab displays "Accounting Line changed from"

  @KFSQA-631 @wip
  Scenario: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for Non Check Disbursement
    Given   I am logged in as "rlc56"
    And     I start an empty Non Check Disbursement document
#    And     I create a Non Check Disbursement document without accounting lines
    And     I add accounting lines to test the notes tab for the Non Check Disbursement doc
    And     I submit the Non Check Disbursement document
    And     the Non Check Disbursement document goes to ENROUTE
    And     I am logged in as "djj1"
    And     I view the Non Check Disbursement document
    And     On the Non Check Disbursement I modify the Object Code line item 0 to be 6510
    And     I save the Non Check Disbursement document
    Then    The Notes and Attachment Tab displays "Accounting Line changed from"

  @KFSQA-631 @wip
  Scenario Outline: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for All with basic from and to accounting lines
    Given   I am logged in as "<initiator>"
    And     I start an empty <document> document
    And     I add a From accounting line to the <document> document with:
      | from account number |<from account number>|
      |from object code     |<from object code>   |
      |from amount          |<from amount>        |
    And     I add a To accounting line to the <document> document with:
      |to account number|<to account number>|
      |to object code   |<to object code>   |
      |to amount        |<to amount>        |
    And     I submit the <document> document
    And     the <document> document goes to ENROUTE
    And     I am logged in as "<approver>"
    And     I view the <document> document
    And     On the <document> I modify the <From or To> Object Code line item <line item> to be <modify object code>
    And     I sleep for 5
    And     I save the <document> document
    Then    The Notes and Attachment Tab displays "Accounting Line changed from"
  Examples:
|  document                           |initiator | approver|from account number|from object code| from amount| to account number | to object code| to amount | From or To | line item| modify object code  |
|  Distribution Of Income And Expense | sag3     | djj1    | G003704           | 4480           | 255.55     | G013300           | 4480          | 255.55    | From       |  0       | 4486                |
|  Internal Billing                   | djj1     | sag3    | G003704           | 4023           | 950000.67  | G013300           | 4023          | 950000.67 | To         |  0       | 4024                |
|  Transfer Of Funds                  | mdw84    | hc224   | A763306           | 8070           | 250        | A763900           | 7070          | 250       | To         |  0       | 8070                |
