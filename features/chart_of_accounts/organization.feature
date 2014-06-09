Feature: Organization

  [KFSQA-581] As a KFS Chart Administrator I want to copy an Organization without getting an error.

  [KFSQA-582] As a KFS Chart Manager I want to be able to inactivate an Organization Code when all Accounts
              associated to it are closed because this conforms to a policy at Cornell.

  @KFSQA-581 @Bug @COA @OrgCreate @KFSMI-9368 @nightly-jobs @sloth
  Scenario: Unselecting actives indicator on a new copy of an existing Organization should go to final.
    Given I am logged in as a KFS Chart Administrator
    And   I copy an Organization
    And   I make the Organization inactive
    When  I blanket approve the Organization document
    And   Nightly Batch Jobs run
    And   I am logged in as a KFS Chart Administrator
    And   I view the Organization document
    Then  the Organization document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |

  @KFSQA-582 @Bug @OrgMaint @KFSMI-7755 @nightly-jobs @sloth
  Scenario: Inactivate an Organization Code having all closed accounts.
    Given I am logged in as a KFS Chart Manager
    And   I inactivate an Organization Code with closed accounts
    And   Nightly Batch Jobs run
    And   I am logged in as a KFS Chart Manager
    When  I view the Organization document
    Then  the Organization document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |
