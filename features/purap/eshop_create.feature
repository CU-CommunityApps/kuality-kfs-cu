Feature: eSHOP Create

  [KFSQA-731]

  @KFSQA-731 @E2E @PURAP @REQS @e-SHOP @cornell
  Scenario: Create e-SHOP as buyer
    # Given I Initiate an eShop Order (Base Function)
    Given I am logged in as an e-SHOP User
    When  I select an e-SHOP Vendor
    And   I search for an e-SHOP item with a Non-Sensitive Commodity Code
    And   I add e-SHOP items to my cart until the cart total reaches the B2B Total Amount For Automatic Purchase Order limit
    Then  Positive Pay is checked
    When  I update the Requistion document's following fields:
      | Account        | Defaults from e-SHOP |
      | Object Code    | Defaults from e-SHOP |
      | Commodity Code | Defaults from e-SHOP |
    Then the document status is APPROVED

    When  the Items total Greater than B2B_TOTAL_AMOUNT_ FOR_AUTO_PO and Less Than B2B_TOTAL_AMOUNT_ FOR_SUPER_USER_AUTO_PO
    Then  the Document Routes to the Fiscal Officer

