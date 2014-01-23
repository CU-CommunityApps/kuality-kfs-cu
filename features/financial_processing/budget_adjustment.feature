Feature: KFS Fiscal Officer Account Copy

  [KFSQA-623] CF: Budget Adjustment eDoc to balance entries by Account. As a KFS User I want to create a Budget Adjustment but preclude entries from crossing Accounts because of Cornell budget policies.

  @wip @KFSQA-623
  Scenario: Budget Adjustment not allowed to cross Account Sub-Fund Group Codes
    Given   I am logged in as a KFS User
    And     I create a Budget Adjustment document
    And     I add a from amount of 100.00 for account 1258322 with object code 4480
    And     I add a to amount of 100 for account 1258323 with object code 4480
    When    I submit the Budget Adjustment document
    Then    budget adjustment should show an error that says "The Budget Adjustment document is not balanced within the account."
