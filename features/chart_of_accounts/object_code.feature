Feature: Object Code

  [KFSQA-594] As a KFS Chart Manager, when creating an Object Code, the CG Reporting Code will validate against
              the CG Reporting Code Maintenance Table. Validated CG Reporting Codes will enable this document
              to route to processed or final. Invalid CG Reporting Codes will produce an error message.
  [KFSQA-596] Create a new Object Code, add the new field, bad value, submit, verify incorrect value produces
              error, enter new field correct, submit and verify it is populated

  @KFSQA-594 @cornell @ObjCode @KFSPTS-931 @hare @solid
  Scenario: Create an Object Code and Object Code Global and Blanket Approve it.
    Given   I am logged in as a KFS Chart Manager
    And     I save an Object Code document
    When    I blanket approve the Object Code document
    Then    I should see the Object Code document in the object code search results

  @KFSQA-594 @cornell @ObjCode @KFSPTS-931 @hare @solid
  Scenario: Create an Object Code with an invalid CR Reporting Code and get an error message
    Given   I am logged in as a KFS Chart Manager
    And     I edit an Object Code document with object code 6500
    And     I enter invalid CG Reporting Code of ZZZZ
    When    I blanket approve the Object Code document
    Then    The object code should show an error that says "CG Reporting Code (ZZZZ) for Chart Code (IT) does not exist."

  @KFSQA-596 @cornell @COA @ObjCode @KFSPTS-1753 @hare @solid
  Scenario: Edit an Object Code and update the Financial Object Code Description
    Given   I am logged in as a KFS Chart Manager
    And     I edit an Object Code document
    And     I update the Financial Object Code Description
    When    I blanket approve the Object Code document
    Then    the document should have no errors
