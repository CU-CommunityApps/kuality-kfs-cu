Feature: Contracts and Grants

  [KFSQA-916] Background : Indirect Cost Recovery Rate can use wildcards as debit and credit and indirect costs post with new rates.

  @KFSQA-916 @CG @smoke @nightly-jobs @wip
  Scenario: Indirect Cost Recovery Rate can use wildcards as debit and credit and indirect costs post with new rates
    Given I am logged in as Contracts and Grants Manager
    And   I create a wild carded Indirect Cost Recovery Rate of 0 percent using random institutional allowance object codes
    And   I remember the Indirect Cost Recovery Rate as a From Indirect Cost Rate
    And   I submit the Indirect Cost Recovery Rate document
    And   the Indirect Cost Recovery Rate document goes to FINAL
    And   I create a wild carded Indirect Cost Recovery Rate of 10 percent using From Indirect Cost Rate institutional allowance object codes
    And   I remember the Indirect Cost Recovery Rate as a To Indirect Cost Rate
    And   I submit the Indirect Cost Recovery Rate document
    And   the Indirect Cost Recovery Rate document goes to FINAL
    And   I am logged in as a KFS User
    And   I remember the logged in user
    And   I edit an active CG account modifying the Indirect Cost Rate to the From Indirect Cost Rate
    And   I remember account number to be used as From Account
    And   I submit the Account document
    And   the Account document goes to ENROUTE
    And   I route the Account document to final
    And   I am logged in as the remembered user
    And   I edit an active CG account to modifying the Indirect Cost Rate to the To Indirect Cost Rate
    And   I remember account number to be used as To Account
    And   I submit the Account document
    And   the Account document goes to ENROUTE
    And   I route the Account document to final
    And   I am logged in as the remembered user
    And   I start an empty Distribution Of Income And Expense document
    And   I add the remembered From account for a Services Object code for amount 100
    And   I add the remembered To account for a Services Object code for amount 100
    And   I submit the Distribution Of Income And Expense document
    And   the Distribution Of Income And Expense document goes to ENROUTE
    And   I route the Distribution Of Income And Expense document to final
    And   Nightly Batch Jobs run
    Then  ICR rates are posted correctly for current month