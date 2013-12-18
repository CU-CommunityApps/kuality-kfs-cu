Feature: KFS Fiscal Officer Account Creation

  As a KFS Fiscal Officer I want to create an Account
  because I want to support a new project

  Scenario: Create an Account
    Given I am logged in as a KFS Fiscal Officer
    And   I create an Account
    When  I blanket approve the Account
    Then  the Account Maintenance Document goes to PROCESSED