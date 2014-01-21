Feature: Advance Deposit

  [KFSQA-608] I need to be able to return to an in progress (Saved) AD after batch processes
              have run and be able to continue working on the Document because sometimes and
              AD can not be completed in one session.

  @KFSQA-608 @wip
  Scenario: AD Create Save and continue after batch processes
    Given I am logged in as a KFS User
    And   I create an AD document
    And   Nightly Batch Jobs run
    And   I am logged in as a KFS User
    When  I submit the AD document
    Then  the AD document submits with no errors
