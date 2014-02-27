Feature: General Error Correction

  [KFSQA-653] I want to create a GEC error correction without getting an error message

  @KFSQA-652 @wip
  Scenario: Reject Approver Account changes unless they are the Fiscal Officer
    Given   I am logged in as a KFS Fiscal Officer
    And     I start a General Error Correction document
    And     I add a source Accounting Line to the General Error Correction document with the following:
      | Chart Code   | IT      |
      | Number       | G003704 |
      | Object Code  | 1210    |
      | Amount       | 100     |
    And     I add a target Accounting Line to the General Error Correction document with the following:
      | Chart Code   | IT      |
      | Number       | G254700 |
      | Object Code  | 1210    |
      | Amount       | 100     |
    And     I blanket approve the General Error Correction document
    And     the General Error Correction document goes to FINAL
    And     I am logged in as a KFS Fiscal Officer
    And     I view the General Error Correction document
    And     I error correction the General Error Correction document
    Then    the error correction document goes to INITIATED