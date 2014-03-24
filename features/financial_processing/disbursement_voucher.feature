Feature: Disbursement Voucher

  [KFSQA-681] Retiree should get a DV; People with Multiple Affiliations in PeopleSoft should only return one row.

  [KFSQA-682] Terminated Employees should not be searchable for a DV.

  [KFSQA-683] Active employee and former student should get a DV; People with Multiple Affiliations in PepleSoft should only return one row.

  [KFSQA-685] Active Staff, Former Student, and Alumnus should get a DV; People with Multiple Affiliations in PepleSoft should only return one row.

  [KFSQA-697] Disbursement Voucher Address Types to persist when copied to a new Disbursement Voucher.

  [KFSQA-684] DV business rule should not compare Payee's EmplID to DV Initiator's Entity/Principal ID.

  [KFSQA-708]

  [KFSQA-709] Because it saves time, I as a KFS User should be able to
  initiate a Disbursement Voucher document with just the description.

  [KFSQA-700] Allow usage of Revolving Fund (Petty Cash) DV Payment Types.

  [KFSQA-710] Verify using current mileage rate based on dates.

  [KFSQA-716] DV is holding on to the first payee ID for validations.

  @KFSQA-681 @smoke @sloth
  Scenario: KFS User Initiates and Submits a Disbursement Voucher document with Payment to Retiree
    Given I am logged in as a KFS User
    And   I start an empty Disbursement Voucher document
    And   I add the only payee with Payee Id map3 and Reason Code B to the Disbursement Voucher
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6100               |
      | Amount       | 23                 |
      | Description  | Line Test Number 1 |
    When  I submit the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE

  @KFSQA-682 @smoke @hare
  Scenario: KFS User Initiates a Disbursement Voucher document and Payee search should return no result with Terminated Employee
    Given I am logged in as a KFS User
    When  I start an empty Disbursement Voucher document
    Then  I search for the payee with Terminated Employee msw13 and Reason Code B for Disbursement Voucher document with no result found

  @KFSQA-683 @smoke @sloth
  Scenario: KFS User Initiates and Submits a Disbursement Voucher document with Payment to Active employee and alumnus and former student
    Given I am logged in as a KFS User
    And   I start an empty Disbursement Voucher document
    And   I add the only payee with Payee Id vk76 and Reason Code B to the Disbursement Voucher
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6100               |
      | Amount       | 23                 |
      | Description  | Line Test Number 1 |
    When  I submit the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE

  @KFSQA-685 @smoke @sloth
  Scenario: KFS User Initiates and Submits a Disbursement Voucher document with Payment to Active Staff, Former Student, and Alumnus
    Given I am logged in as a KFS User
    And   I start an empty Disbursement Voucher document
    And   I add the only payee with Payee Id nms32 and Reason Code B to the Disbursement Voucher
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6100               |
      | Amount       | 23                 |
      | Description  | Line Test Number 1 |
    When  I submit the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE

  @KFSQA-697 @tortoise
  Scenario: Disbursement Voucher Address Types to persist when copied to a new Disbursement Voucher
    Given I am logged in as a KFS User
    And   I start an empty Disbursement Voucher document with Payment to Vendor 4362-0 and Reason Code B
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
    When  I view the Disbursement Voucher document
    Then  I copy a Disbursement Voucher document with Tax Address to persist

  @KFSQA-684 @smoke @sloth
  Scenario: KFS User Initiates and Submits a Disbursement Voucher document with Payee's EmplID is the same as Initiator's Entity/Principal ID
# '1009867' is lk26's principanId/entityId, and arm2's employee_id.
    Given I am logged in as "LK26"
    And   I start an empty Disbursement Voucher document with Payment to Employee arm2
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6540               |
      | Amount       | 22341.11           |
      | Description  | Line Test Number 1 |
    When  I submit the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE

  @KFSQA-708 @hare
  Scenario: Email Not defaulting in Contact Information Tab
    Given   I am logged in as a KFS User for the DV document
    When    I start an empty Disbursement Voucher document
    Then    The eMail Address shows up in the Contact Information Tab

  @KFSQA-709 @hare
  Scenario: KFS User Initiates a Disbursement Voucher document with only a description field
    Given I am logged in as a KFS User
    And   I start an empty Disbursement Voucher document with only the Description field populated
    When  I save the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to SAVED

  @KFSQA-700 @tortoise
  Scenario: Disbursement Voucher document allow usage of Revolving Fund (Petty Cash) Payment Types
    Given I am logged in as a KFS User
    And   I start an empty Disbursement Voucher document with Payment to a Petty Cash Vendor
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
    When  I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to FINAL

  @KFSQA-713 @sloth
  Scenario: Disbursement Voucher, Check, Wildcard payee search, Non Employee PP Travel Expenses
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document with Payment to Employee arm2
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6540               |
      | Amount       | 100                |
      | Description  | Line Test Number 1 |
    And   I add a Pre-Paid Travel Expense
    And   I submit the Disbursement Voucher document
    And   the Disbursement Voucher document goes to ENROUTE
    And   I am logged in as "djj1"
    And   I view the Disbursement Voucher document
    When  I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to FINAL

  @KFSQA-719 @sloth
  Scenario: Disbursement Voucher, Check, Wildcard payee search, Non Employee PP Travel Expenses
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document
    And   I add a random vendor payee to the Disbursement Voucher
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6540               |
      | Amount       | 100                |
      | Description  | Line Test Number 1 |
    And   I change the Check Amount for the Disbursement Voucher document to 100
    And   I submit the Disbursement Voucher document
    And   the Disbursement Voucher document goes to ENROUTE
    And   I am logged in as "djj1"
    And   I view the Disbursement Voucher document
    And   I approve the Disbursement Voucher document
    And   the Disbursement Voucher document goes to FINAL
    When  I copy the Disbursement Voucher document
    Then  the copied DV payment address equals the selected address

  @KFSQA-710 @sloth
  Scenario: Verify using current mileage rate based on dates
    Given I am logged in as a KFS User
    And   I start an empty Disbursement Voucher document with Payment to Vendor 5238-0 and Reason Code N
    When  I enter the Total Mileage of 245 in Travel Tab
    Then  the calculated Amount in the Travel Tab should match following Total Amount for each specified Start Date:
       | Start Date        | Total Amount      |
       | 02/04/2013        | 138.43            |
       | 05/06/2012        | 135.98            |
       | 08/06/2011        | 135.98            |
       | 03/01/2011        | 124.95            |
       | 04/05/2010        | 122.50            |

  @KFSQA-716 @cornell @tortoise @wip
  Scenario: DV payee can not be the same as initiator.
    Given I am logged in as "rlc56"
    And   I start an empty Disbursement Voucher document
    And   I search and retrieve a DV Payee ID rlc56 with Reason Code B
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6540               |
      | Amount       | 100                |
      | Description  | Line Test Number 1 |
    And   I submit the Disbursement Voucher document
    Then  I should get an error saying "Payee cannot be same as initiator."
    And   I should get an error saying "Payee ID 1774744 cannot be used when Originator has the same ID or name has been entered."
    And   I search and retrieve a DV Payee ID ccs1 with Reason Code B
    And   I search and retrieve a DV Payee ID rlc56 with Reason Code B
    And   I submit the Disbursement Voucher document
    Then  I should get an error saying "Payee cannot be same as initiator."
    And   I should get an error saying "Payee ID 1774744 cannot be used when Originator has the same ID or name has been entered."
    And   I search and retrieve a DV Payee ID ccs1 with Reason Code B
    And   I submit the Disbursement Voucher document
    And   the Disbursement Voucher document goes to ENROUTE
