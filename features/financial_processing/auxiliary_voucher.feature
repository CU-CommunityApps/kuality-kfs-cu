Feature: KFS Fiscal Officer Account Copy

  [KFSQA-646] No Parm Checking for Object Codes on AV

  @KFSQA-646 @wip
  Scenario: Input an Accounting Line on a AD that will be denied because of parameter KFS-FP Auxiliary Voucher OBJECT_SUB_TYPES
    Given   I am logged in as a KFS Technical Administrator
    And     I find a value for a paramaeter named OBJECT_SUB_TYPES for the Auxiliary Voucher document
    And     I lookup an Object Code with that Object Sub Type
    And     I am logged in as a KFS User
    When    I create an AV document with that Object Code
    Then    I should get an error that starts wiith "The Object Sub-Type Code"