Feature: Indirect Cost Recovery Rate

  @KFSQA-576 @wip
  Scenario: Verify results are returned for a lookup with an alpha-numeric value for Rate ID in the Indirect Cost Recovery Rate Lookup
    Given I am logged in as a KFS User
    When  I lookup a Rate ID using an alpha-numeric value in the Indirect Cost Recovery Rate table
    Then  the lookup should return results