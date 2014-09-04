Feature: Account Close

  [KFSQA-551/KFSQA-587] As a KFS Chart Manager, the Account cannot be
                        closed with open encumbrances.

  @KFSQA-551 @KFSQA-587 @AcctClose @Bug @FP @KFSMI-6347 @nightly-jobs @tortoise
  Scenario: As a KFS Chart Manager, the Account cannot be closed with open encumbrances.
    Given I am logged in as a KFS Chart Manager
    And   I clone a random Account with name, chart code, and description changes
    Given I am logged in as a KFS Chart Administrator
    When  I blanket approve a Pre-Encumbrance Document that encumbers the random Account
    Then  the Pre-Encumbrance posts a GL Entry with one of the following statuses
      | PENDING   |
      | COMPLETED |
      | PROCESSED |
      | FINAL     |
    Given Nightly Batch Jobs run
    And   I am logged in as a KFS Chart Manager
    When  I close the Account
    And   I submit the Account document
    Then  I should get an error saying "This Account cannot be closed because it has an open Encumbrance."