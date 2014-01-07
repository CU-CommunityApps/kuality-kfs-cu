Feature: Account Close

  Closing Accounts should be subject to certain constraints.

  @wip
  Scenario: As a KFS Chart Manager, the Account cannot be closed with open encumbrances. KFSQA-587
    Given I am logged in as a KFS Chart Manager
    And   I clone a random Account with the following changes:
      | Name        | Test Account             |
      | Chart Code  | IT                       |
      | Description | [KFSQA-587] Test Account |
      | Number      | 1KQA587                  |
    Given I am logged in as a KFS User
    When  I blanket approve a Pre-Encumbrance Document for Account number "1KQA587"
    Then  the Pre-Encumbrance posts either as a pending or completed GL entry
    Given I am logged in as a KFS Chart Manager
    When  I close the Account
    Then  I get an error