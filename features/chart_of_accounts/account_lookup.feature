Feature: Account Lookup

  [smoke]     As a KFS User I should be able to access the Account Lookup page.
  [smoke]     As a KFS User I should be able to search for an Account Number.
  [KFSQA-557] As a KFS user I want to see acct look up screen because it has custom cornell fields.

  @smoke
  Scenario:
    Given I am logged in as a KFS User
    When I access Account Lookup
    Then the Account Lookup page should appear

  @smoke @pending
  Scenario:
    Given I am logged in as a KFS User
    Given I access Account Lookup
    When I enter an Account Number and search
    Then The Account is found

  @KFSQA-557 @wip
  Scenario: KFS User accesses Account Lookup and views Cornell custom fields
    Given   I am logged in as a KFS User
    When    I access Account Lookup
    Then    the Account Lookup page should appear with Cornell custom fields