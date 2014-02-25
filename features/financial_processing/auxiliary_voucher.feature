Feature: KFS Fiscal Officer Account Copy

  [KFSQA-646] No Parm Checking for Object Codes on AV
  [KFSQA-627] I want to create an Auxiliary Voucher posting accounting lines across Sub-Fund Group Codes because of Cornell SOP.

  @KFSQA-646
  Scenario: Input an Accounting Line on a AD that will be denied because of parameter KFS-FP Auxiliary Voucher OBJECT_SUB_TYPES
    Given   I am logged in as a KFS Technical Administrator
    And     I find a value for a parameter named OBJECT_SUB_TYPES for the Auxiliary Voucher document
    And     I lookup an Object Code with that Object Sub Type
    And     I am logged in as a KFS User
    When    I create an AV document with that Object Code
    Then    I should get an error that starts with "The Object Sub-Type Code"

  @KFSQA-627 @wip
  Scenario: Auxiliary Voucher allows Accounting Lines across Sub Fund Group Codes
    Given   I am logged in as a KFS User
    And     I start an empty Auxiliary Voucher document
    And     I add credit and debit accounting lines with two different sub funds
    When    I submit the Auxiliary Voucher document
    Then    The document should have no errors
    And     the auxiliary Voucher document goes to ENROUTE
