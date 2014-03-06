Feature: Disbursement Voucher Creation

  [KFSQA-709] Because it saves time, I as a KFS User should be able to
  initiate a Disbursement Voucher document with just the description.

  @KFSQA-709 @wip
  Scenario: KFS User Initiates a Disbursement Voucher document with only a description field
    Given I am logged in as a KFS User
    When  I save a Disbursement Voucher document with only the Description field populated
    Then  the Disbursement Voucher document goes to SAVED
