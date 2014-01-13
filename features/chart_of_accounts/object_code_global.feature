Feature: Object Code Global

  [KFSQA-639] As a KFS Chart Manager, when creating an Object Code, the CG Reporting Code will validate against
  the CG Reporting Code Maintenance Table. Validated CG Reporting Codes will enable this document to route to processed or final.
  Invalid CG Reporting Codes will produce an error message.


  @wip @KFSQA-639
  Scenario: Create an Object Code Global with an invalid CR Reporting Code and get an error message
    Given   I am logged in as a KFS Chart Manager
    And     I create and Object Code Global
    And     I enter an invalid CG Reporting Code
    When    I Blanket Approve the document
    Then    An error should say “CG Reporting Code (ZZZ) for Chart Code (IT) does not exist.”


  @wip @KFSQA-639
  Scenario: Create an Object Code with a validated CR Reporting Code
    Given   I am logged in as a KFS Chart Manager
    And      I create and Object Code
    And      I enter a valid CG Reporting Code
    When   I Blanket Approve it
    Then   The Object Code document status should be PROCESSED
