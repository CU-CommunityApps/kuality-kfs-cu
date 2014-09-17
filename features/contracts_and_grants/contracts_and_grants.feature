Feature: Contracts and Grants

  [KFSQA-901] Create and edit a Contracts and Grants Reporting Code, assign it to an Object Code,
              and search for the Object Code by using the Contracts and Grants Reporting Code.
              Default data used in this test is specified in KFS Parameter: DEFAULT_CONTRACT_GRANT_LEVEL_CODE.

  @KFSQA-901 @CG @smoke @coral
  Scenario: Create and edit Contracts and Grants Reporting Code, assign it to an Object Code, then search for the Object Code using the Contracts and Grants Reporting Code.
    Given I am logged in as a KFS Contracts & Grants Manager
    When  I create a Contract Grant Reporting Code document
    And   I submit the Contract Grant Reporting Code document
    And   the Contract Grant Reporting Code document goes to FINAL
    And   I edit the CG Reporting Code Name of the Contract Grant Reporting Code
    And   I submit the Contract Grant Reporting Code document
    And   the Contract Grant Reporting Code document goes to FINAL
    And   I am logged in as a KFS User
    And   I search for the Contract Grant Reporting Code just entered
    Then  I should only see the Contract Grant Reporting Code just entered with its revised name
    And   I am logged in as a KFS Contracts & Grants Manager
    And   I change the Contract and Grant Reporting Code on a Contract and Grant Object Code to the Contract and Grant Reporting Code just entered
    And   I submit the Object Code document
    And   the Object Code document goes to ENROUTE
    And   I route the Object Code document to final
    And   I am logged in as a KFS User
    And   I search for an Object Code using the Contract Grant Reporting Code
    Then  I should only see the Object Code document with the searched for CG Reporting Code in the object code search results
