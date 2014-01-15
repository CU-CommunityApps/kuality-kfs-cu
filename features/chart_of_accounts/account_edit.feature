Feature: Account Edit

  [KFSQA-593] Summary: As a KFS Chart Manager, when I edit an Account with an
                       invalid Sub-Fund Program Code I should get an error message presented
                       at the top of the Accountant Maintenance Tab. Because the field is validated
                       against a maintenance table and KFS standards require it.

  @KFSQA-593 @wip
  Scenario: Edit an Account with an invalid Sub-Fund Program Code
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a Sub-Fund Group Code of PLCAPT
    When  I enter XXXX as an invalid Sub-Fund Program Code
    Then  an error in the Account Maintenance tab should say "Sub-Fund Program Code XXXX is not associated with Sub-Fund Group Code PLCAPT."

  @KFSQA-593 @wip
  Scenario: Edit an Account with an invalid Sub-Fund Program Code
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a Sub-Fund Group Code of PLCAPT
    When  I enter XXXXXXX as an invalid Major Reporting Category Code
    Then  an error in the Account Maintenance tab should say "Major Reporting Category Code (XXXXXXX) does not exist."

  @KFSQA-593 @wip
  Scenario: Edit an Account with an invalid Sub-Fund Program Code
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a Sub-Fund Group Code of PLCAPT
    When  I enter XXXXXXX as an invalid Appropriation Account Number
    Then  an error in the Account Maintenance tab should say "Appropriation Account Number XXXXXXX is not associated with Sub-Fund Group Code PLCAPT."

  @KFSQA-593 @wip
  Scenario: Edit an Account with an invalid Sub-Fund Program Code
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a Sub-Fund Group Code of PLCAPT
    When  I enter XX as an invalid Labor Benefit Rate Category Code
    Then  an error in the Account Maintenance tab should say "Invalid Labor Benefit Rate Code"
    Then  an error in the Account Maintenance tab should say "The specified Labor Benefit Rate Category Code XX does not exist."
