Feature: Account Edit
  As a KFS Chart User when editing an Account I should be able to enter data into Sub Fund Program field regardless of case because custom fields should behave similarly to base fields.

  @wip
  Scenario: Account Edit Sub Fund Program case sensitive test on Submit - KFSQA-606
    Given I am logged in as a KFS Chart User
    And   I access Account Lookup
    And   I edit an Account to enter a Sub Fund Program in lower case
    When  I submit the Account
    Then  the Account Maintenance Document submits with no errors
