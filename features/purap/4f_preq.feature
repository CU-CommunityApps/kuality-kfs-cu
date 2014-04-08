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
  And I search and retrieve the REQS
  And The View Related Documents Tab PO Status displays
  #UNAPPROVED
  And I Select the PO
  And I Complete Selecting a Vendor
  #27015-0
  And I enter a Vendor Choice
  #LOWESt PRICE
  And I calculate and verify the GLPE
  #PARM
  And I submit the PO eDoc Status is
  #FINAL
#PO APPROVAL OPTIONS
#WRAP UP PROCESSES AND TESTS
  Then In Pending Action Requests an FYI is sent to FO and Initiator
  #jaf54 and der9
  And The PO eDoc Status is
  #FINAL
  And The Purchase Order Doc Status equals
  #OPEN





  @pending @wip
Scenario: I make a page object the quick way
   Given I am logged in as "mss7"
   When I visit the "Purchase Orders" page
    And I select the purchase order '319358' with the doc id '5210590'
#   And I sleep for 10
   And I print out all "field" on the page
   And I print out all "textarea" on the page
   And I print out all "button" on the page
   And I print out all "select" on the page
   And I print out all "checkbox" on the page
   And I print out all "radio" on the page

  @pending @wip
  Scenario: I make a page object without frames the quick way
    Given I am logged in as "mss7"
    When I visit the "Purchase Orders" page
    And I select the purchase order '319351' with the doc id '5210590'
#   And I sleep for 10
    And I print out all "field" on the page without frame
    And I print out all "textarea" on the page without frame
    And I print out all "button" on the page without frame
    And I print out all "select" on the page without frame
    And I print out all "checkbox" on the page without frame
    And I print out all "radio" on the page without frame