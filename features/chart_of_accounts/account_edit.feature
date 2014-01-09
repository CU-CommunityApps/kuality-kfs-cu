Feature: Account Edit

  [KFSQA-610] Summary: As a KFS Chart Administrator I want to update an Account without getting a stack trace error.

  @wip
  @KFSQA-610
  Scenario: Edit an Account as KFS Chart Admin
    Given I am am logged in as a KFS Chart Administrator
    And   I edit an Account
    When  I blanket approve the Account
    Then  the Account Maintenance Document goes to PROCESSED