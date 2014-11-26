Feature: FP Auditing

  [KFSQA-631] Cornell University requires an audit trail of changes made by an approver to an eDoc Accounting Line.
              These changes will be stored recorded in the eDoc Notes and Attachment Tab.
  [KFSQA-747] Display approver eDoc Accounting Line changes in Notes and Attachment Tab for DV and ICA.


  @KFSQA-631 @BA @cornell @sloth
  Scenario: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for Budget Adjustment
    Given   I am logged in as a KFS User
    When    I start an empty Budget Adjustment document
    And     I add accounting lines to test the notes tab for the Budget Adjustment doc
    And     I submit the Budget Adjustment document
    And     the Budget Adjustment document goes to ENROUTE
    And     I am logged in as a Source Account Fiscal Officer
    And     I view the Budget Adjustment document
    And     on the Budget Adjustment document I modify the From Object Code line item 0 to be 4486
    And     I save the Budget Adjustment document
    Then    The Notes and Attachment Tab displays "Accounting Line changed from"

  @KFSQA-631 @AV @cornell @sloth
  Scenario: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for Auxiliary Voucher
    Given   I am logged in as a KFS User
    And     I start an empty Auxiliary Voucher document
    And     I add accounting lines to test the notes tab for the Auxiliary Voucher doc
    And     I submit the Auxiliary Voucher document
    And     the Auxiliary Voucher document goes to ENROUTE
    And     I am logged in as a Source Account Fiscal Officer
    And     I view the Auxiliary Voucher document
    And     on the Auxiliary Voucher document I modify the From Object Code line item 0 to be 6641
    And     I save the Auxiliary Voucher document
    Then    The Notes and Attachment Tab displays "Accounting Line changed from"

  @KFSQA-631 @GEC @cornell @sloth
  Scenario: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for General Error Correction
    Given   I am logged in as a KFS User
    And     I start an empty General Error Correction document
    And     I add accounting lines to test the notes tab for the General Error Correction doc
    And     I submit the General Error Correction document
    And     the General Error Correction document goes to ENROUTE
    And     I am logged in as a Source Account Fiscal Officer
    And     I view the General Error Correction document
    And     on the General Error Correction document I modify the From Object Code line item 0 to be 4486
    And     I save the General Error Correction document
    Then    The Notes and Attachment Tab displays "Accounting Line changed from"

  @KFSQA-631 @PE @cornell @hare
  Scenario: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for Pre-Encumbrance
    Given   I am logged in as a KFS User
    And     I start an empty Pre-Encumbrance document
    And     I add accounting lines to test the notes tab for the Pre-Encumbrance doc
    And     I save the Pre-Encumbrance document
    And     I submit the Pre-Encumbrance document
    And     the Pre-Encumbrance document goes to ENROUTE
    And     I am logged in as a Source Account Fiscal Officer
    And     I view the Pre-Encumbrance document
    And     on the Pre-Encumbrance document I modify the From Object Code line item 0 to be 6510
    And     I save the Pre-Encumbrance document
    Then    The Notes and Attachment Tab displays "Accounting Line changed from"

  @KFSQA-631 @ND @cornell @hare
  Scenario: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for Non-Check Disbursement
    Given   I am logged in as a KFS User for the ND document
    And     I start an empty Non-Check Disbursement document
    And     I add accounting lines to test the notes tab for the Non Check Disbursement doc
    And     I submit the Non-Check Disbursement document
    And     the Non-Check Disbursement document goes to ENROUTE
    And     I am logged in as a Source Account Fiscal Officer
    And     I view the Non-Check Disbursement document
    And     on the Non-Check Disbursement document I modify the Object Code line item 0 to be 6510
    And     I save the Non-Check Disbursement document
    Then    The Notes and Attachment Tab displays "Accounting Line changed from"

  @KFSQA-631 @DI @IB @TF @cornell @tortoise @broken
  Scenario Outline: Display approver eDoc Accounting Line changes in Notes and Attachment Tab for All with basic from and to accounting lines
    Given   I am logged in as a KFS User
    And     I start an empty <document> document
    And     I add a From accounting line to the <document> document with:
            | from account number  | <from account number> |
            | from object code     | <from object code>    |
            | from amount          | <from amount>         |
    And     I add a To accounting line to the <document> document with:
            | to account number | <to account number> |
            | to object code    | <to object code>    |
            | to amount         | <to amount>         |
    And     I submit the <document> document
    And     the <document> document goes to ENROUTE
    And     I am logged in as a <From or To> Account Fiscal Officer
    And     I view the <document> document
    And     on the <document> document I modify the <From or To> Object Code line item <line item> to be <modify object code>
    # KFSQA-1068 : there is a bug to create audit note when 'approve' in application. 'audit note' will be reworked.  This step will fail for now.
    And     I approve the <document> document
    Then    The Notes and Attachment Tab displays "Accounting Line changed from"
  Examples:
    | document                           | from account number | from object code | from amount | to account number | to object code | to amount | From or To | line item | modify object code |
    | Distribution Of Income And Expense | G003704             | 4480             | 255.55      | G013300           | 4480           | 255.55    | From       |  0        | 4486               |
    | Internal Billing                   | G003704             | 4023             | 950000.67   | G013300           | 4023           | 950000.67 | To         |  0        | 4024               |
    | Transfer Of Funds                  | A763306             | 8070             | 250         | A763900           | 7070           | 250       | To         |  0        | 8070               |
    #TODO create params for source and target account
    #TODO use param service to find object code for each edoc type (not a new param)
    #TODO that param returns a list of denies which we can use to lookup like this: Object Type Code = "!AS!EE"
    #TODO need to do same with object sub types and levels
    #TODO create params for secondary object code for each edoc type


  @KFSQA-747 @DV @ICA @cornell @tortoise @broken
  Scenario Outline: Display approver eDoc Accounting Line changes in Notes and Attachment Tab
    Given  I am logged in as a KFS User for the <type code> document
#for all these eDocs
    And   I start an empty <document> document
    And   I select a vendor payee to the <document> document
    And   I add a Source Accounting Line to the <document> document with the following:
      | Chart Code | IT               |
      | Number     | <source_account> |
      | Amount     | <source_amount>  |
    And   I add a Target Accounting Line to the <document> document with the following:
      | Chart Code | IT               |
      | Number     | <target_account> |
      | Amount     | <target_amount>  |
    And   I submit the <document> document
    And    the <document> document goes to ENROUTE
    And   I am logged in as a Source Account Fiscal Officer
    And   I view the <document> document
    And   I change the Account Organization Reference for Accounting Line 1 to QA747 on the <document>
    # KFSQA-1068 : there is a bug to create audit note when 'approve' in application. 'audit note' will be reworked.  This step will fail for now.
    When  I approve the <document> document
    Then  The Notes and Attachment Tab displays "Accounting Line changed from"
  Examples:
    | document                 | type code | source_account | target_account  | source_amount | target_amount |
    | Disbursement Voucher     | DV        | G003704        |                 | 100           |               |
    | Indirect Cost Adjustment | ICA       | G003704        | GACLOSE         | 100           | 100           |
    #TODO create params for source and target account and object code for each edoc type and grab FO from service
