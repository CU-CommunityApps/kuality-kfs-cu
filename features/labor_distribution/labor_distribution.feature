Feature: Labor Distribution

  [KFSQA-983] Base Function : I CREATE A SALARY EXPENSE TRANSFER

  [KFSQA-984] Base Function : I CREATE A BENEFIT EXPENSE TRANSFER

  [KFSQA-985] Base Function : I RUN THE NIGHTLY LABOR BATCH PROCESSES

  [KFSQA-970] Background: Tests submission of a salary expense transfer and functionality of transfers
              between account types, calculations between rates, and labor access security between orgs.


  @KFSQA-983 @BaseFunction @ST @slug
  Scenario: Base Function : I CREATE A SALARY EXPENSE TRANSFER
    Given I CREATE A SALARY EXPENSE TRANSFER with following:
      | User Name  | dw68    |
      | Employee   | 1006368 |
    And I transfer the Salary to another Account in my Organization
      | To Account | A453101 |
    And   I submit the Salary Expense Transfer document
    Then  the Salary Expense Transfer document goes to FINAL
    And   I RUN THE NIGHTLY LABOR BATCH PROCESSES
    And   I Login as a Labor Distribution Manager
    Then  the labor ledger pending entry for employee '1006368' is empty

  @KFSQA-984 @BaseFunction @BT @tortoise
  Scenario: Base Function : I CREATE A BENEFIT EXPENSE TRANSFER
    Given  I CREATE A BENEFIT EXPENSE TRANSFER with following:
      |From Account  | A464100   |
      |To Account    | A453101   |

  @KFSQA-985 @BaseFunction @tortoise
  Scenario: Base Function for labor nightly batch process.
    Given I RUN THE NIGHTLY LABOR BATCH PROCESSES
    And   I Login as a Salary Transfer Initiator
    # this is just an example to validate the labor batch process is OK.  For different ST/BT
    # this step may revised or make more general
    Then  the labor ledger pending entry for employee '1013939' is empty

  @KFSQA-970 @ST @smoke @wip
  Scenario: Salary Expense Transfer test between account types, between rates, and for labor access security.
    Given I CREATE A SALARY EXPENSE TRANSFER with following:
      | User Name  | ceh19    |
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
      |User Name | dw68 |
    And   a Salary Expense Transfer initiator inside the organization can view the document
      |User Name | rlo4 |
    And   I RUN THE NIGHTLY LABOR BATCH PROCESSES
    And   I Login as a Labor Distribution Manager
    Then  the labor ledger pending entry for employee '2569631' is empty
