Feature: Requisition routing testing

  [KFSQA-865] KITI-763	KFSUPGRADE-409 PUR-2 Shop Catalogs Routing Changes - split node routing per csu	Purchasing	SciQuest PO Routing	PURAP 001 E2E
  This fix is necessary to allow the e-shop orders under 500 or 1500 depending on role to be sent without FO approval on the PO, and later to require approval on PREQ


  @wip @KFSQA-865 @PURAP @REQS @ESHOP @PREQS @routing
  Scenario: Create ESHOP order 500 and one for 1500
    Given I INITIATE AN ESHOP ORDER
    Then the FO is not in the Route Log
    And I EXTRACT THE REQS TO SQ
    When I INITIATE A PREQS
    And The PREQ requires Positive Approval by the FO

  @wip @KFSQA-865 @PURAP @REQS @ESHOP @PREQS @routing
  Scenario: Requisition routing the applicable role, verify approval not needed by the FO. PREQ requires positive approval.
    Given I INITIATE AN ESHOP ORDER
    And I Login as an eShop Super User
    And Items total greater than less than B2B_TOTAL_AMOUNT_ FOR_AUTO_PO and less than B2B_TOTAL_AMOUNT_ FOR_SUPER_USER_AUTO_PO
    And the FO is not in the Route Log
    And I EXTRACT THE REQS TO SQ
    When I INITIATE A PREQS
    And The PREQ requires Positive Approval by the FO

  @wip @KFSQA-865 @PURAP @REQS @ESHOP @PREQS @routing
  Scenario: Requisition routing test with commodity review and make sure the PO does route to commodity reviewer.  Do a negative test
    Given I INITIATE AN ESHOP ORDER
    And I Order a Sensitive Item
    And the FO is not in the Route Log
    And I EXTRACT THE REQS TO SQ
    When I INITIATE A PREQS
    And The PREQ requires Positive Approval by the FO

  @wip @KFSQA-865 @PURAP @REQS @ESHOP @PREQS @routing
  Scenario: Requisition routing test with commodity review and make sure the PO does route to commodity reviewer.  Do a negative test
    Given I INITIATE AN ESHOP ORDER
    And I Login as an eShop Super User
    And I Order a Sensitive Item
    And Items Total GT less than B2B_TOTAL_AMOUNT_ FOR_AUTO_PO and less than B2B_TOTAL_AMOUNT_ FOR_SUPER_USER_AUTO_PO
    And the FO is not in the Route Log
    And The REQS is approved by Animal Review
    And I EXTRACT THE REQS TO SQ
    When I INITIATE A PREQS
    And The PREQ requires Positive Approval by the FO

  @wip @KFSQA-865 @PURAP @REQS @ESHOP @PREQS @routing
  Scenario: Requisition routing test with a regular orders of the same amounts.
    Given I INITIATE AN ESHOP ORDER
    And the Items are less than 0
    And the FO is not in the Route Log
    And I EXTRACT THE REQS TO SQ
    When I INITIATE A PREQS
    And The PREQ requires Positive Approval by the FO
