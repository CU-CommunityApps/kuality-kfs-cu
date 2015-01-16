Feature: Account Creation as a KFS User

  [KFSQA-563] As a KFS User I want to want to be notified
              when I do not fill out the form correctly

  @KFSQA-563 @AcctCreate @SubFundGroup @hare @solid
  Scenario: I want to be notified when I leave SubFund Group Code empty
    Given I am logged in as a KFS Chart Manager
    When  I submit an account with blank SubFund group Code
    Then  I should get an error on saving that I left the SubFund Group Code field blank
