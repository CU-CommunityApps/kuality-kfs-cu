Feature: Labor Distribution

  [KFSQA-983] Base Function : I create a Salary Expense Transfer

  [KFSQA-984] Base Function : I create a Benefit Expense Transfer

  [KFSQA-985] Base Function : I run the nightly Labor batch process

  [KFSQA-970] Background: Tests submission of a salary expense transfer and functionality of transfers
              between account types, calculations between rates, and labor access security between orgs.
              Required Setup Data specifications are located in the JIRA.

  [KFSQA-1012] Background: This tests privileged functionality for cross divisional transfers and
               ability to edit object codes on a salary transfer edoc.


  @KFSQA-983 @BaseFunction @ST @slug
  Scenario: Base Function : I create a Salary Expense Transfer
    Given I create a Salary Expense Transfer with following:
      | User Name  | dw68    |
      | Employee   | 1006368 |
    And I transfer the Salary to another Account in my Organization
      | To Account | A453101 |
    And   I submit the Salary Expense Transfer document
    Then  the Salary Expense Transfer document goes to FINAL
    And   I run the nightly Labor batch process
    And   I am logged in as a Labor Distribution Manager
    Then  the labor ledger pending entry for employee '1006368' is empty

  @KFSQA-984 @BaseFunction @BT @tortoise
  Scenario: Base Function : I create a Benefit Expense Transfer
    Given  I create a Benefit Expense Transfer with following:
      |From Account  | A464100   |
      |To Account    | A453101   |

  @KFSQA-985 @BaseFunction @tortoise
  Scenario: Base Function for labor nightly batch process.
    Given I run the nightly Labor batch process
    And   I am logged in as a Salary Transfer Initiator
    # this is just an example to validate the labor batch process is OK.  For different ST/BT
    # this step may revised or make more general
    Then  the labor ledger pending entry for employee '1013939' is empty

  @KFSQA-970 @ST @smoke @coral
  Scenario: Salary Expense Transfer test between account types, between rates, and for labor access security.
    Given I create a Salary Expense Transfer with following:
      | User Name  | ceh19   |
      | Employee   | 2569631 |
    And   I transfer the Salary between accounts with different Account Types
      | To Account | 5032020 |
    And   I submit the Salary Expense Transfer document
    And   I remember the Salary Expense Transfer document number
    Then  I should get an error that starts with "Invalid transfer between account types"
    And   I transfer the Salary to an Account with a different Rate but the same Account Type and Organization
      | To Account | 5088700 |
    And   I submit the Salary Expense Transfer document
    And   the Salary Expense Transfer document goes to ENROUTE
    And   I route the Salary Expense Transfer document to final
    Then  the Salary Expense Transfer document goes to FINAL
    And   a Salary Expense Transfer initiator outside the organization cannot view the document
      | User Name | dw68 |
    And   a Salary Expense Transfer initiator inside the organization can view the document
      | User Name | rlo4 |
    And   I run the nightly Labor batch process
    And   I am logged in as a Labor Distribution Manager
    Then  the labor ledger pending entry for employee '2569631' is empty

   @KFSQA-1012 @ST @smoke @wip
  Scenario: Submit a salary transfer edoc between account types, edit the object code, verify pending entries, and submit successfully.
    Given logged in as an ST initiator role 10004
    When  run SALARY EXPENSE
    And   transfer between accounts with different account types
    And   Edit object code to replace with a different labor object code
    And   verify pending entries
    And   submit
    Then  doc should become FINAL