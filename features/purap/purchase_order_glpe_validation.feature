Feature: GLPE validation tests for Purchase Orders

#  [KFSQA-873] KFSMI-5422, KFSMIT-5703, KFSMI-5743	KITI-3024	KFSUPGRADE-294
#              Implement KFSMI-5422, KFSMI-5703 and KFSMI-5743 All in regards to GL Entries incorrect
#              KFSPTS-674, KFSPTS-785 Accounts Payable, Purchasing, GL Entries PO Cancel, R,
#              Create a REQS/PO -as FO cancel, very the GL entries are correct. The test below
#              cancels a PO during approval.
#
#  [KFSQA-880] KFSMI-5743 Encumbrances incorrect for a PO and PO Void done on the same day
#              KFSMI-5703 Purchasing / Accounts Payable PO GL Entires R
#              Create a po and void it on the same day, verify encumbrances are correct.
#
#  [KFSQA-919] Contract Managers can cancel purchase order documents
#
#  @KFSQA-873 @PO @PURAP @tortoise
#  Scenario: Cancel a Purchase Order and verify the GLPE.
#   Given I am logged in as an e-SHOP User
#   And   I create the Requisition document with following specifications:
#     | Vendor Type        | NonB2B            |
#     | Account Type       | NonGrant          |
#     | Commodity Code     | Regular           |
#     | Object Code        | Operating Expense |
#     | Amount             | GT APO            |
#   And   I submit the Requisition document
#   And   I switch to the user with the next Pending Action in the Route Log for the Requisition document
#   And   I view the Requisition document on my action list
#   And   I approve the Requisition document
#   And   I am logged in as a Purchasing Processor
#   And   I submit a Contract Manager Assignment for the Requisition
#   And   I am logged in as a PURAP Contract Manager
#   And   I cancel the Purchase Order on the Requisition
#   Then  on the Purchase Order the GLPE displays "There are currently no General Ledger Pending Entries associated with this Transaction Processing document."
#
#  @KFSQA-880 @PO @coral @nightly-jobs
#  Scenario: Encumbrances incorrect for a PO and PO Void done on the same day 2
#    Given I initiate a Requisition document with the following:
#      | Vendor Type        | NonB2B    |
#      | Add Vendor On REQS | No        |
#      | Positive Approval  | Unchecked |
#      | Account Type       | NonGrant  |
#      | Commodity Code     | Sensitive |
#      | Amount             | GT APO    |
#    And   I extract the Requisition document to SciQuest
#    And   Nightly Batch Jobs run
#    And   I am logged in as a PURAP Contract Manager
#    And   I view the Purchase Order using the Document ID
#    And   I void The Purchase Order
#    And   The GLPE from the Purchase Order are reversed by the void
#
#  @KFSQA-919 @PO @PURAP @tortoise
#  Scenario: Contract Managers can cancel purchase order documents.
#    Given I am logged in as an e-SHOP User
#    And   I create the Requisition document with following specifications:
#      | Vendor Type        | NonB2B            |
#      | Account Type       | Grant             |
#      | Commodity Code     | Regular           |
#      | Object Code        | Operating Expense |
#      | Amount             | LT APO            |
#    And   I submit the Requisition document
#    And   I switch to the user with the next Pending Action in the Route Log to approve Requisition document to Final
#    And   I am logged in as a Purchasing Processor
#    And   I submit a Contract Manager Assignment for the Requisition
#    And   I am logged in as a PURAP Contract Manager
#    And   I cancel the Purchase Order on the Requisition
#    Then  on the Purchase Order the GLPE displays "There are currently no General Ledger Pending Entries associated with this Transaction Processing document."
#    And   the Purchase Order document status is 'CANCELED'
