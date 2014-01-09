Feature: KFS Fiscal Officer Account Creation

  [KFSQA-554] Because it saves time, I as a KFS User should be able to Initiate an Account document with just the description.

  Scenario: Create an Account
    Given I am logged in as a KFS Fiscal Officer
    And   I create an Account
    When  I blanket approve the Account
    Then  the Account Maintenance Document goes to PROCESSED

  @KFSQA-554 @wip
  Scenario: KFS User Initiates an Account document with only a description field
    Given I am logged in as a KFS User
    When  I create an Account document with only the Description field populated
    Then  The document should save successfully