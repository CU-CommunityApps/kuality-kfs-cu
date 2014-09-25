Feature: Distribution of Income and Expense

  [KFAQA-648] I want to create a DI with an Accounting Line Change by an FO

  [KFSQA-1006] I credit an expenditure from a source account and create an asset into the target account.

  [KFSQA-1007] I credit an asset from the source account it was originally posted to. I lookup that asset. I transfer the cost to a target account with an expenditure object code.

  @KFAQA-648 @Approving @DI @Edit @smoke @sloth @needs-clean-up @pending
  Scenario: Reject Approver Account changes unless they are the Fiscal Officer
    Given   I am logged in as a KFS User
    And     I start an empty Distribution Of Income And Expense document
    And     I add a From amount of "75" for account "G003704" with object code "6540" with a line description of "testing from" to the DI Document
    And     I add a To amount of "75" for account "G254700" with object code "6540" with a line description of "testing to" to the DI Document
    #TODO FIX hard coded account and object code
    And     I submit the Distribution Of Income And Expense document
    And     the Distribution Of Income And Expense document goes to ENROUTE
    And     I am logged in as "djj1"
    #TODO   and I login as next user in route log
    And     I view the Distribution Of Income And Expense document
    And     I change the DI from Account to one not owned by the current user
    And     I approve the Distribution of Income And Expense document
    And     I should get these error messages:
      | Existing accounting lines may not be updated to use Chart Code IT by user djj1.          |
      | Existing accounting lines may not be updated to use Account Number A763900 by user djj1. |
    And     I view the Distribution Of Income And Expense document
    And     I change the DI from Account to one owned by the current user
    # 'approve' without save is not working for audit notes, and it is a bug.  'audit' will be reworked
    And     I save the Distribution Of Income And Expense document
#    When    I view the Distribution Of Income And Expense document
    Then    the Notes and Attachment Tab says "Accounting Line changed from"

  @KFSQA-1006 @DI @E2E @slug @cornell
  Scenario: I credit an expenditure from a source account and create an asset into the target account.
    Given   I create a Distribution of Income and Expense document with the following:
      | Line Type | Chart Code | Account | Object Code | Amount | Capital Asset? |
      | From      | IT         | 1003005 | 6540        | 8000   |                |
      | To        | IT         | 1003010 | 3630        | 8000   | Yes            |
    And     I run the nightly Capital Asset jobs
    And     I build a Capital Asset from the General Ledger

  @KFSQA-1007 @DI @E2E @slug
  Scenario: I credit an asset from the source account it was originally posted to. I lookup that asset. I transfer the cost to a target account with an expenditure object code.
    Given   I Login as an Asset Processor
    And     I lookup a Capital Asset with the following:
      | Campus     | IT       |
      | Building   | 7000     |
#      | Room       | XXXXXXXX |
      | Room       | Y&O      |
      | Asset Type | 019      |
      | Asset Code | A        |
    And     I select Capital Asset detail information
    Given   I create a Distribution of Income and Expense document with the following:
      | Line Type | Chart Code | Account | Object Code | Amount | Capital Asset? |
      | To        | IT         | 1003005 | 6540        |        | No             |
    And     I run the nightly Capital Asset jobs
    And     I modify a Capital Asset from the General Ledger and apply payment
