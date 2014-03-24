Feature: Purap Preq Building Blocks

  [purap-4f] purap test manual entry, >$500, <$25000, external vendor and no wire

 @wip @purap
  Scenario: Purap Preq building block 4f
#   Given I am logged in as "der9"
#   When I visit the "Purchase Orders" page
#   And I sleep for 10
#   And I print out all "field" on the page
#   And I print out all "button" on the page
#   And I print out all "select" on the page
#   And I print out all "checkbox" on the page
#   And I print out all "radio" on the page
   Given I login as a KFS user to create an REQS
# der9
   And I create the Requisition document with:
#   | payment request     | :clear   |
   | vendor number       | 4471-0   |
   | item quanity        | 9.9      |
   | item cost           | 1000     |
   | item commodity code | 10121800 |
   | account number      | 1093603  |
   | object code         | 6540     |
   | percent             | 100      |
   And I submit the Requistion document
   And I sleep for 30
   And the Requisition document goes to ENROUTE
   And I am logged in as "jaf54"
   And I view the Requisition document on my action list
   And I approve the Requisition document
   And the Requisition document goes to FINAL




# I enter a Description and an explanation
# <any text>
#   And I Select The Payment Request Positive Approval Required
# Unchecked
#   And I select a Vendor
# <4471-0>
#   And I enter Delivery Instructions and Notes to Vendor
# <any text>
#   And The Account Distribution Method equals
# <Proportional>
#   And e-Shop Flags equal the value
# No e-Shop flag is set to true
#   And I enter an Item
# 9.9 @ 1000 Dog Food 10121800
#   And I click Show Accounting Lines and enter an Accounting Line
# (1093603 Object Code 6540)
#   And the default percent equals
# 100 Percent
#   And I enter Note Text, Attach File, Send to Vendor and add an Attachment
# <Text, pdf,Send>
#   And I select calculate and submit the document


#
#
#
#
#   And I login and filter my Action List and Select REQS
# <*FO=jaf54>
#   And I approve the REQS and it Goes to Final
#   And the REQS eDoc Status Equals
# Closed
#   Given I login to KFS and select eShop
# <Initiator of REQS>
#   And I Search Documents retrieve the PO
#   And the Document Status displayed came from the PO and is
# <Completed>
#   And the Delivery Instructions displayed equals what came from the PO
#   And the Notes to Supplier displayed equals what came from the PO
#   And the Attachments for Supplier came from the PO
#
#
# Anf I login as KFS Administrator
# We already have this coded. See some of the PE tests where we validate the expected results. Debit Expense, Credit Object Code 3110
#   And The PO GLPE are verified
#   And I run the nightly batches
#   When The PO GLPE equal the General Ledger Entries
#   Then I close POS with Zero Balances
# autoCloseRecurringOrdersStep

#
#   And       I login as an Accounts Payable Processor
#   And       I Lookup a PREQ
#   And I enter a Purchase Order Number
#   And I enter an Invoice Date
#   And I enter an Invoice Number
#   And I enter a Vendor Invoice Amount
#   And I enter Wire Tab Information
#   And I change the Remit To Address
#   And      I enter the Qty Invoiced and select Calculate
#   And      I enter a Pay Date
#   And      I Attach an Invoice Image
#   And      I select calculate and I submit and it goes ENROUTE
#
#
#
# <jf427>
#
# <From PO>
# <Today>
# <Make One Up>
# $24450
#
# <Add "Apt1" to Address 1>
# <(same at QTY ordered on REQS>
# <Today>
# <Add Attachment>