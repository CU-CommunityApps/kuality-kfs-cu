Feature: PURAP manual entry greater than 500 but less than 25000

  [KFSQA-791] purap test manual entry, >$500, <$25000, external vendor and no wire

  [KFSQA-743] PURAP E2E PO - Unapproved (PURAP E2E-003b) - vendor not selected, <$100K

  @KFSQA-791 @purap @coral
Scenario: PURAP manual >$500, <$25000 external vendor no wire
  Given I login as a PURAP eSHop user
  And I create the Requisition document with:
   | Vendor Number       | 4471-0   |
   | Item Quantity       | 9.9      |
   | Item Cost           | 1000     |
   | Item Commodity Code | 10121800 |
   | Account Number      | 1093603  |
   | Object Code         | 6540     |
   | Percent             | 100      |
  And I calculate my Requisition document
  And I submit the Requisition document
  And the requisition document goes to ENROUTE
  And I switch to the user with the next Pending Action in the Route Log for the Requisition document
  And I view the Requisition document on my action list
  And I approve the Requisition document
  And the Requisition document goes to FINAL
  And I am logged in as a Purchasing Processor
  #<ml284>
  And I submit a Contract Manager Assignment of '10' for the Requisition
  And I login as a PURAP eSHop user
  #der9
  And I view the Requisition document from the Requisitions search
  And I am logged in as a PURAP Contract Manager
  #mss7
  And I retrieve the Requisition document
  And the View Related Documents Tab PO Status displays
  And I Complete Selecting Vendor 27015-0
  And I enter a Vendor Choice of 'Lowest Price'
  And I calculate and verify the GLPE tab
  And I submit the document
  Then in Pending Action Requests an FYI is sent to FO and Initiator
  And the Purchase Order document status is 'FINAL'
  #using services getting 'error occurred sending cxml' instead of 'Open'
#  And the Purchase Order Doc Status equals 'Open'

  @KFSQA-743 @purap @cornell @coral
  Scenario: PURAP E2E PO - Unapproved (PURAP E2E-003b) - vendor not selected, <$100K
    Given I login as a PURAP eSHop user
    And   I create the Requisition document with:
      | Vendor Number       |          |
      | Item Quantity       | 18       |
      | Item Cost           | 1000     |
      | Item Commodity Code | 12142203 |
      | Item Catalog Number | 10101157 |
      | Item Description    | ANIM     |
      | Account Number      | R589854  |
      | Object Code         | 6540     |
      | Percent             | 100      |
    And   I add an Attachment to the Requisition document
    And   I enter Delivery Instructions and Notes to Vendor
    And   I calculate my Requisition document
    And   I submit the Requisition document
    And   the requisition document goes to ENROUTE
    And   I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And   I view the Requisition document on my action list
    And   I approve the Requisition document
    And   the Requisition document goes to ENROUTE
    # commodity reviewer
    And   I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And   I view the Requisition document on my action list
    And   I approve the Requisition document
    And   the Requisition document goes to FINAL
    And   I am logged in as a Purchasing Processor
    And   I submit a Contract Manager Assignment of '10' for the Requisition
    And I am logged in as a PURAP Contract Manager
    And I retrieve the Requisition document
    And   the View Related Documents Tab PO Status displays
    And   the Purchase Order Number is unmasked
    And   I Complete Selecting Vendor 27015-0
    And I enter a Vendor Choice of 'Lowest Price'
    And I calculate and verify the GLPE tab
    And   I submit the Purchase Order document
    And   the Purchase Order document goes to FINAL
    Then  in Pending Action Requests an FYI is sent to FO and Initiator
    And   the Purchase Order Doc Status is Open


  @KFSQA-763 @E2E @MultiDay @PO @PREQ @REQS @Routing @PO @auto-approve-preq-job @cornell @coral @wip
  Scenario: PURAP E2E-004a PREQ - Manual Entry, >$500 Auto Approve
    Given I login as a PURAP eSHop user
    And I create the Requisition document with:
      | Item Quantity       | 4.9      |
      | Item Cost           | 1000     |
      | Item Commodity Code | 10121800 |
      | Item Catalog Number | 14111703 |
      | Item Description    | ANIM     |
      | Account Number      | 1093603  |
      | Object Code         | 6540     |
      | Percent             | 100      |
    And I add an Attachment to the Requisition document
    And I enter Delivery Instructions and Notes to Vendor
    And I calculate my Requisition document
    And I submit the Requisition document
    And the Requisition document goes to ENROUTE
    And I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And I view the Requisition document on my action list
    And I approve the Requisition document
    And the Requisition document goes to FINAL
    And I am logged in as a Purchasing Processor
    And I submit a Contract Manager Assignment of '10' for the Requisition
    And I am logged in as a PURAP Contract Manager
    And I retrieve the Requisition document
    And the View Related Documents Tab PO Status displays
    And the Purchase Order Number is unmasked
    And I Complete Selecting Vendor 27015-0
    And I enter a Vendor Choice of 'Lowest Price'
    And I calculate and verify the GLPE with amount 4,900.00
    And I submit the Purchase Order document
    And the Purchase Order document goes to FINAL
    Then in Pending Action Requests an FYI is sent to FO and Initiator
    And the Purchase Order Doc Status is Open
    Given I am logged in as "db18"
    And   I visit the "e-SHOP" page
    And   I view the Purchase Order document via e-SHOP
    Then  the Document Status displayed 'Completed'
    And   the Delivery Instructions displayed equals what came from the PO
    And   the Attachments for Supplier came from the PO
    Given I login as a Accounts Payable Processor to create a PREQ
    And   I fill out the PREQ initiation page and continue
    And   I change the Remit To Address
    And   I enter the Qty Invoiced and calculate
    And   I enter a Pay Date
    And   I attach an Invoice Image
    And   I calculate PREQ
    And   I submit the Payment Request document
    And   the Payment Request document goes to ENROUTE
    Given I am logged in as a KFS Operations
    And   I run Auto Approve PREQ
    Given I login as a Accounts Payable Processor to create a PREQ
    And   the Payment Request document goes to FINAL
    And   the Payment Request Doc Status is Auto-Approved
    # TODO test do not commit
    And   I run Poster