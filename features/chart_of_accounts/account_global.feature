Feature: Global Acccount

  As a KFS Fiscal Officer I need to perform a lookup on the Major Reporting Category Code field because I need to manage in-year financial activity, fund balances and year-end reporting.

  @wip
  Scenario: KFS User lookup on Major Reporting Category Code KFSQA-604
    Given I am logged in as a KFS Fiscal Officer
    And   I create an Account Global eDoc
    And   I perform a Major Reporting Category Code Lookup
    Then  I should see a list of Major Reporting Category Codes