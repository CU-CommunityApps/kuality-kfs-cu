Feature: Purap REQS 2 Building Blocks

  [KFSQA-733] Create -- non eShop with C&G, Commodity routing

  [KFSQA-734] Create -- non eShop with not C&G amount, Commodity routing

  [KFSQA-735] Create -- non eShop with not C&G account, Commodity routing

  @KFSQA-733 @purap @cornell @tortoise
  Scenario: Create -- non eShop with C&G, Commodity routing
    Given I login as a KFS user to create an REQS
    And   I create the Requisition document with:
    | Vendor Number       | 4471-0   |
    | Item Quantity       | 7.5      |
    | Item Cost           | 1000     |
    | Item Commodity Code | 12142203 |
    | Item Catalog Number | 10101157 |
    | Item Description    | ANIM     |
    | Account Number      | 1278003  |
    | Object Code         | 6570     |
    | Percent             | 100      |
    And   I add an Attachment to the Requisition document
    And   I enter Delivery Instructions and Notes to Vendor
    And   I calculate my Requisition document
    And   I submit the Requisition document
    Then  the requisition document goes to ENROUTE
    #   FO approve
    And   I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And   I view the Requisition document on my action list
    And   I approve the Requisition document
    Then  the Requisition document goes to ENROUTE
   # Contracts & Grants Processor approve
    And   I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And   I view the Requisition document on my action list
    And   I approve the Requisition document
    And   the Requisition document goes to ENROUTE
    # commodity reviewer
    And   I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And   I view the Requisition document on my action list
    And   I approve the Requisition document
    Then  the Requisition document goes to FINAL

  @KFSQA-734 @KFSQA-735 @purap @cornell @slug
  Scenario Outline: Create -- non eShop with not C&G amount or account , Commodity routing
    Given I login as a KFS user to create an REQS
    And   I create the Requisition document with:
      | Vendor Number       | 4471-0           |
      | Item Quantity       | <item_quantity>  |
      | Item Cost           | 1000             |
      | Item Commodity Code | 12142203         |
      | Item Catalog Number | 10101157         |
      | Item Description    | ANIM             |
      | Account Number      | <account_number> |
      | Object Code         | <object_code>    |
      | Percent             | 100              |
    And   I add an Attachment to the Requisition document
    And   I enter Delivery Instructions and Notes to Vendor
    And   I calculate my Requisition document
    And   I submit the Requisition document
    Then  the requisition document goes to ENROUTE
#   FO approve
    And   I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And   I view the Requisition document on my action list
    And   I approve the Requisition document
    Then  the Requisition document goes to ENROUTE
    # commodity reviewer
    And   I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And   I view the Requisition document on my action list
    And   I approve the Requisition document
    Then  the Requisition document goes to FINAL
  Examples:
      | account_number    | object_code | item_quantity |
      | 1278003           | 6570        | 4.9           |
      | R589854           | 6540        | 7.5           |
