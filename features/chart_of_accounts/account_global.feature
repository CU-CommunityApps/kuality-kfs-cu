Feature: Global Account

  [KFSQA-604] As a KFS Fiscal Officer I need to perform a lookup on the Major Reporting Category Code field
              because I need to manage in-year financial activity, fund balances and year-end reporting.
  [KFSQA-572] As a KFS Chart Manager I want create a Account Global Maintenance document with a Major Reporting Category,
              because it is a Cornell specific field.
  [KFSQA-577] As a KFS Chart Manager I want to add multiple account lines to the Account Global using Organizational Codes
              because this will save me time.
  [KFSQA-571] Summary: As a KFS Chart Manager I want create a Account Global eDoc with blank Fiscal Officer Principal Name,
              Account Supervisor Principal Name, Account Manager Name and CFDA fields because they are not required.
  [KFSQA-618] As a KFS Fiscal Officer I need to create an account with a Major Reporting Category Code field
              because I need to manage in-year financial activity, fund balances and year-end reporting.

  @KFSQA-604 @cornell @AcctGlobal @KFSPTS-578 @hare @solid
  Scenario: KFS User lookup on Major Reporting Category Code
    Given I am logged in as a KFS Fiscal Officer
    When  I save an Account Global document
    And   I perform a Major Reporting Category Code Lookup
    Then  I should see a list of Major Reporting Category Codes

  @KFSQA-572 @cornell @AcctGlobal @KFSPTS-710 @sloth @solid
  Scenario: Create Account Global Maintenance document with Major Reporting Category Code
    Given I am logged in as a KFS Chart Manager
    When  I submit an Account Global Maintenance document with a Major Reporting Category Code of FACULTY
    And I route the Account Global document to final
    Then the document status is FINAL

  @KFSQA-577 @cornell @AcctGlobal @AcctCreate @KFSPTS-628 @sloth @solid
  Scenario: Create an Account Global using an organization hierarchy
    Given I am logged in as a KFS Chart Manager
    When  I submit an Account Global Maintenance document with multiple accounting lines
    And I route the Account Global document to final
    Then the document status is FINAL

  @KFSQA-618 @cornell @AcctCreate @KITI-2869 @sloth @solid
  Scenario: KFS Chart Manager create an Account Global Maintenance document with a invalid Major Reporting Category Code
    Given I am logged in as a KFS Chart Manager
    When  I submit an Account Global Maintenance document with a Major Reporting Category Code of INVALID
    Then  account global should show an error that says "The specified Major Reporting Category Code does not exist."
    When  I enter a valid Major Reporting Category Code of FACULTY
    And   I submit the Account Global document
    And I route the Account Global document to final
    Then the document status is FINAL

  @KFSQA-571 @Bug @AcctGlobal @KFSMI-8612 @sloth @solid
  Scenario: Create Account Global eDoc with blank fields
    Given I am logged in as a KFS Chart Manager
    When  I submit an Account Global Maintenance document with these fields blank:
      | Fiscal Officer Principal Name     |
      | Account Supervisor Principal Name |
      | Account Manager Principal Name    |
      | CFDA Number                       |
    And I route the Account Global document to final
    Then the document status is FINAL
