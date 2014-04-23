Feature: Purap Preq Building Blocks

  [KFSQA-745] PURAP E2E PO - Approved (PURAP E2E-003d) - vendor selected, >$100K, >$500K, <$5MM

  @KFSQA-745 @pending @purap @cornell @slug @wip
  Scenario: PURAP E2E PO - Approved (PURAP E2E-003d) - vendor selected, >$100K, >$500K, <$5MM
    Given I login as a PURAP eSHop user
    And I create the Requisition document with:
      | vendor number       |          |
      | item quanity        | 180      |
      | item cost           | 1000     |
      | item commodity code | 12142203 |
      | item catalog number | 10101157 |
      | item description    | ANIM     |
      | account number      | R589854  |
      | object code         | 6540     |
      | percent             | 100      |
    And I add an Attachment to the Requisition document
    And I enter Delivery Instructions and Notes to Vendor
    And I calculate my Requisition document
    And I submit the Requisition document
    And the requisition document goes to ENROUTE
    And I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And I view the Requisition document on my action list
    And I approve the Requisition document
    And the Requisition document goes to ENROUTE
    # commodity reviewer
    And I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And I view the Requisition document on my action list
    And I approve the Requisition document
    And the Requisition document goes to FINAL
    And I am logged in as a Purchasing Processor
    And I submit a Contract Manager Assignment of '10' for the Requisition
    And I am logged in as a PURAP Contract Manager
    And I retrieve the Requisition document
    And The View Related Documents Tab PO Status displays
    And the Purchase Order Number is unmasked
    And I Complete Selecting Vendor 27015-0
    And I enter a Vendor Choice
    And I calculate and verify the GLPE tab
    And I submit the Purchase Order document
    And the Purchase Order document goes to ENROUTE
    And I switch to the user with the next Pending Action in the Route Log for the Purchase Order document
    And I view the Purchase Order document on my action list
    And I approve the Purchase Order document
    And the Purchase Order document goes to FINAL
    Then In Pending Action Requests an FYI is sent to FO and Initiator
    And The Purchase Order Doc Status is Open


