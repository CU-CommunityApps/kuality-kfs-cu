Feature: Labor Distribution

  [KFSQA-983] Base Function : I CREATE A SALARY EXPENSE TRANSFER

  [KFSQA-984] Base Function : I CREATE A BENEFIT EXPENSE TRANSFER

  @KFSQA-983 @BaseFunction @ST
  Scenario: Base Function : I CREATE A SALARY EXPENSE TRANSFER
    Given  I CREATE A SALARY EXPENSE TRANSFER with following:
      |Employee    | dw68      |
      |To Account  | A453101   |

  @KFSQA-984 @BaseFunction @BT @wip
  Scenario: Base Function : I CREATE A BENEFIT EXPENSE TRANSFER
    Given  I CREATE A BENEFIT EXPENSE TRANSFER with following:
      |From Account  | A464100   |
      |To Account    | A453101   |
