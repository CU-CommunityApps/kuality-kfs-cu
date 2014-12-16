Feature: Disbursement Voucher

  [KFSQA-681] Retiree should get a DV; People with Multiple Affiliations in PeopleSoft should only return one row.

  [KFSQA-682] Terminated Employees should not be searchable for a DV.

  [KFSQA-683] Active employee and former student should get a DV; People with Multiple Affiliations in PepleSoft should only return one row.

  [KFSQA-685] Active Staff, Former Student, and Alumnus should get a DV; People with Multiple Affiliations in PepleSoft should only return one row.

  [KFSQA-697] Disbursement Voucher Address Types to persist when copied to a new Disbursement Voucher.

  [KFSQA-684] DV business rule should not compare Payee's EmplID to DV Initiator's Entity/Principal ID.

  [KFSQA-708]

  [KFSQA-699] Retrieve DV payee with NetID

  [KFSQA-709] Because it saves time, I as a KFS User should be able to
  initiate a Disbursement Voucher document with just the description.

  [KFSQA-700] Allow usage of Revolving Fund (Petty Cash) DV Payment Types.

  [KFSQA-717] Address entered directly on DV is not saved when doc is submitted

  [KFSQA-710] Verify using current mileage rate based on dates.

  [KFSQA-701] FO to Uncheck Special Handling and Approve the DV without getting error.

  [KFSQA-716] DV is holding on to the first payee ID for validations.

  [KFSQA-715] Disbursement Voucher foreign draft with non resident tax and workflow changes for Account, Object Code, and Amount.

  [KFSQA-689] Terminated employee but Alumnus should get a DV; People with Multiple Affiliations in PeopleSoft should only return one row.

  [KFSQA-677] Disbursement Voucher foreign draft with non resident tax, special handling, and workflow changes for Account, Object Code, and Amount.

  [KFSQA-711] Foreign Check and NRA Tax GLPE. As a KFS User I will pay vendors in foreign monies if requested , because
              Cornell does business outside the United States. I also want to change the document during workflow. as
              reviewers may need to change the document. Object Code, and Amount.

  [KFSQA-702] FO can do a search on the account and verify the payee id still displays on the DV. Approve it to final.

  [KFSQA-721] Preclude Revolving Vendors getting a B Payment Reason Code.

  [KFSQA-705] Payee should not be able to approve (as Fiscal Officer) a payment to themselves.

  @KFSQA-681 @smoke @sloth @solid
  Scenario: KFS User Initiates and Submits a Disbursement Voucher document with Payment to Retiree
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document
    And   I add a Retiree as payee and Reason Code B to the Disbursement Voucher
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6100               |
      | Amount       | 23                 |
      | Description  | Line Test Number 1 |
    When  I submit the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE

  @KFSQA-682 @smoke @hare @solid
  Scenario: KFS User Initiates a Disbursement Voucher document and Payee search should return no result with Terminated Employee
    Given I am logged in as a KFS User for the DV document
    When  I start an empty Disbursement Voucher document
    Then  I search for the payee with Terminated Employee and Reason Code B for Disbursement Voucher document with no result found

  @KFSQA-683 @smoke @sloth
  Scenario: KFS User Initiates and Submits a Disbursement Voucher document with Payment to Active employee and alumnus and former student
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document
    And   I add an Active Employee, Former Student, and Alumnus as payee and Reason Code B to the Disbursement Voucher
    #TODO vk76 should be looked up, not hard coded
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6100               |
      | Amount       | 23                 |
      | Description  | Line Test Number 1 |
    When  I submit the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE

  @KFSQA-685 @smoke @sloth @solid
  Scenario: KFS User Initiates and Submits a Disbursement Voucher document with Payment to Active Staff, Former Student, and Alumnus
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document
    And   I add an Active Staff, Former Student, and Alumnus as payee and Reason Code B to the Disbursement Voucher
    #TODO map3 should be looked up, not hard coded
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6100               |
      | Amount       | 23                 |
      | Description  | Line Test Number 1 |
    When  I submit the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE

  @KFSQA-697 @DV @tortoise
  Scenario: Disbursement Voucher Address Types to persist when copied to a new Disbursement Voucher
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document with Payment to Vendor 4362-0 and Reason Code B
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704        |
      | Object Code  | 6540           |
      | Amount       | 25,000         |
      | Description  | DV03 Test....  |
    And   I submit the Disbursement Voucher document
    #TODO this should be just follow the route log
    And   I switch to the user with the next Pending Action in the Route Log for the Disbursement Voucher document
    And   I view the Disbursement Voucher document
    And   I approve the Disbursement Voucher document
    And   I am logged in as a Disbursement Manager
    And   I view the Disbursement Voucher document
    And   I approve the Disbursement Voucher document
    And   I am logged in as a KFS User for the DV document
    When  I view the Disbursement Voucher document
    Then  I copy a Disbursement Voucher document with Tax Address to persist

  @KFSQA-684 @smoke @sloth @solid
  Scenario: KFS User Initiates and Submits a Disbursement Voucher document with Payee's EmplID is the same as Initiator's Entity/Principal ID
# '1009867' is lk26's principanId/entityId, and arm2's employee_id.
    Given I am logged in as "LK26"
    #TODO This is a unique case that initiator's principalid=payee's employeeid.  so, keep it hard coded
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
    Then    the eMail Address shows up in the Contact Information Tab

  @KFSQA-699 @Create @DV @Search @hare @cornell
  Scenario: Retrieve a DV Payee with their NetID (Cornell Modification)
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document
    # it was using 'as57' which is a 'retiree'
    And   I add a Retiree as payee and Reason Code B to the Disbursement Voucher
    When  the Payee Name should match
    Then  the eMail Address shows up in the Contact Information Tab

  @KFSQA-709 @DV @hare
  Scenario: KFS User Initiates a Disbursement Voucher document with only a description field
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document with only the Description field populated
    When  I save the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to SAVED

  @KFSQA-700 @DV @tortoise
  Scenario: Allow usage of Revolving Fund (Petty Cash) DV Payment Types.
    Given I am logged in as a KFS User for the DV document
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
    And   I switch to the user with the next Pending Action in the Route Log for the Disbursement Voucher document
    And   I view the Disbursement Voucher document
    When  I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to FINAL

  @KFSQA-713 @Create @DV @MultiDay @Search @Travel @sloth
  Scenario: Disbursement Voucher, Check, Wildcard payee search, Non Employee PP Travel Expenses, part 1
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document
    And   I search and retrieve Payee 'McGill queens university press*' with Reason Code P
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G254700            |
      | Object Code  | 6750               |
      | Amount       | 100                |
      | Description  | Line Test Number 1 |
    And   I add a Pre-Paid Travel Expense
    And   I submit the Disbursement Voucher document
    And   the Disbursement Voucher document goes to ENROUTE
    And   I switch to the user with the next Pending Action in the Route Log for the Disbursement Voucher document
    And   I view the Disbursement Voucher document
    When  I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE
    When  I am logged in as a Tax Manager
    And   I view the Disbursement Voucher document
    And   I complete the Nonresident Alien Tax Tab and generate accounting line for Tax
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to FINAL

  @KFSQA-719 @DV @sloth
  Scenario: Disbursement Voucher Address when copied to another DV persists
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
    And   I switch to the user with the next Pending Action in the Route Log for the Disbursement Voucher document
    And   I view the Disbursement Voucher document
    And   I approve the Disbursement Voucher document
    And   the Disbursement Voucher document goes to FINAL
    When  I copy the Disbursement Voucher document
    Then  the copied DV payment address equals the selected address

  @KFSQA-717 @DV @Create @Search @tortoise
  Scenario: Disbursement Voucher document allow usage of Revolving Fund (Petty Cash) Payment Types
    Given I am logged in as a KFS User for the DV document
    When  I start an empty Disbursement Voucher document
    And   I add a random payee to the Disbursement Voucher
    And   I change the Payee address
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704        |
      | Object Code  | 6540           |
      | Amount       | 10             |
      | Description  | DV12 Test....  |
    And   I change the Check Amount for the Disbursement Voucher document to 100
    And   I submit the Disbursement Voucher document
    When  the Disbursement Voucher document goes to ENROUTE
    Then  The Payment Information address equals the overwritten address information

  @KFSQA-710 @DV @sloth
  Scenario: Verify using current mileage rate based on dates
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document with Payment to Vendor 5238-0 and Reason Code N
    #TODO how to abstract this?
    When  I enter the Total Mileage of 245 in Travel Tab
    Then  the calculated Amount in the Travel Tab should match following Total Amount for each specified Start Date:
       | Start Date        | Total Amount      |
       | 02/04/2013        | 138.43            |
       | 05/06/2012        | 135.98            |
       | 08/06/2011        | 135.98            |
       | 03/01/2011        | 124.95            |
       | 04/05/2010        | 122.50            |

  @KFSQA-701 @DV @cornell @tortoise
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
    And   I switch to the user with the next Pending Action in the Route Log for the Disbursement Voucher document
    And   I view the Disbursement Voucher document
    And   I uncheck Special Handling on Payment Information tab
    And   I add note 'Check no longer needs to be picked up in person' to the Disbursement Voucher document
    When  the Special Handling is still unchecked on Payment Information tab
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE

  @KFSQA-716 @DV @cornell @tortoise
  Scenario: DV payee can not be the same as initiator.
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document
    And   I search and retrieve Initiator as DV Payee with Reason Code B
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6540               |
      | Amount       | 100                |
      | Description  | Line Test Number 1 |
    And   I submit the Disbursement Voucher document
    Then  I should get an error saying "Payee cannot be same as initiator."
    And   I should get payee id error
    And   I search and retrieve a DV Payee other than Initiator with Reason Code B
    And   I search and retrieve Initiator as DV Payee with Reason Code B
    And   I submit the Disbursement Voucher document
    Then  I should get an error saying "Payee cannot be same as initiator."
    And   I should get payee id error
    And   I search and retrieve a DV Payee other than Initiator with Reason Code B
    And   I submit the Disbursement Voucher document
    And   the Disbursement Voucher document goes to ENROUTE


  @KFSQA-715 @DV @cornell @coral
  Scenario: Disbursement Voucher foreign draft with non resident tax and workflow changes for Account, Object Code, and Amount.
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document
    And   I add a DV foreign vendor 5328-1 with Reason Code B
    #TODO how to calculate/lookup the foreign vendor
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
    When  I switch to the user with the next Pending Action in the Route Log for the Disbursement Voucher document
    And   I view the Disbursement Voucher document
          # change to account not belong to 'lc88'
    And   I change the Account Number for Accounting Line 1 to G003704 on the Disbursement Voucher
    And   I approve the Disbursement Voucher document
    Then  I should get error for Accounting Line 1
    # after the error, the acct line is not editable, so need to reload.  this seems an existing bug in 3.0.1 ? so, need to reload.
    And   I reload the Disbursement Voucher document
    And   I change the Account Amount for Accounting Line 1 to 60000 on the Disbursement Voucher
    And   I change the Account Amount for Accounting Line 2 to 40000 on the Disbursement Voucher
    And   I change the Account Object Code for Accounting Line 2 to 6540 on the Disbursement Voucher
    #TODO FIX hard coded object ccode
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE
    When  I am logged in as a Tax Manager
    And   I select Disbursement Voucher document from my Action List
    And   I change the Account Amount for Accounting Line 1 to 55000 on the Disbursement Voucher
    And   I change the Account Amount for Accounting Line 2 to 45000 on the Disbursement Voucher
    And   I complete the Nonresident Alien Tax Tab and generate accounting line for Tax
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE
    And   I switch to the user with the next Pending Action in the Route Log for the Disbursement Voucher document
    And   I select Disbursement Voucher document from my Action List
    And   I change the Account Object Code for Accounting Line 1 to 6430 on the Disbursement Voucher
    #TODO FIX hard coded object ccode
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
    And   I add an Inactive Employee and Alumnus as payee and Reason Code B to the Disbursement Voucher
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
    When  I switch to the user with the next Pending Action in the Route Log for the Disbursement Voucher document
    And   I view the Disbursement Voucher document
          # change to account not belong to 'lc88'
    And   I change the Account Number for Accounting Line 1 to 1278003 on the Disbursement Voucher
    And   I save the Disbursement Voucher document
    Then  I should get error for Accounting Line 1
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
    And   I switch to the user with the next Pending Action in the Route Log for the Disbursement Voucher document
    And   I select Disbursement Voucher document from my Action List
    And   I change the Account Amount for Accounting Line 1 to 56000 on the Disbursement Voucher
    And   I change the Check Amount on the Payment Information tab to 71000
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to FINAL

  @KFSQA-711 @DV @E2E @cornell @coral
  Scenario: Foreign Check and NRA Tax GLPE
    Given I am logged in as a Vendor Initiator
    When  I edit a Vendor with Vendor Number 5328-1
    And   I add an Address to a Vendor with following fields:
      | Address Type   | RM - REMIT        |
      | Address 1      | 3430 McTavish St  |
      | Address 2      | Pick Me           |
      | City           | Montreal, Quebec  |
      | Zip Code       | H3A_1X9           |
      | Country        | Canada            |
    And   I submit the Vendor document
    And   the Vendor document goes to ENROUTE
    And   I am logged in as a Vendor Reviewer
    And   I select Vendor document from my Action List
    And   I approve the Vendor document
    And   the Vendor document goes to FINAL
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document
    And   I search and retrieve DV foreign vendor 5328-1 with Reason Code B
    And   I select the added Remit Address
    And   I complete the Foreign Draft Tab
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6540               |
      | Amount       | 61000              |
      | Description  | Line Test Number 1 |
    And   I submit the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE
    When  I switch to the user with the next Pending Action in the Route Log for the Disbursement Voucher document
    And   I view the Disbursement Voucher document
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE
    When  I am logged in as a Tax Manager
    And   I view the Disbursement Voucher document
    And   I complete the Nonresident Alien Tax Tab and generate accounting line for Tax
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE
    And   I switch to the user with the next Pending Action in the Route Log for the Disbursement Voucher document
    And   I view the Disbursement Voucher document
    Then  the GLPE contains Taxes withheld amount of 18300.00
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE
    When  I am logged in as a Disbursement Method Reviewer
    And   I view the Disbursement Voucher document
    And   I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to FINAL

  @KFSQA-702 @DV @cornell @tortoise
  Scenario:  FO can do a search on the account and verify the payee id still displays on the DV. Approve it to final.
    Given I am logged in as a KFS User for the DV document
    # 21541-0 is slow to change doc status to 'final' so use '41473'
    And   I start an empty Disbursement Voucher document with Payment to Vendor 41473-0 and Reason Code K
    And   I save the Disbursement Voucher document
    And   I view the Disbursement Voucher document
    And   I change the Check Amount on the Payment Information tab to 22.22
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704        |
      | Object Code  | 6540           |
      | Amount       | 22.22          |
      | Description  | DV13 Test....  |
    And   I submit the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE
    And   I switch to the user with the next Pending Action in the Route Log for the Disbursement Voucher document
    And   I view the Disbursement Voucher document
    When  I search Account and cancel on Account Lookup
    Then  the Payee Id still displays on Disbursement Voucher
    When  I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to FINAL

  @KFSQA-721 @DV @tortoise @cornell
  Scenario: Preclude Revolving Vendors getting a B Payment Reason Code
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document with Payment to a Petty Cash Vendor
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704             |
      | Object Code  | 6540                |
      | Amount       | 10                  |
      | Description  | Line Test Number 1  |
    And   I save the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to SAVED
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document
    And   I search Petty Cash vendor 41473-0 with Reason Code B
    Then  I should get a Reason Code error saying "Employees Students Alumni, Vendor and Refund & Reimbursements Only are the only valid Payee Types for Payment Reason B - Reimbursement for Out-of-Pocket Expenses."
    And   I change Reason Code to K for Payee search and select
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704             |
      | Object Code  | 6540                |
      | Amount       | 10                  |
      | Description  | Line Test Number 1  |
    And   I submit the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE


  @KFSQA-705 @DV @SeparationOfDuties @tortoise @cornell
  Scenario: Payee should not be able to approve (as Fiscal Officer) a payment to themselves
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document
    And   I search and retrieve the Fiscal Officer of account G254700 as DV Payee with Reason Code B
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G254700             |
      | Object Code  | 6100                |
      | Amount       | 10                  |
      | Description  | Line Test Number 1  |
    And   I submit the Disbursement Voucher document
    And   the Disbursement Voucher document goes to ENROUTE
    And   I am logged in as Payee of the Disbursement Voucher
    And   I view the Disbursement Voucher document
    When  I approve the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE

