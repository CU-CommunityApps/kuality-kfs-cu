Feature: Contracts and Grants

  [KFSQA-901] Background :

  @KFSQA-901 @CG @smoke @wip
  Scenario: Create and edit a Contracts and Grants reporting code, assign to an object code and search for the Object Code by using the Contracts and Grants reporting code.
    Given I login as a Contracts & Grants Manager
    When  I create a CG reporting code document
    And   I submit the Contract Grant Reporting code document
    And   the Contract Grant Reporting code document goes to FINAL
    And   I edit above CG reporting code document
    And   I submit the Contract Grant Reporting code document
    And   the Contract Grant Reporting code document goes to FINAL
    And   I edit a Contract and Grants Object code with above CG reporting code
    And   I submit the Object Code document
    And   the Object Code document goes to FINAL
    Then  I login as a KFS User
    And   I search and find above Object Code using CG reporting code

