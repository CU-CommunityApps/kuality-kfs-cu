Feature: Purap Preq Building Blocks

  [purap-4f] purap test manual entry, >$500, <$25000, external vendor and no wire

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
  And  I calculate my Requisition document
  And  I submit the Requisition document
  And  the requisition document goes to ENROUTE
  And  I switch to the user with the next Pending Action in the Route Log for the Requisition document
  And  I view the Requisition document on my action list
  And  I approve the Requisition document
  Then the Requisition document goes to FINAL
  #PO
  And I am logged in as a Purchasing Processor
  #<ml284>
  And I submit a Contract Manager Assignment of '10' for the Requisition
  And And I login as a Requisition Officer
  #der9
  And I view the Requisition document from the Requisitions search
  And I am logged in as a Contract Manager
  #mss7
  And I retrieve the Requisition document
  And The View Related Documents Tab PO Status displays
  And I Complete Selecting a Vendor
  #27015-0
  And I enter a Vendor Choice of 'Lowest Price'
  And I calculate and verify the GLPE tab
  And I submit the document
#PO APPROVAL OPTIONS
#WRAP UP PROCESSES AND TESTS
  Then In Pending Action Requests an FYI is sent to FO and Initiator
  #jaf54 and der9
  And the Purchase Order document status is 'FINAL'
  And the Purchase Order Doc Status equals 'Open'
