Feature: Purap Preq Building Blocks

  [purap-4f] purap test manual entry, >$500, <$25000, external vendor and no wire

  #PURAP TEST IN PROGRESS JUST UPLOADING TO ADD FILES SO OTHERS CAN WORK ON PURAP
@pending @purap
  Scenario: Purap Preq building block 4f
   Given I login as a KFS user to create an REQS
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



#   Given I am logged in as "der9"
#   When I visit the "Purchase Orders" page
#   And I sleep for 10
#   And I print out all "field" on the page
#   And I print out all "button" on the page
#   And I print out all "select" on the page
#   And I print out all "checkbox" on the page
#   And I print out all "radio" on the page