Feature: Sub Object Code Global

  [KFSQA-617] Sub-Object Global Lookup Modification, As a KFS Chart Manager, on
              the Sub-Object Global, I want to add multiple account lines using
              Organizational Codes to be efficient.

  @KSFQA-617 @cornell @AcctLookup @KITI-2953 @sloth @solid
  Scenario: Create a Sub-Object Code Global using an organization hierarchy
    Given I am logged in as a KFS Chart Manager
    And   I start an empty Sub-Object Code Global document
    When  I add multiple account lines to the Sub Object Code Global document using an Organization Code
    Then  retrieved accounts equal all Active Accounts for the Organization Code
