Feature: Advance Deposit

  [KFSQA-608] I need to be able to return to an in progress (Saved) AD after batch processes
              have run and be able to continue working on the Document because sometimes and
              AD can not be completed in one session.

  [KFSQA-608] I need to be able to Copy an existing AD and Save the new Document because this
              will allow more efficient creation of multiple documents that are similar.

  @KFSQA-608
  Scenario: AD Create Save and continue after batch processes
    Given I am logged in as a KFS User
    And   I save an AD document
    And   Nightly Batch Jobs run
    And   I am logged in as a KFS User
    And   I view the Advance Deposit document
    When  I submit the Advance Deposit document
    Then  the AD document submits with no errors

  @KFSQA-609
  Scenario: AD Copy and Save KFSQA-609
    Given   I am logged in as a KFS Cash Manager
    And     I access Document Search
    And     I search for all AD documents
    And     I copy a random Advance Deposit document with FINAL status
    When    I save the Advance Deposit document
    Then    the Advance Deposit document goes to SAVED
