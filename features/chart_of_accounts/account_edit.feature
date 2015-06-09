Feature: Account Edit

  [KFSQA-593] As a KFS Chart Manager, when I edit an Account with an
              invalid Sub-Fund Program Code I should get an error message presented
              at the top of the Accountant Maintenance Tab. Because the field is validated
              against a maintenance table and KFS standards require it.

  [KFSQA-610] As a KFS Chart Administrator I want to update an Account without getting a stack trace error.

  [KFSQA-632] As a KFS Fiscal Officer I need to edit an account using the Major Reporting Category Code field and enter
              a lowercase value and have it convert to UPPERCASE because I need to manage in-year financial activity,
              fund balances and year-end reporting.

  [KFSQA-586] As a KFS Chart Manager, the Account Number and the Continuation Account on that account cannot
              and should not ever be the equal as this defeats the purpose of a continuation account.

  [KFSQA-569] As a KFS Chart Manager I want to change the account expiration date
              because I still want any enroute documents to be approved.

  @KFSQA-593 @Bug @AcctCreate @KITI-2931 @hare @solid
  Scenario: Edit an Account with an invalid Sub-Fund Program Code, part 1
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a random Sub-Fund Group Code
    When  I enter an invalid Sub-Fund Program Code
    Then  I should get an invalid Sub-Fund Program Code error

  @KFSQA-593 @Bug @AcctCreate @KITI-2931 @hare @solid
  Scenario: Edit an Account with an invalid Sub-Fund Program Code, part 2
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a random Sub-Fund Group Code
    When  I enter an invalid Major Reporting Category Code
    Then  I should get an invalid Major Reporting Category Code error

  @KFSQA-593 @Bug @AcctCreate @KITI-2931 @hare @solid
  Scenario: Edit an Account with an invalid Sub-Fund Program Code, part 3
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a random Sub-Fund Group Code
    When  I enter an invalid Appropriation Account Number
    Then  I should get an invalid Appropriation Account Number error

  @KFSQA-593 @Bug @AcctCreate @KITI-2931 @hare @solid
  Scenario: Edit an Account with an invalid Sub-Fund Program Code, part 4
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a random Sub-Fund Group Code
    When  I enter an invalid Labor Benefit Rate Code
    Then  I should get invalid Labor Benefit Rate Code errors

  @KFSQA-610 @KFSQA-574 @Bug @AcctMaint @hare @solid
  Scenario: Edit an Account as KFS Chart Admin
    Given I am logged in as a KFS Chart Administrator
    And   I edit an Account
    When  I blanket approve the Account document
    Then  the Account document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |

  @KFSQA-632 @cornell @AcctCreate @KITI-2869 @hare @solid
  Scenario: KFS Chart Manager edits an Account with Major Reporting Category Code
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account
    When  I input a lowercase Major Reporting Category Code value
    When  I blanket approve the Account document
    Then  the Account document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |

  @KFSQA-619 @AcctCreate @sloth @solid
  Scenario: Create an Account that matches Sub-Fund Group Code and Sub-Fund Program Code with an Appropriation Account Number
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account
    And   I enter Sub Fund Program Code and Appropriation Account Number that are associated with a random Sub Fund Group Code
    When  I blanket approve the Account document
    Then  the Account document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |

  @KFSQA-619 @AcctCreate @hare @solid
  Scenario: Create an Account that does not match Sub-Fund Group Code and Sub-Fund Program Code with an Appropriation Account Number
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account
    And   I enter Sub Fund Program Code that is associated with a random Sub Fund Group Code
    And   I enter an Appropriation Account Number that is not associated with the Sub Fund Group Code
    When  I submit the Account document
    Then  I should get an invalid Appropriation Account Number error

  @KFSQA-586 @Bug @AcctClose @KFSMI-5961 @sloth @solid
  Scenario: Try to continue an Account to itself
    Given I am logged in as a KFS Chart Manager
    And   I clone a random Account with name, chart code, and description changes
    And   I close the Account
    And   I enter a Continuation Account Number that equals the Account Number
    When  I blanket approve the Account document
    Then  an empty error should appear

  @KFSQA-569 @Bug @AcctEdit @GEC @KITI-2647 @nightly-jobs @pending @broken!
  Scenario: Extension of Account expiration dates, while an eDoc is enroute,
            should not prevent eDocs with this Account from going to final status
    Given I am logged in as a KFS User
    And   I find an expired Account
    When  I start a General Error Correction document
    And   I add an Accounting Line to the General Error Correction document with "Account Expired Override" selected
    And   I submit the General Error Correction document
    Then  the General Error Correction document goes to ENROUTE
    Given I am logged in as a KFS Chart Administrator
    When  I edit the Account
    And   I extend the Expiration Date of the Account document 365 days
    And   I blanket approve the Account document and deny any questions
    And   Nightly Batch Jobs run
    Then  the Account document goes to PROCESSED
    And   I am logged in as a KFS User
    When  I view the General Error Correction document
    And   I blanket approve the GEC document
    And   Nightly Batch Jobs run
    Then  the Account document goes to PROCESSED
