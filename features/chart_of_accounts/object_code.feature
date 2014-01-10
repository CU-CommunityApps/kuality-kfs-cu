Feature: Object Code

  [KFSQA-594] As a KFS Chart Manager, the Object Code and Object Code Global document should route to final.

  @wip @KFSQA-594
  Scenario: Create an Object Code and Object Code Global and Blanket Approve it.

    Given   I am logged in as a KFS Chart Manager
    And      I create and Object Code
    And       I enter a valid CG Reporting Code
#    And       I enter a valid SUNY Object Code
    When   I Blanket Approve it
    Then   Then the document status is Final

    Given   I am logged in as a KFS Chart Manager
    And      I create and Object Code
    And       I enter invalid CG Reporting Code
#    And       I enter invalid SUNY Object Code
    When   I Blanket Approve it
    Then the document status is not Final or probably i should see an error message
