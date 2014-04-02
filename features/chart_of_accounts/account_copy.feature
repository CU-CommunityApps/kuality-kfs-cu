Feature: KFS Fiscal Officer Account Copy

  [smoke] As a KFS Fiscal Officer I want to copy an Account
          because I want quickly create many accounts.

  @smoke @hare @wip
  Scenario: Copy an Account
    Given I am logged in as a KFS Fiscal Officer
    And   I access Account Lookup
    And   I search for all accounts
    And   I copy an Account
    Then  the Account Maintenance Document saves with no errors
