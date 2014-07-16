Feature: Requisition routing testing

  [KFSQA-865] KITI-763	KFSUPGRADE-409 PUR-2 Shop Catalogs Routing Changes - split node routing per csu	Purchasing	SciQuest PO Routing	PURAP 001 E2E
  This fix is necessary to allow the e-shop orders under 500 or 1500 depending on role to be sent without FO approval on the PO, and later to require approval on PREQ

  @wip @KFSQA-865 @PURAP @REQS @ESHOP @PREQS @routing
  Scenario Outline: EShop routing verification with total cost between B2B_TOTAL_AMOUNT_FOR_AUTO_PO and B2B_TOTAL_AMOUNT_FOR_SUPER_USER_AUTO_PO
    Given  I create an e-SHOP Requisition document with a <item type> item type
    Then  the Requisition document does not route to the Financial Officer
    When I take the e-SHOP Requisition document through SciQuest till the Payment Request document is ENROUTE
    Then the next pending action for the Payment Request document is an APPROVE from a  KFS-SYS Fiscal Officer IT
    Examples:
      | item type     |
      | Non-Sensitive |
      | Sensitive     |

  @wip @KFSQA-865 @PURAP @REQS @ESHOP @PREQS @routing
  Scenario Outline: Create ESHOP order 500 and one for 1500
    Given  I create an e-SHOP Requisition document with a <item type> item type that is at least <cart value> in value
    Then  the Requisition document does not route to the Financial Officer
    When I take the e-SHOP Requisition document through SciQuest till the Payment Request document is ENROUTE
    Then the next pending action for the Payment Request document is an APPROVE from a  KFS-SYS Fiscal Officer IT
  Examples:
    | item type     | cart value |
#    | Non-Sensitive |  50        |
    | Non-Sensitive |  1500      |
#    | Sensitive     |  50        |
#    | Sensitive     |  1500      |

#  @wip @KFSQA-865 @PURAP @REQS @ESHOP @PREQS @routing
#  Scenario: Requisition routing test with commodity review and make sure the PO does route to commodity reviewer.
#    Given  I create an e-SHOP Requisition document with a Sensitive item
#    Given  I create an e-SHOP Requisition document with a Non-Sensitive item
#    Then the Requisition document does not route to the Financial Officer
#    When I take the e-SHOP Requisition document through SciQuest till the Payment Request document is ENROUTE
#    Then the next pending action for the Payment Request document is an APPROVE from a  KFS-SYS Fiscal Officer IT

  @wip @KFSQA-865 @PURAP @REQS @ESHOP @PREQS @routing
  Scenario: Requisition routing the applicable role, verify approval not needed by the FO. PREQ requires positive approval.
    Given I INITIATE AN ESHOP ORDER
    And  I Login as an eShop Super User
    And  Items total greater than B2B_TOTAL_AMOUNT_ FOR_AUTO_PO and less than B2B_TOTAL_AMOUNT_ FOR_SUPER_USER_AUTO_PO
    Then the Requisition document does not route to the Financial Officer
    And  I extract the Requisition document to SciQuest
    And  I initiate a Payment Request document

    And The PREQ requires Positive Approval by the FO

  @wip @KFSQA-865 @PURAP @REQS @ESHOP @PREQS @routing
  Scenario: Requisition routing test with commodity review and make sure the PO does route to commodity reviewer.  Do a negative test
    Given I INITIATE AN ESHOP ORDER
    And  I Login as an eShop Super User
    And  I Order a Sensitive Item
    And  Items Total GT less than B2B_TOTAL_AMOUNT_ FOR_AUTO_PO and less than B2B_TOTAL_AMOUNT_ FOR_SUPER_USER_AUTO_PO
    Then the Requisition document does not route to the Financial Officer
    And  The REQS is approved by Animal Review
    And  I extract the Requisition document to SciQuest
    And  I initiate a Payment Request document
    And  The PREQ requires Positive Approval by the FO

  @wip @KFSQA-865 @PURAP @REQS @ESHOP @PREQS @routing
  Scenario: Requisition routing test with a regular orders of the same amounts.
    Given I INITIATE AN ESHOP ORDER
    And   the Items are less than 0
    Then  the Requisition document does not route to the Financial Officer
    And   I extract the Requisition document to SciQuest
    And   I initiate a Payment Request document
    And   The PREQ requires Positive Approval by the FO
