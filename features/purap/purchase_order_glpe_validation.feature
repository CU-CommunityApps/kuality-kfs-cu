Feature: Cancel Purchase Order

  [KFSQA-873] KFSMI-5422, KFSMIT-5703, KFSMI-5743	KITI-3024	KFSUPGRADE-294 Implement KFSMI-5422, KFSMI-5703 and KFSMI-5743 All in regards to GL Entries incorrect	KFSPTS-674, KFSPTS-785
  Accounts Payable, Purchasing, GL Entries PO Cancel, R, Create a REQS/PO -as FO cancel, very the GL entries are correct. The test below cancels a PO during approval.

  @KFSQA-873 @PO @PURAP @tortoise
  Scenario: Cancel a Purchase Order and verify the GLPE.
   Given I login as a PURAP eSHop user
   And   I create the Requisition document with:
     | Vendor Number       | 4471-0   |
     | Item Quantity       | 9.9      |
     | Item Cost           | 1000     |
     | Item Commodity Code | 10121800 |
     | Account Number      | 1093603  |
     | Object Code         | 6540     |
     | Percent             | 100      |
    And  I submit the Requisition document
    And  I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And  I view the Requisition document on my action list
    And  I approve the Requisition document
    And  I am logged in as a Purchasing Processor
    And  I submit a Contract Manager Assignment of '10' for the Requisition
    And  I am logged in as a PURAP Contract Manager
    And  I cancel the Purchase Order on the Requisition
    When I view the Requisition document
    Then On the Purchase Order the GLPE displays "There are currently no General Ledger Pending Entries associated with this Transaction Processing document."