Feature: Advance Deposit

  [KFSQA-608] I need to be able to return to an in progress (Saved) AD after batch processes
              have run and be able to continue working on the Document because sometimes and
              AD can not be completed in one session.

  [KFSQA-609] I need to be able to Copy an existing AD and Save the new Document because this
              will allow more efficient creation of multiple documents that are similar.

  [KFSQA-645] Strange Display on when AD is created.

  [KFSQA-728] As a KFS User I should be able to Copy a Final AD.

  @KFSQA-608 @nightly-jobs @sloth
  Scenario: AD Create Save and continue after batch processes
    Given I am logged in as a KFS User
    And   I save an Advance Deposit document
    And   Nightly Batch Jobs run
    And   I am logged in as a KFS User
    And   I view the Advance Deposit document
    When  I submit the Advance Deposit document
    Then  the Advance Deposit document goes to FINAL

  @KFSQA-609 @DVCreate @KFSPTS-1632 @KFSUPGRADE-140 @sloth
  Scenario: AD Copy and Save
    Given I am logged in as a KFS Cash Manager
    And   I search for all AD documents
    And   I copy a random Advance Deposit document with FINAL status
    When  I save the Advance Deposit document
    Then  the Advance Deposit document goes to SAVED

  @KFSQA-645 @smoke @hare
  Scenario: * * * * * Actions to not display on AD
    Given I am logged in as a KFS User
    When  I start an empty Advance Deposit document
    Then  "* * * * Actions" should not be displayed in the Accounting Line section

  @KFSQA-728 @sloth
  Scenario: Copy a Final Advance Deposit, and then create a new one
    Given I am logged in as a KFS Cash Manager
    And   I search for all AD documents
    And   I copy a random Advance Deposit document with FINAL status
    When  I submit the Advance Deposit document
    When  I view the Advance Deposit document
    Then  the document status is FINAL
