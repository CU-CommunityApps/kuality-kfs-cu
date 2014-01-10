Feature: Sub Account

  [KFSQA-590] As a KFS Chart Manager I want to enter a Sub-Account
              without a null ICR ID field because this is incorrect

  @KFSQA-590 @wip
  Scenario: Verify “null” does not display in the ICR ID field when I create a Sub-Account
    Given   I am logged in as a KFS Chart Manager
    And     I create a Sub-Account
    When    I tab away from the Account Number field
    Then    The Indirect Cost Rate ID field should not be null
