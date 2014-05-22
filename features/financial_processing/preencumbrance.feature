Feature: Pre-Encumbrance

  [KFSQA-654] Open Encumbrances Lookup not displaying pending entries generated from the PE eDoc.
  [KFSQA-739] Background: Cornell University needs to process pre-encumbrances with expense object
              codes and verify the Accounting Line persists to the GL
  [KFSQA-664] Cornell has modified KFS to allow for revenue object codes on the PE form. Allow revenue on Pre-Encumbrance.
  [KFSQA-753] Cornell University needs to process pre-encumbrances with expense
              object codes and verify proper offsets are used.
  [KFSQA-988] Submit a pre-encumbrance edoc to encumber and disencumber on the same document using an existing
              encumbrance to disencumber and create new encumbrance using fixed monthly schedule.
              Verify you must save edoc before submission to generate reversal dates, review scheduled reversal
              dates on pending entries tab before submitting, and perform lookup on open encumbrance screen to verify accuracy.

  @KFSQA-654 @sloth
  Scenario: Open Encumbrances Lookup will display pending entries from PE eDoc
    Given I am logged in as a KFS Chart Manager
    And   I clone a random Account with the following changes:
      | Name        | Test Account             |
      | Chart Code  | IT                       |
      | Description | [KFSQA-654] Test Account |
    And   I am logged in as a KFS Chart Administrator
    And   I blanket approve a Pre-Encumbrance Document that encumbers the random Account
    And   the Pre-Encumbrance document goes to FINAL
    When  I do an Open Encumbrances lookup for the Pre-Encumbrance document with Balance Type PE and Include All Pending Entries
    Then  the Lookup should return results

  @KFSQA-739 @sloth
  Scenario: E2E - PE Created, Approved and Accounting Line persists and updates GL
    Given   I am logged in as a KFS User for the PE document
    And     I start an empty Pre-Encumbrance document
    And     I add a Source Accounting Line to the Pre-Encumbrance document with the following:
      | Chart Code   | IT      |
      | Number       | U243700 |
      | Object Code  | 4023    |
      | Amount       | 100     |
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

  @KFSQA-740 @sloth
  Scenario: E2E - PE Created, Approved and Accounting Line persists and updates GL
    Given   I am logged in as a KFS User for the PE document
    And     I start an empty Pre-Encumbrance document
    And     I add a Source Accounting Line to the Pre-Encumbrance document with the following:
      | Chart Code   | IT      |
      | Number       | G003704 |
      | Object Code  | 6100    |
      | Amount       | 1000    |
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
    And     I add a Target Accounting Line to the Pre-Encumbrance document with the following:
      | Chart Code   | IT      |
      | Number       | G003704 |
      | Object Code  | 6100    |
      | Amount       | 200     |
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
    Then    The outstanding encumbrance for account G003704 and object code 6100 is 800

  @KFSQA-664 @nightly-jobs @cornell @slug
  Scenario: Process a Pre-Encumbrance using a revenue object code.
    Given   I am logged in as a KFS System Manager
    When    I update the OBJECT_TYPES Parameter for the Pre-Encumbrance component in the KFS-FP namespace with the following values:
      | Parameter Value | EX;IC |
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

    When    Nightly Batch Jobs run
    And     I am logged in as a KFS System Manager
    Then    the Encumbrance Accounting Line appears in the Pre-Encumbrance document's GL entry
    And     I update the OBJECT_TYPES Parameter for the Pre-Encumbrance component in the KFS-FP namespace with the following values:
      | Parameter Value | EX |
    And     I finalize the Parameter document

  @KFSQA-753 @nightly-jobs @cornell @tortoise
  Scenario: Generate Proper Offsets Using a PE to generate an Encumbrance
    Given I am logged in as a KFS User
    And   I submit a Pre-Encumbrance document that encumbers Account G003704
    And   the Object Codes for the Pre-Encumbrance document appear in the document's GLPE entry
    And   I am logged in as a KFS Chart Manager
    And   I view the Pre-Encumbrance document
    And   I blanket approve the Pre-Encumbrance document
    And   the Pre-Encumbrance document goes to FINAL
    And   the Pre-Encumbrance document has matching GL and GLPE offsets
    And   Nightly Batch Jobs run
    When  I am logged in as a KFS User
    Then  the Pre-Encumbrance document GL Entry Lookup matches the document's GL entry

  @KFSQA-988 @FP @PreEncumbrance @smoke @wip
  Scenario: Submit a pre-encumbrance to disencumber and pre-encumber on the same document.
    Given I am logged in as "user", role 54 (or FTC/BSC role 100000157 )
    When I create a pre-encumbrance doc
    And enter a description
    And enter chart
    And account
    And object code
    And amount
    And enter disencumber type (monthly)
    And enter count
    And enter partial amount equal to sum of amount divided by count
    And enter start date
    And enter chart
    And account
    And object code
    And amount
    And reference number of existing encumbrance for this account
    And submit document
    And receive error (This document needs to be saved before submit)
    And click Save
    And review pending entries tab for accuracy
    Then document status becomes 'enroute'

    When I open the general ledger open encumbrances inquiry
    And enter default fiscal year
    And enter chart
    And enter account
    And enter PE balance type
    And set "include pending ledger entry" to "all"
    And click search
    Then the edoc information appears correctly on the list