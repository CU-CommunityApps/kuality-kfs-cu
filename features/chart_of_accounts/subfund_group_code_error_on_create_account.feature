Feature: SubFund Group Code error on Create 6071

    As a KFS User I want to want to be notified
    when I leave SubFund Group Code empty during creat Acct

#  Background:
#    Given I am logged in via CUWebLogin

  Scenario: Create an Account
    Given I am logged in as a KFS User
    And I create an account with blank SubFund group Code
    When  I submit the Account
    Then I should get an error on saving that I left the SubFund Group Code field blank
