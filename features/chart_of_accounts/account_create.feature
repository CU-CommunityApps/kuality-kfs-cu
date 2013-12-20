Feature: KFS Fiscal Officer Account Creation

  As a KFS Fiscal Officer I want to create an Account
  because I want to support a new project

  Scenario: Create an Account
    Given I am logged in as a KFS Fiscal Officer
    And   I create an Account
    When  I blanket approve the Account
    Then  the Account Maintenance Document goes to PROCESSED

  @wip
  Scenario: KFS User Initiates an Account document with only a description field KFSQA-554
    Given I am logged in as a KFS User
    When  I Create an Account document with only the Description field populated
    Then  The document should save successfully