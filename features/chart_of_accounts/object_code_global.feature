Feature: Object Code Global

  [KFSQA-580] Object Code Global is dropping values of Reports To Object Code. As a KFS Chart Manager I want to
              enter an Object Code Global and know it will update the Reports to Object Code with my input
              because this will eliminate subsequent manual rework.
  [KFSQA-639] As a KFS Contract & Grants Manager, attempt to perform global object code maintenance using
              a blank CG Reporting Code getting the appropriate error message, using an invalid CG Reporting
              Code getting the appropriate error message, and using a valid CG Reporting Code having the
              document route to final.


  @KFSQA-580 @Bug @ObjCode @KFSPTS-915 @sloth @solid
  Scenario: Verify adding a new Object Code retains Reports to Object Code
    Given I am logged in as a KFS Contracts & Grants Manager
    And   I create an Object Code Global document with a valid Reports to Object Code
    When  I submit the Object Code Global document
    Then  the document should have no errors
    And   the Object Code Global document goes to ENROUTE
    And   I route the Object Code Global document to final
    And   the Object Code Global document goes to FINAL
    When  I lookup the Object Code just entered with Object Code Global document
    Then  the Reports to Object Code just entered on the Object Code Global document should be displayed


  @KFSQA-580 @Bug @ObjCode @KFSPTS-915 @sloth @solid
  Scenario: Verify editing an existing Object Code retains and updates Reports to Object Code
    Given I am logged in as a KFS Contracts & Grants Manager
    And   I start an Object Code Global document using an existing Object Code
    And   on the Object Code Global document, I update the Reports to Object Code
    When  I submit the Object Code Global document
    Then  the document should have no errors
    And   the Object Code Global document goes to ENROUTE
    And   I route the Object Code Global document to final
    And   the Object Code Global document goes to FINAL
    When  I lookup the Object Code just entered with Object Code Global document
    Then  the Reports to Object Code just entered on the Object Code Global document should be displayed


  @KFSQA-639 @CG @ObjectCode @solid
  Scenario: Perform Object Code Global maintenance with blank and bad CG Reporting Code getting errors
            finally having document process correctly with valid CG Reporting Code.
    Given I am logged in as a KFS Contracts & Grants Manager
    And   I create an Object Code Global document with a blank CG Reporting Code
    When  I submit the Object Code Global document
    Then  I should get an error saying "CG Reporting Code (CG Rptg Code) is a required field."
    #Invalid value used in next step is part of later step's error message, therefore hardcoded for clarity
    And   I enter the invalid CG Reporting Code of ZZZZ on the Object Code Global document
    When  I submit the Object Code Global document
    Then  I should get an error saying "CG Reporting Code (ZZZZ) for Chart Code (IT) does not exist."
    And   I enter a valid CG Reporting Code on the Object Code Global document
    When  I submit the Object Code Global document
    Then  the document should have no errors
    And   the Object Code Global document goes to ENROUTE
    And   I route the Object Code Global document to final
    Then  the Object Code Global document goes to FINAL
