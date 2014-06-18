Feature: Distribution of Income and Expense

  [KFAQA-648] I want to create a DI with an Accounting Line Change by an FO

  [KFSQA-1006] I credit an expenditure from a source account and create an asset into the target account.

  @KFAQA-648 @Approving @DI @Edit @smoke @sloth @needs-clean-up @broken! @pending
  Scenario: Reject Approver Account changes unless they are the Fiscal Officer
    Given   I am logged in as a KFS User
    And     I start an empty Distribution Of Income And Expense document
    And     I add a From amount of "75" for account "G003704" with object code "6250" with a line description of "testing from" to the DI Document
    And     I add a To amount of "75" for account "G254700" with object code "6250" with a line description of "testing to" to the DI Document
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
    And     I approve the Distribution Of Income And Expense document
    When    I view the Distribution Of Income And Expense document
    Then    the Notes and Attachment Tab says "Accounting Line changed from"

  @KFSQA-1006 @DI @E2E @slug @cornell @wip
  Scenario: I credit an expenditure from a source account and create an asset into the target account.
    Given   I create Distribution Of Income And Expense with following:
      | From Chart        | IT      |
      | From Account      | 1003005 |
      | From Object Code  | 6540    |
      | Amount            | 8000    |
      | To Chart          | IT      |
      | To Account        | 1003010 |
      | To Object Code    | 3630    |
      | Capital Asset     | Yes     |
    And     I run the nightly Capital Asset jobs
    And     I build a Capital Asset from the General Ledger
