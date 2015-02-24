Feature: Sub Account

  [KFSQA-590] As a KFS Chart Manager I want to enter a Sub-Account
              without a null ICR ID field because this is incorrect

  [KFSQA-589] Cornell Feature: Sub-Account blanket approval does not work for jis45; only works for Superusers.
              As a Contracts & Grants Processor I want to Blanket Approve CS Type Sub-Account Documents that
              have been ad-hoc routed to me because this follows Cornell standard operating policies.

  [KFSQA-591] As a KFS CG Processor Role I want to Approve Sub-Account Documents with
              Sub-Account Type “CS” because this follows Cornell standard operating policies.

  [KFSQA-905] Route Sub-Account with type CS to CG responsibility


  @KFSQA-590 @SubAcct @Bug @KFSMI-7964 @hare @solid
  Scenario: Verify "null" does not display in the ICR ID field when I create a Sub-Account
    Given I am logged in as a KFS Chart Manager
    And   I save a Sub-Account document
    When  I tab away from the Account Number field
    Then  The Indirect Cost Rate ID field should not be null

  @KFSQA-591 @cornell @smoke @SubAcct @KFSPTS-1740 @hare @solid
  Scenario: Create a Sub-Account with the default Sub-Account Type Code and verity routing to CG Processor.
    Given   I am logged in as a KFS User
    And     I create a Sub-Account with a Cost Share Sub-Account Type Code
    And     I submit the Sub-Account document
    And     I am logged in as the FO of the Sub-Account
    And     The Sub-Account document should be in my action list
    And     I view the Sub-Account document
    And     I approve the Sub-Account document
    Then    the Sub-Account document goes to ENROUTE
    And     I verify that the following Pending Action approvals are requested:
      | Contracts & Grants Processor |
    Given   I switch to the user with the next Pending Action in the Route Log for the Sub-Account document
    And     I view the Sub-Account document
    When    I approve the Sub-Account document
    Then    the Sub-Account document goes to FINAL

  @KFSQA-589 @cornell @SubAcct @Bug @KFSPTS-1753 @sloth @solid
  Scenario: Create a Sub-Account with Sub-Account Type CS and ad-hoc approval route it to a member of the Contracts & Grants Processor Role (jis45)
    Given I am logged in as a KFS User
    And   I submit a Cost Share Sub-Account with an adhoc approver
    And   the Sub-Account document goes to ENROUTE
    When  I am logged in as the adhoc user
    Then  The Sub-Account document should be in my action list
    When  I view the Sub-Account document
    And   I blanket approve the Sub-Account document
    And   I view the Sub-Account document
    Then  the Sub-Account document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |

  @KFSQA-905 @COA, @SubAcct @CG @smoke @coral @solid
  Scenario: Route Sub-Account with type CS to Contracts & Grants responsibility
    Given I am logged in as a KFS User who is not a Contracts & Grants Processor
    And   I remember the logged in user
    And   I create a Sub-Account using a CG account with a CG Account Responsibility ID in range 1 to 8
    And   I submit the Sub-Account document
    And   the Sub-Account document goes to ENROUTE
    And   I route the Sub-Account document to final
    And   I am logged in as the remembered user
    #the next step is needed to populate the Indirect Cost Recovery Accounts array which does not have data until after submit
    And   I display the Sub-Account document
    And   I lookup the Sub-Account I want to edit
    And   I edit the Sub-Account changing its type code to Cost Share
    And   I edit the current Indirect Cost Recovery Account on the Sub-Account to a Contract College General Appropriated Account
    And   I submit the Sub-Account document
    Then  the Sub-Account document routes to the Award node
