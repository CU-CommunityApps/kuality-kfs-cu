Feature: Object Code

  [KFSQA-594] As a KFS Chart Manager, when creating an Object Code, the CG Reporting Code will validate against
  the CG Reporting Code Maintenance Table. Validated CG Reporting Codes will enable this document to route to processed or final.
  Invalid CG Reporting Codes will produce an error message.

  @KFSQA-594
  Scenario: Create an Object Code and Object Code and Blanket Approve it.
    Given   I am logged in as a KFS Chart Manager
    And     I create an Object Code document
    When    I Blanket Approve the Object Code document
    Then    I should see the Object Code document in the object code search results

  @KFSQA-594
  Scenario: Create an Object Code with an invalid CR Reporting Code and get an error message
    Given   I am logged in as a KFS Chart Manager
    And     I edit an Object Code document with object code 6500
    And     I enter invalid CG Reporting Code of ZZZZ
    When    I Blanket Approve the Object Code document
    Then    The object code should show an error that says "CG Reporting Code (ZZZZ) for Chart Code (CS) does not exist."
