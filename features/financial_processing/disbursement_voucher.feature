Feature: Disbursement Voucher Creation

  [KFSQA-681] Retiree should get a DV; People with Multiple Affiliations in PeopleSoft should only return one row.

  [KFSQA-682] Terminated Employees should not be searchable for a DV.

  @KFSQA-681 @smoke
  Scenario: KFS User Initiates and Submits a Disbursement Voucher document with Payment to Retiree
    Given I am logged in as a KFS User
    When  I start an empty Disbursement Voucher document
    And   I add the only payee with Retiree map3 and Reason Code B to the Disbursement Voucher
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704 |
      | Object Code  | 6100    |
      | Amount       | 23      |
    And   I submit the Disbursement Voucher document
    And   the Disbursement Voucher document goes to ENROUTE

  @KFSQA-682 @smoke @wip
  Scenario: KFS User Initiates a Disbursement Voucher document and Payee search should return no result with Terminated Employee
    Given I am logged in as a KFS User
    When  I start an empty Disbursement Voucher document
    And   I search for the payee with Terminated Employee msw13 and Reason Code B for Disbursement Voucher document with no result found