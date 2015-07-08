Feature: Pre-Encumbrance

  [KFSQA-654] Open Encumbrances Lookup not displaying pending entries generated from the PE eDoc.

  [KFSQA-739] Background: Cornell University needs to process pre-encumbrances with expense object
              codes and verify the Accounting Line persists to the GL

  [KFSQA-740] Enter a Disencumbrance on a PE. Test routing and approvals. Nightly batch jobs run.
              Check entry of eDoc equals GLPE. Test Entry of eDoc equals GL Postings

  [KFSQA-664] Cornell has modified KFS to allow for revenue object codes on the PE form. Allow revenue on Pre-Encumbrance.

  [KFSQA-753] Cornell University needs to process pre-encumbrances with expense
              object codes and verify proper offsets are used.

  [KFSQA-988] Submit a pre-encumbrance edoc to encumber and disencumber on the same document using an existing
              encumbrance to disencumber and create new encumbrance using fixed monthly schedule.
              Verify you must save edoc before submission to generate reversal dates, review scheduled reversal
              dates on pending entries tab before submitting, and perform lookup on open encumbrance screen to verify accuracy.

  @KFSQA-654 @FP @PE @GL-QUERY @sloth @solid
  Scenario: Open Encumbrances Lookup will display pending entries from PE eDoc
    Given I am logged in as a KFS Chart Manager
    And   I clone a random Account with name, chart code, and description changes
    And   I am logged in as a KFS Chart Administrator
    And   I blanket approve a Pre-Encumbrance Document that encumbers the random Account
    And   the Pre-Encumbrance document goes to FINAL
    Then  the Open Encumbrances lookup for the Pre-Encumbrance document with Balance Type PE Includes All Pending Entries

  @KFSQA-739 @FP @PE @sloth @solid
  Scenario: E2E - PE Created, Approved and Accounting Line persists and updates GL
    Given   I am logged in as a KFS User for the PE document
    And     I start an empty Pre-Encumbrance document
    And     I add a source Accounting Line with a random account, a random object code and a default amount to the Pre-Encumbrance document
    And     I save the Pre-Encumbrance document
    And     the Pre-Encumbrance document accounting lines equal the General Ledger Pending entries
    And     I submit the Pre-Encumbrance document
    And     I am logged in as a KFS Chart Administrator
    And     I view the Pre-Encumbrance document
    And     I blanket approve the Pre-Encumbrance document
    And     the Pre-Encumbrance document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |
    When    I am logged in as a KFS Chart Manager
    Then    the Pre-Encumbrance document accounting lines equal the General Ledger entries

  @KFSQA-740 @FP @PE @sloth @solid
  Scenario: Disencumbrance E2E
    Given   I am logged in as a KFS User for the PE document
    And     I start an empty Pre-Encumbrance document
    And     I add a source Accounting Line with a random account, a random object code and a default amount to the Pre-Encumbrance document
    And     I save the Pre-Encumbrance document
    And     I remember the Pre-Encumbrance document number
    And     the Pre-Encumbrance document accounting lines equal the General Ledger Pending entries
    And     I submit the Pre-Encumbrance document
    And     I am logged in as a KFS Chart Administrator
    And     I view the Pre-Encumbrance document
    And     I blanket approve the Pre-Encumbrance document
    And     the Pre-Encumbrance document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |
    And     I am logged in as a KFS Chart Manager
    And     the Pre-Encumbrance document accounting lines equal the General Ledger entries
    And     I am logged in as a KFS User for the PE document
    And     I start an empty Pre-Encumbrance document
    And     I add a target Accounting Line to the Pre-Encumbrance document that matches the source Accounting Line except for amount
    And     I save the Pre-Encumbrance document
    And     the Pre-Encumbrance document accounting lines equal the General Ledger Pending entries
    And     I submit the Pre-Encumbrance document
    And     I am logged in as a KFS Chart Administrator
    And     I view the Pre-Encumbrance document
    And     I blanket approve the Pre-Encumbrance document
    And     the Pre-Encumbrance document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |
    When    I am logged in as a KFS Chart Manager
    Then    the outstanding encumbrance for the account and object code used is the difference between the amounts

  @KFSQA-664 @FP @PE @nightly-jobs @cornell @slug @solid
  Scenario: Process a Pre-Encumbrance using a revenue object code.
    Given   I am logged in as a KFS System Manager
    When    I update an application Parameter to allow revenue object codes on a Pre-Encumbrance document
    And     I submit the Parameter document
    And     I finalize the Parameter document

    Given   I am logged in as a KFS User
    When    I save a Pre-Encumbrance document with an Encumbrance Accounting Line for the current Month
    Then    the Encumbrance Accounting Line appears in the Pre-Encumbrance document's GLPE entry
    When    I view the Pre-Encumbrance document
    And     I blanket approve the Pre-Encumbrance document
    Then    the Pre-Encumbrance document goes to FINAL

    When    I lookup the Encumbrance Accounting Line for the Pre-Encumbrance document via Available Balances with these options selected:
      | Include Pending Ledger Entry | All |
    And     I open the Encumbrance Amount General Ledger Balance Lookup in the Available Balances lookup that matches the one submitted for Encumbrance Accounting Line on the Pre-Encumbrance document
    And     I lookup all entries for the current month in the General Ledger Balance lookup entry
    Then    the General Ledger Balance lookup displays the document ID for the Pre-Encumbrance document
    And     the Encumbrance Accounting Line on the General Ledger Balance lookup for the Pre-Encumbrance document equals the displayed amounts
    #Remaining validation will be performed after the nightly batch jobs are executed for this feature file
    Then    references to test KFSQA-664 instance data are saved for validation after batch job execution
    And     I am logged in as a KFS System Manager
    And     I restore the application parameter to its original value
    And     I submit the Parameter document
    And     I finalize the Parameter document

  @KFSQA-753 @FP @PE @nightly-jobs @cornell @tortoise @solid
  Scenario: Generate Proper Offsets Using a PE to generate an Encumbrance
    Given I am logged in as a KFS User
    And   I submit a Pre-Encumbrance document that encumbers a random Account
    And   the Object Codes for the Pre-Encumbrance document appear in the document's GLPE entry
    And   I am logged in as a KFS Chart Manager
    And   I view the Pre-Encumbrance document
    And   I blanket approve the Pre-Encumbrance document
    And   the Pre-Encumbrance document goes to FINAL
    And   the Pre-Encumbrance document has matching GL and GLPE offsets
    #Remaining validation will be performed after the nightly batch jobs are executed for this feature file
    Then    references to test KFSQA-753 instance data are saved for validation after batch job execution

  @KFSQA-988 @FP @PreEncumbrance @smoke @slug @solid
  Scenario: Submit a pre-encumbrance to disencumber and pre-encumber on the same document.
    #create the pre-encumbrance that will be disencumbered by this test
    Given I am logged in as a KFS User for the PE document
    When  I start an empty Pre-Encumbrance document
    And   I add a source Accounting Line with a random account, a random object code and a default amount to the Pre-Encumbrance document
    And   I remember the Pre-Encumbrance document number
    And   I save the Pre-Encumbrance document
    And   the Pre-Encumbrance document accounting lines equal the General Ledger Pending entries
    And   I submit the Pre-Encumbrance document
    When  I am logged in as a KFS Chart Administrator
    And   I view the Pre-Encumbrance document
    And   I blanket approve the Pre-Encumbrance document
    Then  the Pre-Encumbrance document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |
    #create the pre-encumbrance that will test the encumber and disencumber
    When  I am logged in as a KFS User for the PE document
    And   I start an empty Pre-Encumbrance document
    And   I add a source Accounting Line to a Pre-Encumbrance document that automatically disencumbers an account with an existing encumbrance by a partial amount using a fixed monthly schedule
    And   I add a target Accounting Line to a Pre-Encumbrance document to disencumber an existing encumbrance
    And   I retain the Pre-Encumbrance document number from this transaction
    And   I submit the Pre-Encumbrance document
    Then  I should get an error that starts with "This Document needs to be saved before Submit"
    And   I save the Pre-Encumbrance document
    And   the General Ledger Pending entries match the accounting lines on the Pre-Encumbrance document
    And   I submit the Pre-Encumbrance document
    And   the Pre-Encumbrance document goes to one of the following statuses:
      | ENROUTE |
      | SAVED   |
    Then  Open Encumbrance Lookup Results for the Account just used with Balance Type PE for All Pending Entries and Include Zeroed Out Encumbrances will display the disencumbered amount in both open and closed amounts with outstanding amount zero

  @nightly-jobs @solid
  Scenario: Run Nightly batch jobs required for Pre-Encumbrance Tests Verification
    Given   Nightly Batch Jobs run
    Then    There are no incomplete Batch Job executions

  @KFSQA-664 @validation-after-batch @solid
  Scenario: Validation for Process a Pre-Encumbrance using a revenue object code
    Given   All Nightly Batch Jobs have completed successfully
    And     I can retrieve references to test KFSQA-664 instance data saved for validation after batch job execution
    And     I am logged in as a KFS System Manager
    Then    the Encumbrance Accounting Line appears in the Pre-Encumbrance document's GL entry

  @KFSQA-753 @validation-after-batch @solid
  Scenario: Validation for Generate Proper Offsets Using a PE to generate an Encumbrance
    Given All Nightly Batch Jobs have completed successfully
    And   I can retrieve references to test KFSQA-753 instance data saved for validation after batch job execution
    When  I am logged in as a KFS User
    Then  the Pre-Encumbrance document GL Entry Lookup matches the document's GL entry