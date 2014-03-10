Feature: Disbursement Voucher Creation

  [KFSQA-681] Retiree should get a DV; People with Multiple Affiliations in PeopleSoft should only return one row.

  @KFSQA-681 @wip
  Scenario: KFS User Initiates and Submits a Disbursement Voucher document with Payment to Retiree
    Given I am logged in as a KFS User
    When  I start an empty Disbursement Voucher document
    And   I search for Disbursement Voucher with Retiree map3 and Reason Code B
    And   I retrieve only One Result
    And   I add accounting line with AccountNumber 'G003704', ObjectCode '6100', Amount '23' to test
    And   I submit the Disbursement Voucher document
    And   the Disbursement Voucher document goes to ENROUTE
