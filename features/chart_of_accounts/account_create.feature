Feature: KFS Fiscal Officer Account Creation

  [smoke]     As a KFS Fiscal Officer I want to create an Account
              because I want to support a new project
  [KFSQA-554] Because it saves time, I as a KFS User should be able to 
              initiate an Account document with just the description.
  [KFSQA-606] As a KFS Chart User when creating an Account I should be able
              to enter data into Sub Fund Program field regardless of case
              because custom fields should behave similarly to base fields.
  [KFSQA-556] In order to Create an Account as a KFS Chart User, I want to be notified when I leave fields blank.
              The Account Guidelines and Purpose tabs contains some required data that must be verified before submission.

  @smoke @sloth
  Scenario: Create an Account
    Given I am logged in as a KFS Fiscal Officer
    When  I blanket approve an Account document
    And   I view the Account document
    Then  the Account document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |

  @KFSQA-554 @cornell @KFSMI-6160 @hare
  Scenario: KFS User Initiates an Account document with only a description field
    Given I am logged in as a KFS User
    When  I save an Account document with only the Description field populated
    Then  the Account document goes to SAVED
    
  @KFSQA-606 @Bug @AcctEdit @KFSPTS-119 @hare
  Scenario: Account Edit Sub Fund Program case sensitive test on Submit
    Given I am logged in as a KFS Chart Administrator
    When  I save an Account with a lower case Sub Fund Program
    Then  the Account document goes to SAVED

  @KFSQA-556 @Account @Create @KFSMI-7599 @hare
  Scenario: KFS User does not input any fields into Account Guidelines and Purpose Tabs
    Given I am logged in as a KFS Fiscal Officer
    When  I create an Account and leave blank for the fields of Guidelines and Purpose tab
    When  I save the Account document
    Then  I should get these error messages:
      | Expense Guideline is a required field.        |
      | Income Guideline is a required field.         |
      | Account Purpose is a required field.          |
    And   the Account document goes to SAVED
