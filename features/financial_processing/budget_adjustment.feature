Feature: KFS Fiscal Officer Account Copy

  [KFSQA-623] CF: Budget Adjustment eDoc to balance entries by Account. As a KFS User
              I want to create a Budget Adjustment but preclude entries from crossing Accounts because of Cornell budget policies.
  [KFSQA-628] Budget Adjustment edoc going FINAL without FO approval. As a KFS Fiscal Officer (FO)
              I want to approve all Budget Adjustments within my Account because this is Cornell SOP.
  [KFSQA-629] Bug: Budget Adjustment Import Template incorrectly importing Base Budgets (BB), As a KFS User I want to import only BA Base Budget amounts using templates to make the budgeting process more efficient.

  @KFSQA-623
  Scenario: Budget Adjustment not allowed to cross Account Sub-Fund Group Codes
    Given   I am logged in as a KFS User
    And     I start a Budget Adjustment document
    And     I add a From amount of "100.00" for account "1258322" with object code "4480" with a line description of "aft from1"
    And     I add a to amount of "100" for account "1258323" with object code "4480" with a line description of "aft to 1"
    When    I submit the Budget Adjustment document
    Then    I should get an error saying "The Budget Adjustment document is not balanced within the account."

  @KFSQA-628
  Scenario: IT is the default value for Budget Adjustment Chart Values
    Given  I am logged in as a KFS Fiscal Officer
    When  I open the Budget Adjustment document page
    Then  I verify that Chart Value defaults to IT

  @KFSQA-628
  Scenario: Budget Adjustment routing and approval by From and To FO
    Given  I am logged in as "sag3"
    And    I submit a balanced Budget Adjustment document
    Then   the Budget Adjustment document goes to ENROUTE
    And    I am logged in as "djj1"
    And    I view the Budget Adjustment document
    When   I approve the Budget Adjustment document
    Then   the Budget Adjustment document goes to FINAL

  @KFSQA-628
  Scenario: General ledger balance displays correctly for a Budget Adjustment after nightly batch is run
    Given  I am logged in as "sag3"
    And    I submit a balanced Budget Adjustment document
    And    I am logged in as "djj1"
    And    I view the Budget Adjustment document
    When   I approve the Budget Adjustment document
    And    Nightly Batch Jobs run
    Given  I am logged in as "djj1"
    When   I view the From Account on the General Ledger Balance with balance type code of CB
    Then   The From Account Monthly Balance should match the From amount
    And    The line description for the From Account should be displayed
    When   I view the To Account on the General Ledger Balance with balance type code of CB
    Then   The To Account Monthly Balance should match the To amount
    And    The line description for the To Account should be displayed

  @wip @KFSQA-629
  Scenario: Upload only Base Budget budget transactions using BA Import Template.
    Given    I am logged in as a KFS Technical Administrator
    And      I create a Budget Adjustment document for file import
    And      I upload From Accounting Lines containing Base Budget amounts
    And      I upload To Accounting Lines containing Base Budget amounts
    When     I submit the Budget Adjustment document
    Then     The GLPE contains 4 Balance Type BB transactions
    When     I view the Budget Adjustment document
    And      I blanket approve the Budget Adjustment document
    Then     the Budget Adjustment document goes to PROCESSED