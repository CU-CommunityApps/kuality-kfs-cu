Feature: Global Account

  [KFSQA-604] As a KFS Fiscal Officer I need to perform a lookup on the Major Reporting Category Code field
              because I need to manage in-year financial activity, fund balances and year-end reporting.
  [KFSQA-577] As a KFS Chart Manager I want to add multiple account lines to the Account Global using Organizational Codes
              because this will save me time.

  @KFSQA-604
  Scenario: KFS User lookup on Major Reporting Category Code
    Given I am logged in as a KFS Fiscal Officer
    And   I create an Account Global eDoc
    And   I perform a Major Reporting Category Code Lookup
    Then  I should see a list of Major Reporting Category Codes

  @KFSQA-577
  Scenario: Create an Account Global using an organization hierarchy
    Given I am logged in as a KFS Chart Manager
    And   I create an Account Global maintenance document with multiple accounting lines
    When  I submit the Account Global maintenance document
    Then  the Account Global maintenance document should go to final

