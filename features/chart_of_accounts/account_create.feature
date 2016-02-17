Feature: Account Creation

  [smoke]     As a KFS Fiscal Officer I want to create an Account
              because I want to support a new project

  [KFSQA-554] Because it saves time, I as a KFS User should be able to 
              initiate an Account document with just the description.

  [KFSQA-606] As a KFS Chart User when creating an Account I should be able
              to enter data into Sub Fund Program field regardless of case
              because custom fields should behave similarly to base fields.

  [KFSQA-556] In order to Create an Account as a KFS Chart User, I want to be notified when I leave fields blank.
              The Account Guidelines and Purpose tabs contains some required data that must be verified before submission.

  [KFSQA-1163] Create an Account should generate an error when attempting to incorporate a closed ICR account, part 1a.

               Edit an Account should generate an error when attempting to incorporate a closed ICR account, part 1b.

               Create/Edit an Account using an open but expired ICR account should submit/approve but should error
               during approval when ICR account modification is attempted to a closed account, part 2.

               Create/Edit an Account using an open and non-expired ICR account should submit/approve but should error
               during approval when ICR account modification is attempted to a closed account, part 3.


  @smoke @sloth @solid
  Scenario: Create an Account
    Given I am logged in as a KFS Fiscal Officer
    When  I blanket approve an Account document
    And   I view the Account document
    Then  the Account document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |

  @KFSQA-554 @cornell @KFSMI-6160 @hare @solid
  Scenario: KFS User Initiates an Account document with only a description field
    Given I am logged in as a KFS User
    When  I save an Account document with only the Description field populated
    Then  the document status is SAVED
    
  @KFSQA-606 @Bug @AcctEdit @KFSPTS-119 @hare @solid
  Scenario: Account Edit Sub Fund Program case sensitive test on Save
    Given I am logged in as a KFS Chart Administrator
    When  I save an Account with a lower case Sub Fund Program
    Then  the Account document goes to SAVED
    And   the Account document's Sub Fund Program code is uppercased

  @KFSQA-556 @Account @Create @KFSMI-7599 @hare @solid
  Scenario: KFS User does not input any fields into Account Guidelines and Purpose Tabs
    Given I am logged in as a KFS Fiscal Officer
    When  I create an Account and leave blank for the fields of Guidelines and Purpose tab
    When  I save the Account document
    Then  I should get these error messages:
      | Expense Guideline is a required field. |
      | Income Guideline is a required field.  |
      | Account Purpose is a required field.   |
    And   the Account document goes to SAVED

  @KFSQA-1163 @KFSQA-905 @Account @CG @smoke @coral @solid
  Scenario: Create an Account should generate an error when attempting to incorporate a closed ICR account, part 1a
    Given I am logged in as a KFS User who is not a Contracts & Grants Processor
    And   I create an Account using a CG account with a CG Account Responsibility ID in range 1 to 8
    When  I add a closed Contacts & Grants Account as the 100 percent Indirect Cost Recovery Account to the Account
    Then  the Account should show an error stating the Indirect Cost Recovery Account is closed

  @KFSQA-1163 @KFSQA-905 @Account @CG @smoke @coral @solid
  Scenario: Edit an Account should generate an error when attempting to incorporate a closed ICR account, part 1b
    Given I am logged in as a KFS User who is not a Contracts & Grants Processor
    And   I edit an Account having a CG account with a CG Account Responsibility ID in range 1 to 8
    And   I edit the first active Indirect Cost Recovery Account on the Account to a closed Contracts & Grants Account
    When  I submit the Account document
    Then  the Account should show an error stating the Indirect Cost Recovery Account is closed

  @KFSQA-1163 @KFSQA-905 @Account @CG @smoke @coral @solid
  Scenario Outline: Create/Edit an Account using an open but expired / open non-expired ICR account should
                    submit/approve but should error during approval when ICR account modification is attempted
                    to a closed account, part 2 and part 3.
    Given I am logged in as a KFS User who is not a Contracts & Grants Processor
    And   I remember the logged in user
    And   I edit an Account having a CG account with a CG Account Responsibility ID in range 1 to 8
    And   I edit the first active Indirect Cost Recovery Account on the Account to an <ICR_account_type> Contracts & Grants Account
    And   I submit the Account document addressing Continutaion Account errors
    Then  the document should have no errors
    And   I display the Account document
    And   I switch to the user with the next Pending Action in the Route Log for the Account document
    And   I display the Account document
    And   I edit the first active Indirect Cost Recovery Account on the Account to a closed Contracts & Grants Account
    And   I approve the Account document
    Then  the Account should show an error stating the Indirect Cost Recovery Account is closed
    And   I edit the first active Indirect Cost Recovery Account on the Account to an <ICR_account_type> Contracts & Grants Account
    And   I approve the Account document
    Then  the document should have no errors
    And   I display the Account document
    Then  APPROVED should be in the Account document Actions Taken
    Examples:
      | ICR_account_type |
      | open expired     |
      | open non-expired |