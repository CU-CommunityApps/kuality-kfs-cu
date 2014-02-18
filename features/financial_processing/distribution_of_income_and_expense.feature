Feature: Distribution of Income and Expense

  [KFAQA-648] I want to create a DI with an Accounting Line Change by an FO

  @KFAQA-648 @wip
  Scenario: Reject Approver Account changes unless they are the Fiscal Officer
    Given   I am logged in as a KFS User
    And     I start an empty Distribution Of Income And Expense document
    And     I add a from amount of "75" for account "G003704" with object code "6250" with a line description of "testing from" to the DI document
    And     I add a to amount of "75" for account "G254700" with object code "6250" with a line description of "testing to" to the DI document
    And     I submit the Distribution Of Income And Expense document
    And     the Distribution Of Income And Expense document goes to ENROUTE
    And     I am logged in as "djj1"
    And     I view the Distribution Of Income And Expense document
    And     I change the DI from Account to one not owned by the current user
    And     I approve the Distribution of Income And Expense document
    And     I should get an error saying "Existing accounting lines may not be updated to use Account Number IT-A763900 by user djj1."
    And     I view the Distribution Of Income And Expense document
    And     I change the DI from Account to one owned by the current user
    And     I approve the Distribution Of Income And Expense document
    When    I view the Distribution Of Income And Expense document
    Then    The Notes and Attachment Tab includes "Accounting Line changed from"