Feature: Account Lookup

  [smoke]     As a KFS User I should be able to access the Account Lookup page.
  [smoke]     As a KFS User I should be able to search for an Account Number.
  [KFSQA-557] As a KFS user I want to see acct look up screen because it has custom cornell fields.
  [KFSQA-575] As a KFS Chart Administrator I want to lookup an Account without getting a stack trace error.

  @smoke @hare @solid
  Scenario: Account lookup page should appear
    Given I am logged in as a KFS User
    When  I access Account Lookup
    Then  the Account Lookup page should appear

  @KFSQA-557 @cornell @KFSMI-7617 @hare @solid
  Scenario: KFS User accesses Account Lookup and views Cornell custom fields
    Given I am logged in as a KFS User
    When  I access Account Lookup
    Then  the Account Lookup page should appear with Cornell custom fields

  @KFSQA-574 @KFSQA-575 @cornell @Bug @AcctMaint @AcctLookup @KFSPTS-1716 @hare @solid
  Scenario: Lookup an Account as a Chart Admin
    Given I am logged in as a KFS Chart Administrator
    And   I access Account Lookup
    When  I search for all accounts
    Then  Accounts should be returned

  @KFSQA-574 @KFSQA-575 @cornell @Bug @AcctMaint @AcctLookup @KFSPTS-1716 @hare @solid
  Scenario Outline: Lookup an Account using Cornell specific fields
    Given I am logged in as a KFS Chart Manager
    And   I access Account Lookup
    When  I lookup an Account with <field_name>
    Then  Accounts should be returned
  Examples:
    | field_name                        |
    | Account Manager Principal Name    |
    | Account Supervisor Principal Name |
