Feature: Requisition routing testing

  [KFSQA-865] KITI-763	KFSUPGRADE-409 PUR-2 Shop Catalogs Routing Changes - split node routing per csu	Purchasing	SciQuest PO Routing	PURAP 001 E2E
  This fix is necessary to allow the e-shop orders under 500 or 1500 depending on role to be sent without FO approval on the PO, and later to require approval on PREQ

  @KFSQA-865 @PURAP @REQS @ESHOP @PREQS @routing @coral
  Scenario Outline: EShop routing verification with total cost between B2B_TOTAL_AMOUNT_FOR_AUTO_PO and B2B_TOTAL_AMOUNT_FOR_SUPER_USER_AUTO_PO
    Given  I create an e-SHOP Requisition document with a <item type> item type
    Then   the Requisition document does not route to the Financial Officer
    When   I route the e-SHOP Requisition document through SciQuest until the Payment Request document is ENROUTE
    Then   the next pending action for the Payment Request document is an APPROVE from a  KFS-SYS Fiscal Officer IT
  Examples:
          | item type     |
          | Non-Sensitive |
          | Sensitive     |

  @KFSQA-865 @PURAP @REQS @ESHOP @PREQS @routing @coral
  Scenario Outline: Create ESHOP order 500 and one for 1500
    Given  I create an e-SHOP Requisition document with a <item type> item type that is at least <cart value> in value
    Then   the Requisition document does not route to the Financial Officer
    When   I route the e-SHOP Requisition document through SciQuest until the Payment Request document is ENROUTE
    Then   the next pending action for the Payment Request document is an APPROVE from a  KFS-SYS Fiscal Officer IT
  Examples:
           | item type     | cart value |
           | Non-Sensitive |  501       |
           | Non-Sensitive |  1501      |
           | Sensitive     |  501       |
           | Sensitive     |  1501      |
