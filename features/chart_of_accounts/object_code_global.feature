Feature: Object Code Global

  [KFSQA-639] As a KFS Chart Manager, when creating an Object Code, the CG Reporting Code will validate
              against the CG Reporting Code Maintenance Table. Validated CG Reporting Codes will enable
              this document to route to processed or final. Invalid CG Reporting Codes will produce an
              error message.

  @KFSQA-639 @CG @ObjectCode @test-highlights-bug @hare
  Scenario: Create an Object Code Global with an invalid CR Reporting Code and get an error message
    Given I am logged in as a KFS Chart Manager
    And   I save an Object Code Global document
    And   I enter an invalid CG Reporting Code of ZZZZ
    When  I submit the Object Code Global document
    Then  I should get an error saying "CG Reporting Code ZZZZ for Chart Code IT does not exist."

  @KFSQA-639 @CG @ObjectCode @hare
  Scenario: Create an Object Code with a validated CR Reporting Code
    Given I am logged in as a KFS Chart Manager
    And   I save an Object Code Global document
    When  I blanket approve the Object Code Global document
    And   I view the Object Code Global document
    Then  the Object Code Global document goes to FINAL
