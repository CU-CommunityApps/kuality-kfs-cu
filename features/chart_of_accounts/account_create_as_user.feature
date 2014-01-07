Feature: Account Creation as a KFS User

    As a KFS User I want to want to be notified
    when I do not fill out the form correctly

  Background:
    Given I am logged in as a KFS User

  @wip
  Scenario: I want to be notified when I leave SubFund Group Code empty KFSQA-563
    When   I create an account with blank SubFund group Code
    Then  I should get an error on saving that I left the SubFund Group Code field blank
