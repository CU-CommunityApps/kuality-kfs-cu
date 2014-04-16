Feature: Purap REQS 2 Building Blocks

  [KFSQA-733] Create -- non eShop with C&G, Commodity routing

 @KFSQA-733 @purap @cornell @tortoise
  Scenario: Create -- non eShop with C&G, Commodity routing
    Given I login as a KFS user to create an REQS
   #TODO - todd fix
    And   I create the Requisition document with:
    | vendor number       | 4471-0   |
    | item quanity        | 7.5      |
    | item cost           | 1000     |
    | item commodity code | 12142203 |
    | account number      | 1278003  |
    | object code         | 6570     |
    | percent             | 100      |
  #TODO TODD - make this less hard coded
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
    And   I am logged in as a Commodity Reviewer
    And   I view the Requisition document on my action list
    And   I approve the Requisition document
    Then  the Requisition document goes to FINAL
