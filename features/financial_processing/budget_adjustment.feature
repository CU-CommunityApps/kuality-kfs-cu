Feature: KFS Fiscal Officer Account Copy

  [KFSQA-623] CF: Budget Adjustment eDoc to balance entries by Account. As a KFS User I want to create a Budget Adjustment but preclude entries from crossing Accounts because of Cornell budget policies.
  [KFSQA-628] Budget Adjustment edoc going FINAL without FO approval. As a KFS Fiscal Officer (FO) I want to approve all
     Budget Adjustments within my Account because this is Cornell SOP.


  @wip @KFSQA-623
  Scenario: Budget Adjustment not allowed to cross Account Sub-Fund Group Codes
    Given   I am logged in as a KFS User
    And     I create a Budget Adjustment document
    And     I add a From amount of "100" for account "1258322" with object code "4480" with a line description of ""
    And     I add a To amount of "100" for account "1258323" with object code "4480" with a line description of ""
    When    I submit the Budget Adjustment document
    Then    budget adjustment should show an error that says "The Budget Adjustment document is not balanced within the account."

  @wip @KFSQA-628
  Scenario: IT is the default value for Budget Adjustment Chart Values
    Given  I am logged in as a KFS Fiscal Officer
    When  I open the Budget Adjustment document page
    Then  I verify that Chart Value defaults to IT

  @wip @KFSQA-628
  Scenario: Budget Adjustment routing and approval by From and To FO
    Given  I am logged in as "sag3"
    And    I submit a balanced Budget Adjustment document
    Then   The document status should be ENROUTE

    Given I am logged in as "sag3"
    And   I submit a balanced Budget Adjustment document
    And   I am logged in as "djj1"
    And   I view the Budget Adjustment Document
    When  I approve the Budget Adjustment document
    Then  The Budget Adjustment document status should be FINAL


    Given I am logged in as "sag3"
    And    I submit a balanced Budget Adjustment document
#    And Nightly Batch Jobs run
    Given I am logged in as "djj1"
    When I view the From Account on the General Ledger Balance with type code CB
    Then The From Account Monthly Balance should match the From amount

    When I view the To Account on the General Ledger Balance with type code CB
    Then The To Account Monthly Balance should match the From amount


#    Line description persists

#
#
#
#
#    Given I am logged in as "sag3"
#    When I save a budget adjustment document
#    And I add a From amount of "250.11" for account "G003704" with object code "4480" with a line description of ""
#    And I add a From amount of 250.11" for account "G003704" with object code "6510"
#    And I add a From line description of ::random::
#
#    And I add a To amount of "250.11" for account "G013300" with object code "4480"
#    And I add a To amount of "250.11" for account "G013300" with object code "6510"
#
#    G013300 sag3
#    G003704 djj1
#    4480 6540
#
#  Account G003704
#    BA: FO - djj1
#    BA: ASPN - jdc324
#    BA: AMPN - tap66
#
#    TO
#    Account - G013300
#    FO sag3
#    aspn - lc88
#    AMPN sag3
#
#  IT,G013300,,4480,,,,Line 1 From,100.22,400.00,,,,,,,,,,,,
#  IT,G013300,,6510,,,,Line 2 From,100.22,400.00,,,,,,,,,,,,
#
#  IT,G003704,,4480,,,,Line 1 To,100.22,400.00,,,,,,,,,,,,
#  IT,G003704,,6510,,,,Line 2 To,100.22,400.00,,,,,,,,,,,,
