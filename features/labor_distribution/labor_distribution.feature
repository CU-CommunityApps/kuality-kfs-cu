Feature: Labor Distribution

  [KFSQA-983] Base Function : I CREATE A SALARY EXPENSE TRANSFER

  [KFSQA-984] Base Function : I CREATE A BENEFIT EXPENSE TRANSFER

  [KFSQA-985] Base Function : I RUN THE NIGHTLY LABOR BATCH PROCESSES

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