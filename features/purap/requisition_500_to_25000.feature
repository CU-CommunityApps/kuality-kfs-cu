Feature: Purap Preq Building Blocks

  [purap-4f] purap test manual entry, >$500, <$25000, external vendor and no wire

  [KFSQA-743] PURAP E2E PO - Unapproved (PURAP E2E-003b) - vendor not selected, <$100K

  [KFSQA-763] PURAP E2E-004a PREQ - Manual Entry, >$500 Auto Approve

  [KFSQA-765] PURAP E2E PO - Unapproved (PURAP E2E-003b) - vendor not selected, <$100K

  [KFSQA-764] PURAP E2E-004b PREQ - Manual Entry, >$500, <$5000, External Vendor, No Wire

  #PURAP TEST IN PROGRESS JUST UPLOADING TO ADD FILES SO OTHERS CAN WORK ON PURAP
@pending @purap
Scenario: Purap Preq building block 4f
  Given I login as a KFS user to create an REQS
  And I create the Requisition document with:
   | vendor number       | 4471-0   |
   | item quanity        | 9.9      |
   | item cost           | 1000     |
   | item commodity code | 10121800 |
   | account number      | 1093603  |
   | object code         | 6540     |
   | percent             | 100      |
  And I calculate my Requisition document
  And I submit the Requisition document
  And the requisition document goes to ENROUTE
  And I switch to the user with the next Pending Action in the Route Log for the Requisition document
  And I view the Requisition document on my action list
  And I approve the Requisition document
  And the Requisition document goes to FINAL
  #skip req for testing
        #PO
  And I am logged in as a Purchasing Processor
  #<ml284>
  And I submit a Contract Manager Assignment of '10' for the Requisition
  #10
#REQS/PO STATUS CHECK for ********
#  And I login as a KFS user to create an REQS
  #der9
#  And The REQS Status is
  #UNNAPPROVED
  And I am logged in as a Contract Manager
  #mss7
  And I retrieve the Requisition
  And the View Related Documents Tab PO Status displays UNAPPROVED
  #UNAPPROVED
#  And I Select the PO
  And the Purchase Order Number is unmasked
  And I Complete Selecting Vendor 27015-0
  #27015-0
  And I enter a Vendor Choice
  #LOWESt PRICE
  And I calculate and verify the GLPE with amount 9,900.00
  #PARM
#  And I submit the PO eDoc Status is
  And I submit the Purchase Order document
  And the Purchase Order document goes to FINAL
  #FINAL
#PO APPROVAL OPTIONS
#WRAP UP PROCESSES AND TESTS
  Then In Pending Action Requests an FYI is sent to FO and Initiator
  #jaf54 and der9
#  And The PO eDoc Status is
  #FINAL
  And the Purchase Order Doc Status is Open
  #OPEN


  @KFSQA-743 @pending @purap @cornell @coral
  Scenario: PURAP E2E PO - Unapproved (PURAP E2E-003b) - vendor not selected, <$100K
    Given I login as a KFS user to create an REQS
    And   I create the Requisition document with:
      | vendor number       |          |
      | item quanity        | 18       |
      | item cost           | 1000     |
      | item commodity code | 12142203 |
      | item catalog number | 10101157 |
      | item description    | ANIM     |
      | account number      | R589854  |
      | object code         | 6540     |
      | percent             | 100      |
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
    And   I am logged in as a Contract Manager
    And   I retrieve the Requisition
    And   the View Related Documents Tab PO Status displays UNAPPROVED
    And   the Purchase Order Number is unmasked
    And   I Complete Selecting Vendor 27015-0
    And   I enter a Vendor Choice
    And   I calculate and verify the GLPE with amount 18,000.00
    And   I submit the Purchase Order document
    And   the Purchase Order document goes to FINAL
    Then  In Pending Action Requests an FYI is sent to FO and Initiator
    And   the Purchase Order Doc Status is Open


  @KFSQA-763 @pending @purap @cornell @coral
  Scenario: PURAP E2E-004a PREQ - Manual Entry, >$500 Auto Approve
    Given I login as a KFS user to create an REQS
    And I create the Requisition document with:
      | vendor number       |          |
      | item quanity        | 4.9      |
      | item cost           | 1000     |
      | item commodity code | 10121800 |
      | item catalog number | 14111703 |
      | item description    | ANIM     |
      | account number      | 1093603  |
      | object code         | 6540     |
      | percent             | 100      |
    And I add an Attachment to the Requisition document
    And I enter Delivery Instructions and Notes to Vendor
    And I calculate my Requisition document
    And I submit the Requisition document
    And the requisition document goes to ENROUTE
    And I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And I view the Requisition document on my action list
    And I approve the Requisition document
    And the Requisition document goes to FINAL
    And I am logged in as a Purchasing Processor
    And I submit a Contract Manager Assignment of '10' for the Requisition
    And I am logged in as a Contract Manager
    And I retrieve the Requisition
    And the View Related Documents Tab PO Status displays UNAPPROVED
    And the Purchase Order Number is unmasked
    And I Complete Selecting Vendor 27015-0
    And I enter a Vendor Choice
    And I calculate and verify the GLPE with amount 4,900.00
    And I submit the Purchase Order document
    And the Purchase Order document goes to FINAL
    Then In Pending Action Requests an FYI is sent to FO and Initiator
    And the Purchase Order Doc Status is Open
    Given I am logged in as "db18"
    And   I visit the "e-SHOP" page
    And   I Search Documents retrieve the PO
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
    Given I am logged in as a KFS Operator
    And   I run Auto Approve PREQ
    Given I login as a Accounts Payable Processor to create a PREQ
    And   the Payment Request document goes to FINAL
    And   the Payment Request Doc Status is Auto-Approved

  @KFSQA-765 @pending @purap @cornell @coral
  Scenario: PURAP E2E-004a PREQ - Manual Entry, >$500 Auto Approve
    Given I login as a KFS user to create an REQS
    And I create the Requisition document with:
      | vendor number       |          |
      | item quanity        | 4.9      |
      | item cost           | 1000     |
      | item commodity code | 12142203 |
      | item catalog number | 10101157 |
      | item description    | ANIM     |
      | account number      | 1093603  |
      | object code         | 6540     |
      | percent             | 100      |
    And  I select the Payment Request Positive Approval Required
    And I add an Attachment to the Requisition document
    And I enter Delivery Instructions and Notes to Vendor
    And I calculate my Requisition document
    And I submit the Requisition document
    And the requisition document goes to ENROUTE
    And I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And I view the Requisition document on my action list
    And I approve the Requisition document
    And the requisition document goes to ENROUTE
    # commodity reviewer
    And I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And I view the Requisition document on my action list
    And I approve the Requisition document
    And the Requisition document goes to FINAL
    And I am logged in as a Purchasing Processor
    And I submit a Contract Manager Assignment of '10' for the Requisition
    And I am logged in as a Contract Manager
    And I retrieve the Requisition
    And the View Related Documents Tab PO Status displays UNAPPROVED
    And the Purchase Order Number is unmasked
    And I Complete Selecting Vendor 39210-0
    And I enter a Vendor Choice
    And I calculate and verify the GLPE with amount 4,900.00
    And I submit the Purchase Order document
    And the Purchase Order document goes to FINAL
    Then In Pending Action Requests an FYI is sent to FO and Initiator
    And the Purchase Order Doc Status is Open
    Given I am logged in as "db18"
    And   I visit the "e-SHOP" page
    And   I Search Documents retrieve the PO
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
    And I switch to the user with the next Pending Action in the Route Log for the Payment Request document
    And I view the Payment Request document on my action list
    And I approve the Payment Request document
    And   the Payment Request document goes to ENROUTE
    And I switch to the user with the next Pending Action in the Route Log for the Payment Request document
    And I view the Payment Request document on my action list
    And I update the Tax Tab
    # need to calculate tax related data
    And   I calculate PREQ
    And I approve the Payment Request document
    And the Payment Request document goes to FINAL
    And   the Payment Request Doc Status is Department-Approved
    And I verified the GLPE on Payment Request page with the following:
      | line        | account number    | object code | balance type | object type  | amount    | dorc |
      | 1           | 1093603           | 6540        | EX           | EX           | 4,900.00  | C    |
      | 2           | 1093603           | 3110        | EX           | FB           | 4,900.00  | D    |
      | 3           | 1093603           | 6540        | AC           | EX           | 4,900.00  | D    |
      | 4           | 1093603           | 2900        | AC           | LI           | 4,900.00  | C    |


  @KFSQA-764 @pending @purap @cornell @coral @wip
  Scenario: PURAP E2E-004a PREQ - Manual Entry, >$500 Auto Approve
    Given I login as a KFS user to create an REQS
    And I create the Requisition document with:
      | vendor number       |          |
      | item quanity        | 2.75     |
      | item cost           | 1000     |
      | item commodity code | 14111703 |
      | item catalog number |          |
      | item description    | ANIM     |
      | account number      | 1093603  |
      | object code         | 6540     |
      | percent             | 100      |
    And  I select the Payment Request Positive Approval Required
    And I add an Attachment to the Requisition document
    And I enter Delivery Instructions and Notes to Vendor
    And I calculate my Requisition document
    And I submit the Requisition document
    And the requisition document goes to ENROUTE
    And I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And I view the Requisition document on my action list
    And I approve the Requisition document
    And the requisition document goes to FINAL
    And I am logged in as a Purchasing Processor
    And I submit a Contract Manager Assignment of '10' for the Requisition
    And I am logged in as a Contract Manager
    And I retrieve the Requisition
    And the View Related Documents Tab PO Status displays UNAPPROVED
    And the Purchase Order Number is unmasked
    And I Complete Selecting Vendor 27015-0
    And I enter a Vendor Choice
    And I calculate and verify the GLPE with amount 2,750.00
    And I submit the Purchase Order document
    And the Purchase Order document goes to FINAL
    Then In Pending Action Requests an FYI is sent to FO and Initiator
    And the Purchase Order Doc Status is Open
    Given I am logged in as "db18"
    And   I visit the "e-SHOP" page
    And   I Search Documents retrieve the PO
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
    And I switch to the user with the next Pending Action in the Route Log for the Payment Request document
    And I view the Payment Request document on my action list
    And I approve the Payment Request document
    And the Payment Request document goes to FINAL
    And   the Payment Request Doc Status is Department-Approved
    And I verified the GLPE on Payment Request page with the following:
      | line        | account number    | object code | balance type | object type  | amount    | dorc |
      | 1           | 1093603           | 6540        | EX           | EX           | 2,750.00  | C    |
      | 2           | 1093603           | 3110        | EX           | FB           | 2,750.00  | D    |
      | 3           | 1093603           | 6540        | AC           | EX           | 2,750.00  | D    |
      | 4           | 1093603           | 2900        | AC           | LI           | 2,750.00  | C    |




#
#  @pending @wip
#Scenario: I make a page object the quick way
#   Given I am logged in as "mss7"
#   When I visit the "Purchase Orders" page
#    And I select the purchase order '319358' with the doc id '5210590'
##   And I sleep for 10
#   And I print out all "field" on the page
#   And I print out all "textarea" on the page
#   And I print out all "button" on the page
#   And I print out all "select" on the page
#   And I print out all "checkbox" on the page
#   And I print out all "radio" on the page
#
#  @pending @wip
#  Scenario: I make a page object without frames the quick way
#    Given I am logged in as "mss7"
#    When I visit the "Purchase Orders" page
#    And I select the purchase order '319351' with the doc id '5210590'
##   And I sleep for 10
#    And I print out all "field" on the page without frame
#    And I print out all "textarea" on the page without frame
#    And I print out all "button" on the page without frame
#    And I print out all "select" on the page without frame
#    And I print out all "checkbox" on the page without frame
#    And I print out all "radio" on the page without frame
#

