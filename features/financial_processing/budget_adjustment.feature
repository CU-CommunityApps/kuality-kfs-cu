Feature: Budget Adjustment

  [KFSQA-623] CF: Budget Adjustment eDoc to balance entries by Account. As a KFS User
              I want to create a Budget Adjustment but preclude entries from crossing Accounts because of Cornell budget policies.
  [KFSQA-628] Budget Adjustment edoc going FINAL without FO approval. As a KFS Fiscal Officer (FO)
              I want to approve all Budget Adjustments within my Account because this is Cornell SOP.
  [KFSQA-629] Bug: Budget Adjustment Import Template incorrectly importing Base Budgets (BB),
              As a KFS User I want to import only BA Base Budget amounts using templates to
              make the budgeting process more efficient.
  [KFSQA-670] BA Import Template CB and BB Uploads, Cornell University requires CB and BB Balances uploaded through an Import Template to be recorded in the General Ledger.

  [KFSQA-729] Cornell University requires that a Budget Adjustment must route to all Fiscal Officers.

  @KFSQA-623 @BA @hare
  Scenario: Budget Adjustment not allowed to cross Account Sub-Fund Group Codes
    Given   I am logged in as a KFS User
    And     I start an empty Budget Adjustment document
    And     I add a From amount of "100.00" for account "1002000" with object code "4480" with a line description of "aft from1"
    And     I add a To amount of "100" for account "1002001" with object code "4480" with a line description of "aft to 1"
    When    I submit the Budget Adjustment document
    Then    I should get an error saying "To use account 1002000, all accounting lines must match on Sub-Fund Group Code."

  @KFSQA-628 @BA @E2E @hare
  Scenario: IT is the default value for Budget Adjustment Chart Values
    Given I am logged in as a KFS Fiscal Officer
    When  I open the Budget Adjustment document page
    Then  I verify that Chart Value defaults to IT

  @KFSQA-628 @BA @E2E @cornell @hare
  Scenario: Budget Adjustment routing and approval by From and To FO
    # logged in as the To account FO
    Given I am logged in as a KFS Fiscal Officer for account number G013300
    And   I submit a balanced Budget Adjustment document with accounting lines
    Then  the Route Log displays a From Fiscal Officer
    And   the Budget Adjustment document goes to ENROUTE
    And   I am logged in as the From Fiscal Officer
    And   I view the Budget Adjustment document
    When  I approve the Budget Adjustment document
    Then  the Budget Adjustment document goes to FINAL

  @KFSQA-628 @BA @E2E @cornell @nightly-jobs @tortoise @broken!
  Scenario: General ledger balance displays correctly for a Budget Adjustment after nightly batch is run
    # logged in as the To account FO
    Given  I am logged in as a KFS Fiscal Officer for account number G013300
    And    I submit a balanced Budget Adjustment document with accounting lines
    And    I switch to the user with the next Pending Action in the Route Log for the Budget Adjustment document
    And    I view the Budget Adjustment document
    When   I approve the Budget Adjustment document
    And    Nightly Batch Jobs run
    Given  I am logged in as the From Fiscal Officer
    When   I view the From Account on the General Ledger Balance with balance type code of CB
    Then   The From Account Monthly Balance should match the From amount
    And    The line description for the From Account should be displayed
    When   I view the To Account on the General Ledger Balance with balance type code of CB
    Then   The To Account Monthly Balance should match the To amount
    And    The line description for the To Account should be displayed

  @KFSQA-629 @BA @Bug @tortoise
  Scenario Outline: Upload only Base Budget budget transactions using BA Import Template.
  # GETTING ERROR FOR NOT ALLOWING BASE ADJUSTMENT FOR YEARS 2014 and 2015 (only available)
      #TODO : There is only 1 example; do we really need 'scenario outline'
    Given   I am logged in as a KFS User for the <type code> document
    And     I start a <document> document for from "<From file name>" file import and to "<To file name>" file import
    And     on the <document> I import the From Accounting Lines from a csv file
    And     on the <document> I import the To Accounting Lines from a csv file
    And     I save the <document> document
    Then    The GLPE contains 4 Balance Type BB transactions for the <document> document
    And     I view the <document> document
    And     I submit the <document> document
    When    I route the <document> document to final
    Then    the <document> document goes to FINAL
  Examples:
    | document            | type code | From file name              | To file name             |
    | Budget Adjustment   | BA        | BA_test_from.csv            | BA_test_to.csv           |

  @KFSQA-670 @BA @cornell @slug @nightly-jobs
  Scenario Outline: CB and BB Balances from BA Import Template updates General Ledger
    Given   I am logged in as a KFS User for the <type code> document
    And     I start a <document> document for from "<From file name>" file import and to "<To file name>" file import
    And     on the <document> I import the From Accounting Lines from a csv file
    And     I capture the From Accounting Lines for the <document>
    And     on the <document> I import the To Accounting Lines from a csv file
    And     I capture the To Accounting Lines for the <document>
    And     I submit the <document> document
    And     I route the <document> document to final
    And     Nightly Batch Jobs run
    And     I am logged in as a KFS User for the <type code> document
    And     I view the General Ledger Balance From account with balance type code of CB
    Then    The BA Template Current Amount equals the General Ledger Balance for CB
    And     I view the General Ledger Balance From account with balance type code of BB
    Then    The BA Template Base Amount equals the General Ledger Balance for BB
  Examples:
    | document          | type code | From file name      | To file name      |
    | Budget Adjustment | BA        | BA_test_from.csv    | BA_test_to.csv    |
    #This for when BA doesn't allow
#    | Budget Adjustment | BA        | BA_import_from.csv  | BA_import_to.csv  |

  @KFSQA-729 @BA @tortoise
  Scenario: "To" Fiscal Officer initiates Budget Adjustment; BA routes to "From" Fiscal Officer
    Given I am logged in as a KFS Fiscal Officer for account number G013300
    And   I submit a balanced Budget Adjustment document with accounting lines
    Then  the Route Log displays a From Fiscal Officer
    And   the Budget Adjustment document goes to ENROUTE
    When  I am logged in as the From Fiscal Officer
    And   I view the Budget Adjustment document
    And   I approve the Budget Adjustment document
    Then  the Budget Adjustment document goes to FINAL
