Feature: Pre-Encumbrance

  [KFSQA-654] Open Encumbrances Lookup not displaying pending entries generated from the PE eDoc.
  [KFSQA-753] Cornell University needs to process pre-encumbrances with expense
              object codes and verify proper offsets are used.

  @KFSQA-654
  Scenario: Open Encumbrances Lookup will display pending entries from PE eDoc
    Given I am logged in as a KFS Chart Manager
    And   I clone a random Account with the following changes:
      | Name        | Test Account             |
      | Chart Code  | IT                       |
      | Description | [KFSQA-551] Test Account |
    Given I am logged in as a KFS Chart Administrator
    When  I blanket approve a Pre-Encumbrance Document that encumbers the random Account
    And   the Encumbrance document goes to FINAL
    And   I do an Open Encumbrances lookup for the Pre-Encumbrance document with Balance Type PE and Include All Pending Entries
    Then  the lookup should return results

  @KFSQA-753 @nightly-jobs @cornell @wip
  Scenario: Generate Proper Offsets Using a PE to generate an Encumbrance
    Given I am logged in as a KFS User
    When  I start an empty Pre-Encumbrance document
    And   The GLPE entries correctly generate
    And   I blanket approve the document
    Then  the Pre-Encumbrance document goes to FINAL
    And   the Pre-Encumbrance document has matching GL and GLPE entries
    #And   The results from GL Entry Lookup equal the GLPE entries
    When  Nightly Batch Jobs run
    Then  the Pre-Encumbrance document has matching GL and Posted entries
    #Then  The results From GL Entry Lookup equal the Posted Entries