Feature: Indirect Cost Recovery Rate

  @wip @KFSQA-576
  Scenario: Verify results are returned for a lookup with an alpha-numeric value for Rate ID in the Indirect Cost Recovery Rate Lookup
    Given    I am logged in as a KFS User
    When     I lookup an Rate ID using an alpha-numeric value in the Indirect Cost Recovery Rate table
    Then     I should see results returned for the  Indirect Cost Recovery Rate lookup