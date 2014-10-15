Feature: Contracts and Grants

  [KFSQA-901] Create and edit a Contracts and Grants Reporting Code, assign it to an Object Code,
              and search for the Object Code by using the Contracts and Grants Reporting Code.
              Default data used in this test is specified in KFS Parameter: DEFAULT_CONTRACT_GRANT_LEVEL_CODE.

  [KFSQA-916] Background : Indirect Cost Recovery Rate can use wildcards as debit and credit and indirect costs post with new rates.


  @KFSQA-901 @CG @smoke @coral
  Scenario: Create and edit Contracts and Grants Reporting Code, assign it to an Object Code, then search for the Object Code using the Contracts and Grants Reporting Code.
    Given I am logged in as a KFS Contracts & Grants Manager
    When  I create a Contract Grant Reporting Code document
    And   I submit the Contract Grant Reporting Code document
    And   the Contract Grant Reporting Code document goes to FINAL
    And   I edit the CG Reporting Code Name of the Contract Grant Reporting Code
    And   I submit the Contract Grant Reporting Code document
    And   the Contract Grant Reporting Code document goes to FINAL
    And   I am logged in as a KFS User
    And   I search for the Contract Grant Reporting Code just entered
    Then  I should only see the Contract Grant Reporting Code just entered with its revised name
    And   I am logged in as a KFS Contracts & Grants Manager
    And   I change the Contract and Grant Reporting Code on a Contract and Grant Object Code to the Contract and Grant Reporting Code just entered
    And   I submit the Object Code document
    And   the Object Code document goes to ENROUTE
    And   I route the Object Code document to final
    And   I am logged in as a KFS User
    And   I search for an Object Code using the Contract Grant Reporting Code
    Then  I should only see the Object Code document with the searched for CG Reporting Code in the object code search results


  @KFSQA-916 @CG @smoke @nightly-jobs @coral
  Scenario: Indirect Cost Recovery Rate can use wildcards as debit and credit and indirect costs post with new rates
    Given I am logged in as a KFS Contracts & Grants Manager
    And   I create a wildcarded Indirect Cost Recovery Rate of 0 percent using random institutional allowance object codes
    And   I remember the Indirect Cost Recovery Rate as the From Indirect Cost Recovery Rate
    And   I submit the Indirect Cost Recovery Rate document
    And   the Indirect Cost Recovery Rate document goes to FINAL
    And   I create a wildcarded Indirect Cost Recovery Rate of 10 percent using From Indirect Cost Rate institutional allowance object codes
    And   I remember the Indirect Cost Recovery Rate as the To Indirect Cost Recovery Rate
    And   I submit the Indirect Cost Recovery Rate document
    And   the Indirect Cost Recovery Rate document goes to FINAL
    And   I am logged in as a KFS User
    And   I remember the logged in user
    And   I find an unexpired CG Account that has an unexpired continuation account
    And   I edit the Account
    And   I edit the Indirect Cost Rate on the Account to the remembered From Indirect Cost Rate
    And   I remember the Account as the From Account
    And   I submit the Account document
    And   the Account document goes to ENROUTE
    And   I route the Account document to final
    And   I am logged in as the remembered user
    And   I find an unexpired CG Account not matching the remembered From Account that has an unexpired continuation account
    And   I edit the Account
    And   I edit the Indirect Cost Rate on the Account to the remembered To Indirect Cost Rate
    And   I remember the Account as the To Account
    And   I submit the Account document
    And   the Account document goes to ENROUTE
    And   I route the Account document to final
    And   I am logged in as the remembered user
    And   I start an empty Distribution Of Income And Expense document
    And   I add the remembered From account for a Services Object Code for amount 100
    And   I add the remembered To account for a Services Object Code for amount 100
    And   I submit the Distribution Of Income And Expense document
    And   I remember the Distribution Of Income And Expense document number
    And   the Distribution Of Income And Expense document goes to ENROUTE
    And   I route the Distribution Of Income And Expense document to final
    And   Nightly Batch Jobs run
    Then  the Indirect Cost Recovery Rates are posted correctly for the current month
