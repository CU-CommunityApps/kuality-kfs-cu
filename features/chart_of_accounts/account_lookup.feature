Feature: Account Lookup
  Summary: As a KFS user
    I want to see acct look up screen because it has custom cornell fields

  Scenario:
    Given I am logged in as a KFS User

    When I access Account Lookup

    Then the Account Lookup page should appear


   # Scenario:
    #   Given I am logged in as a KFS User

    #   Given I access Account Lookup

    #   When I enter an Account Number and search

    #   Then The Account is found