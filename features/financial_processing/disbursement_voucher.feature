Feature: Disbursement Voucher

  [KFSQA-681] Retiree should get a DV; People with Multiple Affiliations in PeopleSoft should only return one row.

  [KFSQA-682] Terminated Employees should not be searchable for a DV.

  [KFSQA-683] Active employee and former student should get a DV; People with Multiple Affiliations in PepleSoft should only return one row.

  [KFSQA-685] Active Staff, Former Student, and Alumnus should get a DV; People with Multiple Affiliations in PepleSoft should only return one row.

  [KFSQA-697] Disbursement Voucher Address Types to persist when copied to a new Disbursement Voucher.

  [KFSQA-684] DV business rule should not compare Payee's EmplID to DV Initiator's Entity/Principal ID.

  [KFSQA-708]

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

  @KFSQA-697 @tortoise
  Scenario: Disbursement Voucher Address Types to persist when copied to a new Disbursement Voucher
    Given I am logged in as a KFS User
    When  I start an empty Disbursement Voucher document with Payment to Vendor 4362-0
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704        |
      | Object Code  | 6540           |
      | Amount       | 25,000         |
      | Description  | DV03 Test....  |
    And   I submit the Disbursement Voucher document
    And   I am logged in as "djj1"
    And   I view the Disbursement Voucher document
    And   I approve the Disbursement Voucher document
    And   I am logged in as a Disbursement Manager
    And   I view the Disbursement Voucher document
    And   I approve the Disbursement Voucher document
    And   I am logged in as a KFS User
    And   I view the Disbursement Voucher document
    And   I copy a Disbursement Voucher document with Tax Address to persist

  @KFSQA-684 @smoke  @sloth
  Scenario: KFS User Initiates and Submits a Disbursement Voucher document with Payee's EmplID is the same as Initiator's Entity/Principal ID
# '1009867' is lk26's principanId/entityId, and arm2's employee_id.
    Given I am logged in as "LK26"
    When  I start an empty Disbursement Voucher document with Payment to Employee arm2
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6540               |
      | Amount       | 22341.11           |
      | Description  | Line Test Number 1 |
    And   I submit the Disbursement Voucher document
    And   the Disbursement Voucher document goes to ENROUTE

  @KFSQA-708 @hare
  Scenario: Email Not defaulting in Contact Information Tab
    Given   I am logged in as a KFS User for the DV document
    When    I start an empty Disbursement Voucher document
    Then    The eMail Address shows up in the Contact Information Tab