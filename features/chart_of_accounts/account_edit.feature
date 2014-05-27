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

  @KFSQA-593 @hare
  Scenario: Edit an Account with an invalid Sub-Fund Program Code, part 1
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a Sub-Fund Group Code of PLCAPT
    When  I enter a Sub-Fund Program Code of XXXX
    Then  an error in the Account Maintenance tab should say "Sub-Fund Program Code XXXX is not associated with Sub-Fund Group Code PLCAPT."

  @KFSQA-593 @hare
  Scenario: Edit an Account with an invalid Sub-Fund Program Code, part 2
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a Sub-Fund Group Code of PLCAPT
    When  I enter XXXXXXX as an invalid Major Reporting Category Code
    Then  an error in the Account Maintenance tab should say "Major Reporting Category Code (XXXXXXX) does not exist."

  @KFSQA-593 @hare
  Scenario: Edit an Account with an invalid Sub-Fund Program Code, part 3
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a Sub-Fund Group Code of PLCAPT
    When  I enter XXXXXXX as an invalid Appropriation Account Number
    Then  an error in the Account Maintenance tab should say "Appropriation Account Number XXXXXXX is not associated with Sub-Fund Group Code PLCAPT."

  @KFSQA-593 @hare
  Scenario: Edit an Account with an invalid Sub-Fund Program Code, part 4
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a Sub-Fund Group Code of PLCAPT
    When  I enter XX as an invalid Labor Benefit Rate Category Code
    Then  an error in the Account Maintenance tab should say "Invalid Labor Benefit Rate Code"
    Then  an error in the Account Maintenance tab should say "The specified Labor Benefit Rate Category Code XX does not exist."

  @KFSQA-610 @hare
  Scenario: Edit an Account as KFS Chart Admin
    Given I am logged in as a KFS Chart Administrator
    And   I edit an Account
    When  I blanket approve the Account document
    Then  the Account document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |

  @KFSQA-632 @hare
  Scenario: KFS Chart Manager edits an Account with Major Reporting Category Code
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account
    When  I input a lowercase Major Reporting Category Code value
    When  I blanket approve the Account document
    Then  the Account document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |

  @KFSQA-619 @sloth
  Scenario: Create an Account that matches Sub-Fund Group Code and Sub-Fund Program Code with an Appropriation Account Number
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account
    And   I enter Sub Fund Group Code of INFHFO
    And   I enter Sub Fund Program Code of CENTER
    And   I enter Appropriation Account Number of LTIP
    When  I blanket approve the Account document
    Then  the Account document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |

  @KFSQA-619 @hare
  Scenario: Create an Account that does not match Sub-Fund Group Code and Sub-Fund Program Code with an Appropriation Account Number
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account
    And   I enter Sub Fund Group Code of INFHFO
    And   I enter Sub Fund Program Code of CENTER
    And   I enter Appropriation Account Number of C771503
    When  I submit the Account document
    Then  an error in the Account Maintenance tab should say "Appropriation Account Number C771503 is not associated with Sub-Fund Group Code INFHFO."

  @KFSQA-586 @sloth
  Scenario: Try to continue an Account to itself
    Given I am logged in as a KFS Chart Manager
    And   I access Account Lookup
    And   I search for all accounts
    And   I clone a random Account with the following changes:
      | Name        | Test Account             |
      | Chart Code  | IT                       |
      | Description | [KFSQA-586] Test Account |
    And   I close the Account
    And   I enter a Continuation Account Number that equals the Account Number
    When  I blanket approve the Account document
    Then  an empty error should appear

  @KFSQA-569 @nightly-jobs @pending @broken!
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