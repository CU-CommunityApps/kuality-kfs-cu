Feature: Organization Review

  [KFSQA-583] As a KFS Chart Manager, I want to edit, copy, or create delegation for an Organization Review
              without getting an Incident Report.

  [KFSQA-584] As a KFS Chart Manager, the Organization Review document should route to final.


  @KFSQA-583 @Bug @OrgMaint @KFSMI-9622 @hare @solid
  Scenario: When the KFS Chart Manager edits and submits an Organization Review, the document routes to Final.
    Given   I am logged in as a KFS Chart Manager
    And     I edit the Active To Date on a random Organization Review to today's date
    When    I submit the Organization Review document
    And     the document should have no errors
    Then    the Organization Review document goes to FINAL

  @KFSQA-583 @Bug @OrgMaint @KFSMI-9622 @hare @solid
  Scenario: When the KFS Chart Manager copies and submits an Organization Review, the document routes to Final.
    Given   I am logged in as a KFS Chart Manager
    And     I copy a random Organization Review changing Organization Code to a random value
    When    I submit the Organization Review document
    And     the document should have no errors
    Then    the Organization Review document goes to FINAL

  @KFSQA-583 @Bug @OrgMaint @KFSMI-9622 @hare @solid
  Scenario: When the KFS Chart Manager performs a create delegation for an Organization Review and submits
  the document, the document routes to Final.
    Given   I am logged in as a KFS Chart Manager
    And     I create a primary delegation for a random Organization Review
    And     I submit the Organization Review document changing the Principal Name to a random KFS User
    And     the document should have no errors
    Then    the Organization Review document goes to FINAL

  @KFSQA-584 @Bug @Routing @OrgReview @KFSMI-10435 @sloth @solid
  Scenario: Create an Organization Review, Blanket Approve it, have it go to Final.
    Given   I am logged in as a KFS Chart Manager
    And     I save an Organization Review document
    When    I blanket approve the Organization Review document
    Then    the Organization Review document goes to FINAL
