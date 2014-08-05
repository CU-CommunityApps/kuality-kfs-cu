Feature: General Error Correction

  [KFSQA-653] I want to create a GEC error correction without getting an error message

  @KFSQA-653 @FP @GEC @sloth
  Scenario: Reject Approver Account changes unless they are the Fiscal Officer
    Given   I am logged in as a KFS Fiscal Officer
    And     I start a General Error Correction document
    And     I add a From Accounting Line to the General Error Correction document with Amount 100
    And     I add a To Accounting Line to the General Error Correction document with Amount 100
    And     I blanket approve the General Error Correction document
    And     the General Error Correction document goes to FINAL
    And     I am logged in as a KFS Fiscal Officer
    And     I view the General Error Correction document
    When    I error correction the General Error Correction document
    Then    the document status is INITIATED