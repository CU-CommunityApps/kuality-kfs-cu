Feature: Account Delegate Create

  [KFSQA-602] As a KFS Chart Manager I want to add multiple account lines to the Account Delegate Global using
              Organizational Codes because this will save me time

  @KFSQA-602 @wip
  Scenario: Create an Account Delegate Global using an organization hierarchy
    Given   I am logged in as a KFS Chart Manager
    And     I create an Account Delegate Global with multiple account lines
    When    I submit the Account Delegate Global document
    Then    the Account Delegate Global document goes to FINAL