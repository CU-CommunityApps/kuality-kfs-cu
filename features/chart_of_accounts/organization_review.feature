Feature: Organization Review

  [KFSQA-583] As a KFS Chart Administrator I want to copy an Organization without getting an error.

  @KFSQA-583 @wip
  Scenario: Select an Organization Review to get to the Organization Review Role screen
    Given   I am logged in as a KFS Chart Manager
    And     I edit an Organization Review
    Then    the Organization Review Role Maintenance Document goes to INITIATED
