Feature: Organization Review

  [KFSQA-583] As a KFS Chart Administrator I want to copy an Organization without getting an error.

  [KFSQA-584] As a KFS Chart Manager, the Organization Review document should route to final.

  @KFSQA-583
  Scenario: Select an Organization Review to get to the Organization Review Role screen
    Given   I am logged in as a KFS Chart Manager
    And     I edit an Organization Review
    Then    the Organization Review Role document goes to SAVED

  @KFSQA-584
  Scenario: Create an Organization Review, Blanket Approve it, have it go to Final.
    Given   I am logged in as a KFS Chart Manager
    And     I save an Organization Review Role document
    When    I blanket approve the Organization Review Role document
    Then    the Organization Review Role document goes to FINAL
