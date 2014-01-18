Feature: Account Edit

  [KFSQA-593] Summary: As a KFS Chart Manager, when I edit an Account with an
                       invalid Sub-Fund Program Code I should get an error message presented
                       at the top of the Accountant Maintenance Tab. Because the field is validated
                       against a maintenance table and KFS standards require it.

  [KFSQA-610] Summary: As a KFS Chart Administrator I want to update an Account without getting a stack trace error.

  [KFSQA-632] As a KFS Fiscal Officer I need to edit an account using the Major Reporting Category Code field and enter
              a lowercase value and have it convert to UPPERCASE because I need to manage in-year financial activity,
              fund balances and year-end reporting.

  [KFSQA-586] Summary: As a KFS Chart Manager, the Account Number and the Continuation Account on that account cannot
                       and should not ever be the equal as this defeats the purpose of a continuation account.

  @KFSQA-593
  Scenario: Edit an Account with an invalid Sub-Fund Program Code
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a Sub-Fund Group Code of PLCAPT
    When  I enter a Sub-Fund Program Code of XXXX
    Then  an error in the Account Maintenance tab should say "Sub-Fund Program Code XXXX is not associated with Sub-Fund Group Code PLCAPT."

  @KFSQA-593
  Scenario: Edit an Account with an invalid Sub-Fund Program Code
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a Sub-Fund Group Code of PLCAPT
    When  I enter XXXXXXX as an invalid Major Reporting Category Code
    Then  an error in the Account Maintenance tab should say "Major Reporting Category Code (XXXXXXX) does not exist."

  @KFSQA-593
  Scenario: Edit an Account with an invalid Sub-Fund Program Code
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a Sub-Fund Group Code of PLCAPT
    When  I enter XXXXXXX as an invalid Appropriation Account Number
    Then  an error in the Account Maintenance tab should say "Appropriation Account Number XXXXXXX is not associated with Sub-Fund Group Code PLCAPT."

  @KFSQA-593
  Scenario: Edit an Account with an invalid Sub-Fund Program Code
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a Sub-Fund Group Code of PLCAPT
    When  I enter XX as an invalid Labor Benefit Rate Category Code
    Then  an error in the Account Maintenance tab should say "Invalid Labor Benefit Rate Code"
    Then  an error in the Account Maintenance tab should say "The specified Labor Benefit Rate Category Code XX does not exist."

  @KFSQA-610
  Scenario: Edit an Account as KFS Chart Admin
    Given I am am logged in as a KFS Chart Administrator
    And   I edit an Account
    When  I blanket approve the Account
    Then  the Account Maintenance Document goes to PROCESSED

  @KFSQA-632
  Scenario: KFS Chart Manager edits an Account with Major Reporting Category Code
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account
    When  I input a lowercase Major Reporting Category Code value
    When  I blanket approve the Account
    Then  the Account Maintenance Document goes to PROCESSED
    Then  the Account Maintenance Document goes to PROCESSED

  @KFSQA-619
  Scenario: Create an Account that matches Sub-Fund Group Code and Sub-Fund Program Code with an Appropriation Account Number
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account
    And   I enter Sub Fund Group Code of INFHFO
    And   I enter Sub Fund Program Code of CENTER
    And   I enter Appropriation Account Number of LTIP
    When  I blanket approve the Account
    Then  the Account Maintenance Document goes to PROCESSED

  @KFSQA-619
  Scenario: Create an Account that does not match Sub-Fund Group Code and Sub-Fund Program Code with an Appropriation Account Number
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account
    And   I enter Sub Fund Group Code of INFHFO
    And   I enter Sub Fund Program Code of CENTER
    And   I enter Appropriation Account Number of C771503
    When  I submit the Account
    Then  an error in the Account Maintenance tab should say "Appropriation Account Number C771503 is not associated with Sub-Fund Group Code INFHFO."

  @KFSQA-586 @wip
  Scenario: Try to continue an Account to itself
    Given   I am logged in as a KFS Chart Manager
    And     I copy an Account
    And     I blanket approve the Account
    And     I edit the Account
    And     I close the Account
    And     I enter a Continuation Account Number that equals the Account Number
    And     I enter a Continuation Chart Of Accounts Code that equals the Chart of Account Code
    When    I blanket approve the Account
    Then    an empty error should appear