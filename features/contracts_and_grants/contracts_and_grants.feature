Feature: Contracts and Grants

  [KFSQA-916] Background : Indirect Cost Recovery Rate can use wildcards as debit and credit and indirect costs post with new rates.

  @KFSQA-916 @CG @smoke @nightly-jobs @wip
  Scenario: Indirect Cost Recovery Rate can use wildcards as debit and credit and indirect costs post with new rates
    Given I log in as Contracts and Grants Manager (jis45)
    And Create Indirect Cost Recovery Rate
    And I submit the ICR document
    And the IRC document goes to FINAL
    And Create Indirect Cost Recovery Rate
    And I submit the ICR document
    And the IRC document goes to FINAL
    And I log in as FP Doc blanket approver (dh273)
    And Lookup and edit a FROM account
    And Blanket approve to final
    And Lookup and edit a To account
    And Blanket approve to final These steps are part of the DI scenario
    When I create a Distribution of Income and Expense Doc
    And use the FROM account from above
    And use the TO account from above
    And Blanket Approve to Final
    And I login with ability to run batch jobs (srb55?)
    And run nightly batch jobs
    Then ICR rates are posted correctly for current month