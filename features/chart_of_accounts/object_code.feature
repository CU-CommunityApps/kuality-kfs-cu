Feature: Object Code

  [KFSQA-594] As a KFS Chart Manager, when creating an Object Code, the CG Reporting Code will validate against
  the CG Reporting Code Maintenance Table. Validated CG Reporting Codes will enable this document to route to processed or final.
  Invalid CG Reporting Codes will produce an error message.
  [KFSQA-580] Bug: Object Code Global dropping values of Reports To Object Code. As a KFS Chart Manager I want to enter an Object Code Global and know it will update the Reports to Object Code with my input because this will eliminate subsequent manual rework.


  @KFSQA-594
  Scenario: Create an Object Code and Object Code and Blanket Approve it.
    Given   I am logged in as a KFS Chart Manager
    And     I create an Object Code document
    When    I Blanket Approve the document
    Then    I should see the Object Code document in the object code search results

  @KFSQA-594
  Scenario: Create an Object Code with an invalid CR Reporting Code and get an error message
    Given   I am logged in as a KFS Chart Manager
    And     I edit an Object Code document with object code 6500
    And     I enter invalid CG Reporting Code of ZZZZ
    When    I Blanket Approve the document
    Then    The object code should show an error that says "CG Reporting Code (ZZZZ) for Chart Code (CS) does not exist."

  @wip @KFSQA-580
  Scenario: Verify Object Code updates Reports to Object Code
    Given  I am logged in as a KFS Chart Manager
    And     I edit an Object Code document with object code 1111
    And     I enter a valid Reports to Object Code
    And     I Submit the Object Code document
    When    I Lookup the Object Code 1111
    Then    The Lookup should display the Reports to Object Code