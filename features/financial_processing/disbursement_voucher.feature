Feature: Disbursement Voucher Creation

  [KFSQA-681] Retiree should get a DV; People with Multiple Affiliations in PeopleSoft should only return one row.

  [KFSQA-709] Because it saves time, I as a KFS User should be able to
  initiate a Disbursement Voucher document with just the description.

  @KFSQA-681
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

  @KFSQA-709 @wip
  Scenario: KFS User Initiates a Disbursement Voucher document with only a description field
    Given I am logged in as a KFS User
    When  I start an empty Disbursement Voucher document with only the Description field populated
    And   I save the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to SAVED
