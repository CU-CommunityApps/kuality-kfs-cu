Feature: General Error Correction

  [KFSQA-653] I want to create a GEC error correction without getting an error message

  [KFSQA-991] Verify audit trail

  @KFSQA-653 @FP @GEC @sloth
  Scenario: Reject Approver Account changes unless they are the Fiscal Officer
    Given   I am logged in as a KFS Fiscal Officer
    And     I start a General Error Correction document
    And     I add a From Accounting Line to the General Error Correction document with the following:
      | Chart Code   | IT      |
      | Number       | G003704 |
      | Object Code  | 1210    |
      | Amount       | 100     |
    And     I add a To Accounting Line to the General Error Correction document with the following:
      | Chart Code   | IT      |
      | Number       | G254700 |
      | Object Code  | 1210    |
      | Amount       | 100     |
  #TODO grab chart, account and object code from parameter
    And     I blanket approve the General Error Correction document
    And     the General Error Correction document goes to FINAL
    And     I am logged in as a KFS Fiscal Officer
    And     I view the General Error Correction document
    When    I error correction the General Error Correction document
    Then    the document status is INITIATED

  @wip @KFSQA-991 @GEC @smoke @pending
  Scenario: Verify audit trail is updated and persists without saving on a FP, non-DV eDoc for changes to accounting lines
    Given   I am logged in as a KFS Fiscal Officer
    And     I start a General Error Correction document
    And     I add a From Accounting Line to the General Error Correction document with the following:
      | Chart Code   | IT      |
      | Number       | G003704 |
      | Object Code  | 1210    |
      | Amount       | 100     |
    And     I add a To Accounting Line to the General Error Correction document with the following:
      | Chart Code   | IT      |
      | Number       | G254700 |
      | Object Code  | 1210    |
      | Amount       | 100     |
    And I submit the General Error Correction document
    And I am logged in as a KFS Fiscal Officer
    And I view the General Error Correction document
    And I am logged in as a KFS Fiscal Officer for account number G003704
    And I reduce the amount on existing from line by 50
    And I add an additional accounting line with amount 50
    And I approve the General Error Correction document
    Then the Notes and Attachment Tab says "something needed here when bug is fixed"
