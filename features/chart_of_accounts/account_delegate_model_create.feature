Feature: Account Delegate Model Create

  @KFSQA-573 @wip
  Scenario: Create an Account Global Model eDoc with an Invalid Organization Code
    Given I am logged in as a KFS Chart Manager
    When  I create an Account Delegate Model with an invalid Organization Code
    Then  an error should say "The specified Organization Code does not exist."
