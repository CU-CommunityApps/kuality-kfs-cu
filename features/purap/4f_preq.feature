Feature: Purap Preq Building Blocks

  [purap-4f] purap test manual entry, >$500, <$25000, external vendor and no wire

  #PURAP TEST IN PROGRESS JUST UPLOADING TO ADD FILES SO OTHERS CAN WORK ON PURAP
@pending @wip @purap
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




  And the REQS eDoc Status Equals
Awaiting Contract Manager Assignment
  And I login as Purchasing Processor
<ml284>
  And I create a Contract Manager Assignment
  And I Select the REQS and Enter a Contract Manager
<10>
  And I Submit the document and it goes FINAL
  And I login as the REQS Initiator
<Initiator of REQS>
  And the REQS Status is
<Masked ******** UNNAPPROVED>
  And I login as Contract Manager
<mss7>
  And I search and retrieve the REQS
  And The View Related Documents Tab PO Status displays
<Unmasked UNNAPPROVED>
  And I Select the PO
  And I Complete Selecting a Vendor
<27015-0>
  And I enter a Vendor Choice
<Lowest Price>
  And I calculate and verify the GLPE
We already have this coded. See some of the PE tests where we validate the expected results. Debit Expense, Credit Object Code 3110
  And I submit the document and it status is
  And in Pending Action Requests an FYI is sent to FO and Initiator
<Automatic FYI to jaf54 and der9>
  And I submit the PO eDoc Status is
<FINAL>
  And The Purchase Order Doc Status equals
<Open>
  Given I login to KFS and select eShop
<Initiator of REQS>
  And I Search Documents retrieve the PO
<Today>
  And the Document Status displayed came from the PO and is
<Completed>
  And the Delivery Instructions displayed equals what came from the PO
  And the Notes to Supplier displayed equals what came from the PO
  And the Attachments for Supplier came from the PO
  And I login as KFS Administrator
We already have this coded. See some of the PE tests where we validate the expected results. Debit Expense, Credit Object Code 3110
  And The PO GLPE are verified
  And I run the nightly batches
  When The PO GLPE equal the General Ledger Entries
  Then I close POS with Zero Balances
autoCloseRecurringOrdersStep



#   Given I am logged in as "der9"
#   When I visit the "Purchase Orders" page
#   And I sleep for 10
#   And I print out all "field" on the page
#   And I print out all "button" on the page
#   And I print out all "select" on the page
#   And I print out all "checkbox" on the page
#   And I print out all "radio" on the page