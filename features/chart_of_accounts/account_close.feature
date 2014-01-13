Feature: Account Close

  [KFSQA-551/KFSQA-587] As a KFS Chart Manager, the Account cannot be closed with open encumbrances.

  @KFSQA-551 @KFSQA-587 @wip
  Scenario: As a KFS Chart Manager, the Account cannot be closed with open encumbrances.
    Given I am logged in as a KFS Chart Manager
    And   I clone a random Account with the following changes:
      | Name        | Test Account             |
      | Chart Code  | IT                       |
      | Description | [KFSQA-551] Test Account |
      | Number      | 1KQA587                  |
    Given I am logged in as a KFS User
    When  I blanket approve a Pre-Encumbrance Document for Account number "1KQA587"
    Then  the Pre-Encumbrance posts a GL Entry with one of the following statuses
      | PENDING   |
      | COMPLETED |
    Given I am logged in as a KFS Chart Manager
    When  I close the Account
    Then  The document should have no errors