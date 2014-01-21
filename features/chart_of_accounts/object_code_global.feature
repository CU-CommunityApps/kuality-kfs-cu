Feature: Object Code Global

  [KFSQA-639] As a KFS Chart Manager, when creating an Object Code, the CG Reporting Code will validate
              against the CG Reporting Code Maintenance Table. Validated CG Reporting Codes will enable
              this document to route to processed or final. Invalid CG Reporting Codes will produce an
              error message.

  @KFSQA-639 @pending
  Scenario: Create an Object Code Global with an invalid CR Reporting Code and get an error message
    Given   I am logged in as a KFS Chart Manager
    And     I save an Object Code Global
    And     I enter an invalid CG Reporting Code of ZZZ
    When    I submit the Object Code Global document
    Then    Object Code Global should show an error that says CG Reporting Code ZZZZ for Chart Code IT does not exist.

  @KFSQA-639
  Scenario: Create an Object Code with a validated CR Reporting Code
    Given   I am logged in as a KFS Chart Manager
    And     I save the Object Code Global document
    When    I blanket approve the Object Code Global document
    Then    The Object Code Global document status should be PROCESSED
