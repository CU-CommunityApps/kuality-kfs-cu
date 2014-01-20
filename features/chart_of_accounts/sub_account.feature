Feature: Sub Account

  [KFSQA-590] As a KFS Chart Manager I want to enter a Sub-Account
              without a null ICR ID field because this is incorrect
  [KFSQA-589] Cornell Feature: -SubA-ccount blanket approval does not work for jis45; only works for Superusers.
  As a Contracts & Grants Processor I want to Blanket Approve CS Type Sub-Account Documents that have been ad-hoc routed
  to me because this follows Cornell standard operating policies.

  @KFSQA-590
  Scenario: Verify “null” does not display in the ICR ID field when I create a Sub-Account
    Given I am logged in as a KFS Chart Manager
    And   I create a Sub-Account
    When  I tab away from the Account Number field
    Then  The Indirect Cost Rate ID field should not be null

  @wip @KFSQA-589
  Scenario: Create a Sub-Account with Sub-Account Type CS and ad-hoc approval route it to a member of the Contracts & Grants Processor Role (jis45)
    Given    I am logged in as "rlc56"
    And     I create a Sub-Account for 589
    And     I enter Sub-Account Type CS
    And     I enter an Adhoc Approver
    And     I submit the Sub-Account Document
    And     The Sub Account document will become SAVED
    And     I am logged in as a KFS Contracts & Grants Processor
    When  The Sub-Account Document is in my Action List
    Then   I can Blanket Approve the Sub-Account Document
    #KFS USE rlc56
#  chart account IT 1258321
#  Sub Account Number - Make up a number, any unused number
#  Cost Shart Chart - IT
#  Cost Share Account Number - 1254601
#  Ad Hoc Routing - jis45

