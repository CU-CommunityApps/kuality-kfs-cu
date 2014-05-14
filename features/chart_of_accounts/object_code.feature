Feature: Object Code

  [KFSQA-594] As a KFS Chart Manager, when creating an Object Code, the CG Reporting Code will validate against
              the CG Reporting Code Maintenance Table. Validated CG Reporting Codes will enable this document
              to route to processed or final. Invalid CG Reporting Codes will produce an error message.
  [KFSQA-580] Object Code Global dropping values of Reports To Object Code. As a KFS Chart Manager I want to
              enter an Object Code Global and know it will update the Reports to Object Code with my input
              because this will eliminate subsequent manual rework.

  @KFSQA-594 @hare
  Scenario: Create an Object Code and Object Code Global and Blanket Approve it.
    Given   I am logged in as a KFS Chart Manager
    And     I save an Object Code document
    When    I blanket approve the Object Code document
    Then    I should see the Object Code document in the object code search results

  @KFSQA-594 @hare
  Scenario: Create an Object Code with an invalid CR Reporting Code and get an error message
    Given   I am logged in as a KFS Chart Manager
    And     I edit an Object Code document with object code 6500
    And     I enter invalid CG Reporting Code of ZZZZ
    When    I blanket approve the Object Code document
    Then    The object code should show an error that says "CG Reporting Code (ZZZZ) for Chart Code (IT) does not exist."

  @KFSQA-580 @sloth
  Scenario: Verify Object Code updates Reports to Object Code
    Given   I am logged in as a KFS Chart Manager
    And     I edit an Object Code document with object code 1110
    And     I enter a valid Reports to Object Code
    And     I submit the Object Code document
    When    I Lookup the Object Code 1110
    Then    The Lookup should display the Reports to Object Code

  @KFSQA-596 @hare
  Scenario: Edit an Object Code and update the Financial Object Code Description
    Given   I am logged in as a KFS Chart Manager
    And     I edit an Object Code document
    And     I update the Financial Object Code Description
    When    I blanket approve the Object Code document
    Then    the document should have no errors
