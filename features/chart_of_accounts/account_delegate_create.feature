Feature: Account Delegate Create

  As a KFS User I want the Account Delegate dollar limits to not auto-populate because I want to be sure I enter them myself.

  Scenario: Create an Account Delegate KFSQA-567
    Given I am logged in as a KFS Fiscal Officer
    When  I create an Account Delegate
    Then  the Approval From This Amount and Approval To This Amount fields should be blank
