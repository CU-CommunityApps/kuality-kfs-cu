Feature: Auxiliary Voucher

  [KFSQA-622] Change reversal date of Auxiliary Voucher, I want to create an Auxiliary Voucher and change the reversal date.

  Scenario: Auxiliary Voucher allows change of reversal date; GLPE data persists to General Ledger.

    Given   I am logged in as a KFS User
    And      I create the Auxiliary Voucher document with a Reversal Date
#    And      I select an Accounting Period and Auxiliary Voucher Type
#    And      I select a Reversal Date
    And      I add a "Debit" Accounting Line with:
      | account number |  A012000 |
      | object code    |  6540    |
      | debit          |  10.11   |
    And      I add a "Credit" Accounting Line with:
      | account number |  G254700 |
      | object code    |  6540    |
      | credit         |  10.11   |
    And      I submit the Auxiliary Voucher document
    Then     the Auxiliary Voucher goes to ENROUTE
    When   I retrieve from the Pending Action Requests the Future Fiscal Officers**
#    And      I both approve this document and it goes to final
    And      I am logged in as a KFS Administrator
#    And      I Run the Nightly Process
    When   I lookup the Document ID in the Poster Reversal Table
    Then    The Accounting Line equals the Poster Reversal Table Entry