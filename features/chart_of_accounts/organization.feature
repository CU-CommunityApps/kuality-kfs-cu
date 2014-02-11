Feature: Organization

  [KFSQA-581] As a KFS Chart Administrator I want to copy an Organization without getting an error.

  [KFSQA-582] As a KFS Chart Manager I want to be able to inactivate an Organization Code when all Accounts
              associated to it are closed because this conforms to a policy at Cornell.

  @KFSQA-581
  Scenario: Unselecting actives indicator on a new copy of an existing Organization should go to final.
    Given I am logged in as a KFS Chart Administrator
    And   I copy an Organization
    And   I make the Organization inactive
    When  I blanket approve the Organization document
    And   Nightly Batch Jobs run
    Then  the Organization document goes to PROCESSED

  @KFSQA-582
  Scenario: Inactivate an Organization Code having all closed accounts.
    Given I am logged in as a KFS Chart Manager
    When  I inactivate an Organization Code with closed accounts
    And   Nightly Batch Jobs run
    Then  the Organization document goes to PROCESSED
