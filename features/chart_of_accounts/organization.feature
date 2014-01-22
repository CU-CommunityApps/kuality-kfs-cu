Feature: Organization

  [KFSQA-581] As a KFS Chart Administrator I want to copy an Organization without getting an error.

  @KFSQA-581
  Scenario: Unselecting actives indicator on a new copy of an existing Organization should go to final.
    Given I am logged in as a KFS Chart Administrator
    And   I copy an Organization
    And   I make the Organization inactive
    When  I blanket approve the Organization document
    Then  the Organization Maintenance Document goes to PROCESSED
