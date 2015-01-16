Feature: Account Delegate Create

  [KFSQA-567] As a KFS User I want the Account Delegate dollar limits to not auto-populate because I want to be sure I enter them myself.

  @KFSQA-567 @AcctDelegate @KFSPTS-827 @hare @solid
  Scenario: Create an Account Delegate
    Given I am logged in as a KFS Fiscal Officer
    When  I save an Account Delegate document
    Then  the Approval From This Amount and Approval To This Amount fields should be blank
