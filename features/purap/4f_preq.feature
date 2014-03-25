Feature: Purap Preq Building Blocks

  [purap-4f] purap test manual entry, >$500, <$25000, external vendor and no wire

 @wip @purap
  Scenario: Purap Preq building block 4f
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
   And I calculate my Requisition document
   And I submit the Requisition document
   And the requisition document goes to ENROUTE
   And I am logged in as "jaf54"
#   And I am logged in as "der9"
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