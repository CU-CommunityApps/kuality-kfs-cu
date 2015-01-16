Feature: Account Delegate Model Create

  @KFSQA-573 @AcctDelegate @KFSPTS-991 @sloth @solid
  Scenario: Create an Account Global Model eDoc with an Invalid Organization Code
    Given I am logged in as a KFS Chart Manager
    When  I submit an Account Delegate Model document with an invalid Organization Code
    Then  I should get an error saying "The specified Organization Code does not exist."
