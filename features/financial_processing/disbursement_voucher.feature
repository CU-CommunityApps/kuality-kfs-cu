Feature: Disbursement Voucher Creation

  [KFSQA-681] Retiree should get a DV; People with Multiple Affiliations in PeopleSoft should only return one row.

  [KFSQA-682] Terminated Employees should not be searchable for a DV.

  [KFSQA-683] Active employee and former student should get a DV; People with Multiple Affiliations in PepleSoft should only return one row.

  [KFSQA-685] Active Staff, Former Student, and Alumnus should get a DV; People with Multiple Affiliations in PepleSoft should only return one row.

  [KFSQA-700] Allow usage of Revolving Fund (Petty Cash) DV Payment Types.

  @KFSQA-681 @smoke @sloth
  Scenario: KFS User Initiates and Submits a Disbursement Voucher document with Payment to Retiree
    Given I am logged in as a KFS User
    When  I start an empty Disbursement Voucher document
    And   I add the only payee with Payee Id map3 and Reason Code B to the Disbursement Voucher
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6100               |
      | Amount       | 23                 |
      | Description  | Line Test Number 1 |
    And   I submit the Disbursement Voucher document
    And   the Disbursement Voucher document goes to ENROUTE

  @KFSQA-682 @smoke @hare
  Scenario: KFS User Initiates a Disbursement Voucher document and Payee search should return no result with Terminated Employee
    Given I am logged in as a KFS User
    When  I start an empty Disbursement Voucher document
    And   I search for the payee with Terminated Employee msw13 and Reason Code B for Disbursement Voucher document with no result found

  @KFSQA-683 @smoke @sloth
  Scenario: KFS User Initiates and Submits a Disbursement Voucher document with Payment to Active employee and alumnus and former student
    Given I am logged in as a KFS User
    When  I start an empty Disbursement Voucher document
    And   I add the only payee with Payee Id vk76 and Reason Code B to the Disbursement Voucher
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6100               |
      | Amount       | 23                 |
      | Description  | Line Test Number 1 |
    And   I submit the Disbursement Voucher document
    And   the Disbursement Voucher document goes to ENROUTE

  @KFSQA-685 @smoke @sloth
  Scenario: KFS User Initiates and Submits a Disbursement Voucher document with Payment to Active Staff, Former Student, and Alumnus
    Given I am logged in as a KFS User
    When  I start an empty Disbursement Voucher document
    And   I add the only payee with Payee Id nms32 and Reason Code B to the Disbursement Voucher
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6100               |
      | Amount       | 23                 |
      | Description  | Line Test Number 1 |
    And   I submit the Disbursement Voucher document
    And   the Disbursement Voucher document goes to ENROUTE

  @KFSQA-700 @tortoise @wip
  Scenario: Disbursement Voucher document allow usage of Revolving Fund (Petty Cash) Payment Types
    Given I am logged in as a KFS User
    When  I start an empty Disbursement Voucher document with Payment to a Petty Cash Vendor
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704        |
      | Object Code  | 6540           |
      | Amount       | 10             |
      | Description  | DV12 Test....  |
    And   I save the Disbursement Voucher document
    And   I view the Disbursement Voucher document
    And   I change the Check Amount for the Disbursement Voucher document to 22.22
    And   I submit the Disbursement Voucher document
    And   the Disbursement Voucher document goes to ENROUTE
    And   I am logged in as "djj1"
    And   I view the Disbursement Voucher document
    And   I approve the Disbursement Voucher document
    And   the Disbursement Voucher document goes to FINAL

