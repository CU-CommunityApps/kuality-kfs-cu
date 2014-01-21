Feature: Sub Account

  [KFSQA-590] As a KFS Chart Manager I want to enter a Sub-Account
              without a null ICR ID field because this is incorrect

  [KFSQA-591] As a KFS CG Processor Role I want to Approve Sub-Account Documents with
              Sub-Account Type “CS” because this follows Cornell standard operating policies.

  @KFSQA-590
  Scenario: Verify “null” does not display in the ICR ID field when I create a Sub-Account
    Given I am logged in as a KFS Chart Manager
    And   I create a Sub-Account
    When  I tab away from the Account Number field
    Then  The Indirect Cost Rate ID field should not be null

  @KFSQA-591 @wip
  Scenario: Create a Sub-Account with Sub-Account Type CS and verity routing to CG Processor.
    Given   I am logged in as a KFS User
    And     I Create a Sub-Account with Sub-Account Type CS
    And     I submit the Sub-Account
    And     I am logged in as the FO of the Account
    And     The Sub-Account document should be in my action list
    And     I approve the document
#    When    I am logged in as a Contract and Grant Processor
#    And     The Sub-Account document should be in my action list
    Then    the Sub-Account document goes to FINAL