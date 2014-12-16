Feature: KFS Fiscal Officer Account Copy

  [smoke] As a KFS Fiscal Officer I want to copy an Account
          because I want quickly create many accounts.
  [KFSQA-838] The proper routing of a copied C&G Account with Cornell specific attributes. 
              We are testing that any non-super user perform. This is a smoke test of 
              Cornell-specific attributes in a copied document. We are testing the proper 
              routing of the Cornell specific attributes in a copied document. 

  @smoke @hare @solid
  Scenario: Copy an Account
    Given I am logged in as a KFS Fiscal Officer
    And   I access Account Lookup
    And   I search for all accounts
    And   I copy an Account
    Then  the Account Maintenance Document saves with no errors

  @KFSQA-838 @cornell @smoke @CG @Copy @Routing @nightly-jobs @coral @pending
  Scenario: Copy C&G Account (Smoke Test)
    Given I am logged in as a KFS User
    When  I start to copy a Contracts and Grants Account
    Then  the fields from the old Account populate those in the new Account document

    When  I update the Account with the following changes:
      | Description                        | Random           |
      | Chart Code                         | Same as Original |
      | Number                             | Random           |
      | Appropriation Account Number       | Same as Original |
      | Labor Benefit Rate Category Code   | Same as Original |
      | Major Reporting Category Code      | Same as Original |
      | Subfund Program Code               | Same as Original |
    And   I update the Account's Contracts and Grants tab with the following changes:
      | Contract Control Chart of Accounts Code | Same as Original |
      | Contract Control Account Number         | Same as Original |
      | CFDA Number                             | Same as Original |
      | eVerify Indicator                       | Checked          |
      | Invoice Frequency Code                  | Same as Original |
      | Invoice Type Code                       | Same as Original |
      | Cost Share for Project Number           | Same as Original |
    And   I add an additional Indirect Cost Recovery Account if the Account's Indirect Cost Recovery tab is empty
    And   I submit the Account document
    Then  the document should have no errors

    When  I reload the Account document
    Then  the values submitted for the Account document persist
    And   the Account document's route log is:
      | Role                         | Action  |
      | Fiscal Officer               | APPROVE |
      | Organization Reviewer        | APPROVE |
      | Contracts & Grants Processor | APPROVE |
      | Sub-Fund Reviewer            | APPROVE |

    When  I route the Account document to final
    Then  the Account document goes to FINAL

    Given I am logged in as a KFS User
    When  I start an empty Distribution Of Income And Expense document
    And   I add these accounting lines to the Distribution Of Income And Expense document:
      | Type | Account Number       | Object | Amount |
      | From | Unrestricted Account | 6540   | 5      |
      | To   | Just Created         | 6540   | 5      |
    And   I submit the Distribution Of Income And Expense document
    And   I route the Distribution Of Income And Expense document to final
    And   Nightly Batch Jobs run
    When  I view the Distribution Of Income And Expense document
#    Then  the Account document has General Ledger Balance transactions matching the accounting lines from the Distribution Of Income And Expense document
#    And validate new account has transactions (should be amount of transaction (times) percent that is assigned to the Account Indirect Cost Recovery Account Type Code.)
#        Likely object code 9070 or 9080.
#    And   the recovery Accounts specified in the Distribution Of Income And Expense document have posted income transactions in the General Ledger Balance
#    Then validate recovery accounts have income transactions posted (should be amount of transaction above (so original expense times type code percent)
#         (times) percent noted on account line percent of each recovery account.)