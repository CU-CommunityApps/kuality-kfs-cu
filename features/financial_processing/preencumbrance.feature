Feature: Pre-Encumbrance

  [KFSQA-654] Open Encumbrances Lookup not displaying pending entries generated from the PE eDoc.

  @KFSQA-654 @wip
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

#  Given   I am logged in as a KFS Chart Administrator
#  And     I save a Pre-Encumbrance document
#  And     I Blanket Approve the Pre-Encumbrance document
#  And     the Pre-Encumbrance document goes to FINAL
#  And     I do an Open Encumbrances lookup for the Pre-Encumbrance document with Balance Type EX and Include All Pending Entries
#  Then    I Get Results