Feature: eSHOP Create

  [KFSQA-731]

  @KFSQA-731 @E2E @PURAP @REQS @e-SHOP
  Scenario: Create e-SHOP as buyer
    Given I Initiate an eShop Order (Base Function)
    When  the Items total Greater than B2B_TOTAL_AMOUNT_ FOR_AUTO_PO and Less Than B2B_TOTAL_AMOUNT_ FOR_SUPER_USER_AUTO_PO
    Then  the Document Routes to the Fiscal Officer

