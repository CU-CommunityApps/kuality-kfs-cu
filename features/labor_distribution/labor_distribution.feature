Feature: Labor Distribution

  [KFSQA-983] Base Function : I CREATE A SALARY EXPENSE TRANSFER

  [KFSQA-984] Base Function : I CREATE A BENEFIT EXPENSE TRANSFER

  [KFSQA-985] Base Function : I RUN THE NIGHTLY LABOR BATCH PROCESSES

  [KFSQA-970] Background: Tests submission of a salary expense transfer and functionality of transfers
              between account types, calculations between rates, and labor access security between orgs.


  @KFSQA-983 @BaseFunction @ST @tortoise
  Scenario: Base Function : I CREATE A SALARY EXPENSE TRANSFER
    Given  I CREATE A SALARY EXPENSE TRANSFER with following:
      |Employee    | dw68      |
      |To Account  | A453101   |
    And   I RUN THE NIGHTLY LABOR BATCH PROCESSES
    And   I Login as a Salary Transfer Initiator
    Then  the labor ledger pending entry for employee '1013939' is empty

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
    Given logged in as an ST initiator role 10005
    When run SALARY EXPENSE
    And transfer between accounts with different account types
    And receive Error: Invalid transfer between account types
    And change transfer accounting line to transfer to an account with the same account type and org
    And accounts used have different rates; one fed and one non-fed rate
    Then verify ST initiator role 10005 from outside org cannot search and see and return the edoc (Rows are hidden)
    And verify ST initiator role 10005 from within org can search and see and return the edoc (rows not hidden)
    Then verify all pending entries after nightly batch job has run (following approvals)
