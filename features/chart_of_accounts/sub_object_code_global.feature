Feature: Sub Object Code Global
  [KFSQA-617] Sub-Object Global Lookup Modification, As a KFS Chart Manager, on the Sub-Object Global, I want to add multiple account lines using using Organizational Codes to be efficient

  @wip @KSFQA-617
  Scenario: Create a Sub-Object Code Global using an organization hierarchy
    Given  I am logged in as a KFS Chart Manager
    And     I create a Sub-Object Code Global
    When  I retrieve multiple account lines using Organization Code
    Then   Retrieved accounts equal all Active Accounts for Organization Code