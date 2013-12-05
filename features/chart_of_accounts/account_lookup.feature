Feature: Account Lookup
  Summary: As a KFS user
    I want to see acct look up screen beacause it has custom cornell fields
  Scenario:
    Given I am logged in as a KFS Fiscal Officer am logged in as a kfs user

    When I access acct lookup

    Then the acct lookup should appear


    Scenario:
      Given I am logged in as a KFS Fiscal Officer am logged in as a kfs user

      Given I access acct lookup

      When I enter an account number and search

      Then The account is found