Feature: KFS Fiscal Officer Account Creation

  As a KFS Fiscal Officer I want to create an Account
  because I want to support a new project

  [KFSQA-606] As a KFS Chart User when creating an Account I should be able
              to enter data into Sub Fund Program field regardless of case
              because custom fields should behave similarly to base fields.


  Scenario: Create an Account
    Given I am logged in as a KFS Fiscal Officer
    And   I create an Account
    When  I blanket approve the Account
    Then  the Account Maintenance Document goes to PROCESSED

  Scenario: Account Edit Sub Fund Program case sensitive test on Submit - KFSQA-606
    Given I am logged in as a KFS Chart User
    When  I create an Account with a lower case Sub Fund Program
    Then  the Account Maintenance Document goes to SAVED