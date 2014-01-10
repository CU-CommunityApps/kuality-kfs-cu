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
    Then  an error in the Account Maintenance tab should say Sub-Fund Program Code XXXX is not associated with Sub-Fund Group Code PLCAPT.
