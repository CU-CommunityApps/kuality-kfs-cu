Feature: KFS Fiscal Officer Account Creation

  [smoke]     As a KFS Fiscal Officer I want to create an Account
              because I want to support a new project
  [KFSQA-554] Because it saves time, I as a KFS User should be able to 
              initiate an Account document with just the description.
  [KFSQA-606] As a KFS Chart User when creating an Account I should be able
              to enter data into Sub Fund Program field regardless of case
              because custom fields should behave similarly to base fields.
  
  @smoke @pending
  Scenario: Create an Account
    Given I am logged in as a KFS Fiscal Officer
    When  I blanket approve an Account document
    Then  the Account Maintenance Document goes to PROCESSED

  @KFSQA-554
  Scenario: KFS User Initiates an Account document with only a description field
    Given I am logged in as a KFS User
    When  I save an Account document with only the Description field populated
    Then  The document should save successfully
    
  @KFSQA-606
  Scenario: Account Edit Sub Fund Program case sensitive test on Submit
    Given I am logged in as a KFS Chart User
    When  I save an Account with a lower case Sub Fund Program
    Then  the Account Maintenance Document goes to SAVED
