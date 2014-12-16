Feature: Indirect Cost Recovery Rate

  [KFSQA-576] As a KFS User I want to enter a Cornell specific alpha numeric ICR Rate ID because this accommodates our federal and endowment processing needs

  @KFSQA-576 @CreateICR @cornell @smoke @KFSPTS-1187 @hare @solid
  Scenario: Verify results are returned for a lookup with an alpha-numeric value for Rate ID in the Indirect Cost Recovery Rate Lookup
    Given I am logged in as a KFS User
    When  I lookup a Rate ID using an alpha-numeric value in the Indirect Cost Recovery Rate table
    Then  the Lookup should return results