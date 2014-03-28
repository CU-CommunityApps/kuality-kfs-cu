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

  [KFSQA-701] FO to Uncheck Special Handling and Approve the DV without getting error.

  [KFSQA-716] DV is holding on to the first payee ID for validations.

  [KFSQA-715] Disbursement Voucher foreign draft with non resident tax and workflow changes for Account, Object Code, and Amount.

  [KFSQA-689] Terminated employee but Alumnus should get a DV; People with Multiple Affiliations in PeopleSoft should only return one row.

  [KFSQA-677] Disbursement Voucher foreign draft with non resident tax, special handling, and workflow changes for Account, Object Code, and Amount.

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

  @KFSQA-701 @cornell @tortoise
  Scenario: FO to Uncheck Special Handling and Approve the DV without getting error
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document
    And   I add Vendor 12587-1 to the Disbursement Voucher document as the Payee using the vendor's REMIT address
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6540               |
      | Amount       | 25000              |
      | Description  | Line Test Number 1 |
    And   I fill out the Special Handling tab with the following fields:
      | Name         | Joe Lewis          |
      | Address 1    | Pick Up at Dept    |
    And   I add note 'This needs to be picked up in Person' to the Disbursement Voucher document
    And   I submit the Disbursement Voucher document
    And   the Disbursement Voucher document goes to ENROUTE
    And   I am logged in as "djj1"
    And   I view the Disbursement Voucher document
    And   I uncheck Special Handling on Payment Information tab
    And   I add note 'Check no longer needs to be picked up in person' to the Disbursement Voucher document
    When  the Special Handling is still unchecked on Payment Information tab
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE

  @KFSQA-716 @cornell @tortoise
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


  @KFSQA-715 @cornell @coral
  Scenario: Disbursement Voucher foreign draft with non resident tax and workflow changes for Account, Object Code, and Amount.
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document
    And   I add a DV foreign vendor 5328-1 with Reason Code B
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | 5193120            |
      | Object Code  | 6100               |
      | Amount       | 65000              |
      | Description  | Line Test Number 1 |
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | 5193125            |
      | Object Code  | 6100               |
      | Amount       | 35000              |
      | Description  | Line Test Number 2 |
    And   I change the Check Amount on the Payment Information tab to 100000
    And   I complete the Foreign Draft Tab
    And   I submit the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE
    When  I am logged in as "lc88"
    And   I view the Disbursement Voucher document
          # change to account not belong to 'lc88'
    And   I change the Account Number for Accounting Line 1 to G003704 on the Disbursement Voucher
    And   I approve the Disbursement Voucher document
    Then  I should get these error messages:
      | Existing accounting lines may not be updated to use Chart Code IT by user lc88.          |
      | Existing accounting lines may not be updated to use Account Number G003704 by user lc88. |
    # after the error, the acct line is not editable, so need to reload.  this seems an existing bug in 3.0.1 ? so, need to reload.
    And   I reload the Disbursement Voucher document
    And   I change the Account Amount for Accounting Line 1 to 60000 on the Disbursement Voucher
    And   I change the Account Amount for Accounting Line 2 to 40000 on the Disbursement Voucher
    And   I change the Account Object Code for Accounting Line 2 to 6540 on the Disbursement Voucher
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE
    When  I am logged in as a Tax Manager
    And   I select Disbursement Voucher document from my Action List
    And   I change the Account Amount for Accounting Line 1 to 55000 on the Disbursement Voucher
    And   I change the Account Amount for Accounting Line 2 to 45000 on the Disbursement Voucher
    And   I complete the Nonresident Alien Tax Tab and generate accounting line for Tax
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE
    And   I am logged in as a Disbursement Manager
    And   I select Disbursement Voucher document from my Action List
    And   I change the Account Object Code for Accounting Line 1 to 6430 on the Disbursement Voucher
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE
    And   I am logged in as a Disbursement Method Reviewer
    And   I select Disbursement Voucher document from my Action List
    And   I update a random Bank Account to Disbursement Voucher Document
    And   I change the Account Amount for Accounting Line 1 to 56000 on the Disbursement Voucher
    And   I change the Check Amount on the Payment Information tab to 71000
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to FINAL

  @KFSQA-689 @smoke @cornell @sloth
  Scenario: Terminated employee but Alumnus should get a DV; People with Multiple Affiliations in PeopleSoft should only return one row
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document
    And   I add the only payee with Payee Id rlg3 and Reason Code B to the Disbursement Voucher
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6100               |
      | Amount       | 23                 |
      | Description  | Line Test Number 1 |
    When  I submit the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE

  @KFSQA-677 @smoke @cornell @coral
  Scenario: Disbursement Voucher foreign draft with non resident tax, special handling, and workflow changes for Account, Object Code, and Amount.
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document
    And   I search and retrieve Payee 'McGill queens university press*' with Reason Code B
    And   I can NOT update the W-9/W-8BEN Completed field on the Payment Information tab
    And   I update the Postal Code on the Payment Information tab to H2X 2C6
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | 5193120            |
      | Object Code  | 6100               |
      | Amount       | 65000              |
      | Description  | Line Test Number 1 |
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | 5193125            |
      | Object Code  | 6100               |
      | Amount       | 35000              |
      | Description  | Line Test Number 2 |
    And   I change the Check Amount on the Payment Information tab to 100000
    And   I complete the Foreign Draft Tab
    And   I submit the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE
    When  I am logged in as "lc88"
    And   I view the Disbursement Voucher document
          # change to account not belong to 'lc88'
    And   I change the Account Number for Accounting Line 1 to 1278003 on the Disbursement Voucher
    And   I save the Disbursement Voucher document
    Then  I should get these error messages:
      | Existing accounting lines may not be updated to use Chart Code IT by user lc88.          |
      | Existing accounting lines may not be updated to use Account Number 1278003 by user lc88. |
    # after the error, the acct line is not editable, so need to reload.  this seems an existing bug in 3.0.1 ? so, need to reload.
    And   I reload the Disbursement Voucher document
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE
    When  I am logged in as a Tax Manager
    And   I view the Disbursement Voucher document
    And   I change the Account Amount for Accounting Line 1 to 55000 on the Disbursement Voucher
    And   I change the Account Amount for Accounting Line 2 to 45000 on the Disbursement Voucher
    And   I fill out the Special Handling tab with the following fields:
      | Name         | Patrick Roy            |
      | Address 1    | 127 Montreal Forum     |
      | Address 2    | Loge Seats             |
      | City         | Montreal, Quebec       |
      | Postal Code  | 23591                  |
      | Country      | Canada                 |
      # special handling needs a note
    And   I add note 'This needs to be picked up in Person' to the Disbursement Voucher document
    And   I complete the Nonresident Alien Tax Tab and generate accounting line for Tax
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE
    And   I am logged in as a Disbursement Manager
    And   I select Disbursement Voucher document from my Action List
    And   the Special Handling tab is open
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE
    And   I am logged in as a Disbursement Method Reviewer
    And   I select Disbursement Voucher document from my Action List
    And   I change the Account Amount for Accounting Line 1 to 56000 on the Disbursement Voucher
    And   I change the Check Amount on the Payment Information tab to 71000
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to FINAL


