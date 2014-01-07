Feature: Global Account

  As a KFS Fiscal Officer I need to perform a lookup on the Major Reporting Category Code field because I need to manage in-year financial activity, fund balances and year-end reporting.

  Scenario: KFS User lookup on Major Reporting Category Code KFSQA-604
    Given I am logged in as a KFS Fiscal Officer
    And   I create an Account Global edoc
    And   I perform a Major Reporting Category Code Lookup
    Then  I should see a list of Major Reporting Category Codes

    @wip
#    TODO:: Move this to a better location as more tests are written
#  Feature: KFSQA-577 Account Global Lookup Modification
#  As a KFS Chart Manager I want to add multiple account lines to the Account Global using Organizational Codes because this will save me time
 Scenario: Create an Account Global using an organization hierarchy-577
    Given  I am logged in as a KFS Chart Manager
    And     I create an Account Global maintenance document with multiple accounting lines
    When  I submit the document
    Then   the document should go to final

