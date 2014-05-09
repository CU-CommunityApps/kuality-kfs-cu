Feature: REQS, PO, PREQ,PDP

  [KFSQA-853] PUR-5  Sensitive Commodity Data Flag enh

  [KFSQA-854] POs Follow Routing per Organization Review (ORG 0100)

  [KFSQA-855] PUR-10  remove commodity review from PO

  [KFSQA-830] Alt Pay and PDP SETUP. This is a process run every night to clear out PURAP and PDP before testing.

  @KFSQA-853 @BaseFunction @REQS @PO @PREQ @PDP @Routing @pending @coral
  Scenario: PUR-5 Sensitive Commodity Data Flag enh
    Given I INITIATE A REQS with following:
      |Vendor Type        | NonB2B      |
      |Add Vendor On REQS | No          |
      |Positive Approval  | Unchecked   |
      |Account Type       | NonGrant    |
      |Commodity Code     | Sensitive   |
      |Amount             | GT APO      |
#    |Default PM         | P           |
  # default PM can ve implemented after alternate PM is moved to upgrade
    And  I EXTRACT THE REQS TO SQ
    When I INITIATE A PREQS
    Then I FORMAT AND PROCESS THE CHECK WITH PDP

  @KFSQA-854 @BaseFunction @REQS @PO @PREQ @PDP @Routing @coral @pending
  Scenario Outline: POs Follow Routing per Organization Review (ORG 0100)
  Given I INITIATE A REQS with following:
    |Vendor Type        | NonB2B      |
    |Add Vendor On REQS | No          |
    |Positive Approval  | Unchecked   |
    |Account Type       | NonGrant    |
    |Commodity Code     | Sensitive   |
    |Amount             | <amount>    |
    |Level              | <level>     |
    |Routing Check      | Base Org    |
#    |Default PM         | P           |
    # default PM can ve implemented after alternate PM is moved to upgrade
  And  I EXTRACT THE REQS TO SQ
  When I INITIATE A PREQS
  Then I FORMAT AND PROCESS THE CHECK WITH PDP
  Examples:
  | amount     | level    |
  | 100000     | 1        |
  | 500000     | 2        |
  | 5000000    | 3        |

  @KFSQA-855 @BaseFunction @REQS @PO @PREQ @PDP @Routing @pending @coral
  Scenario Outline: PUR-10  remove commodity review from PO
    Given I INITIATE A REQS with following:
      |Vendor Type        | NonB2B      |
      |Add Vendor On REQS | No          |
      |Positive Approval  | Unchecked   |
      |Account Type       | NonGrant    |
      |Commodity Code     | <commodity> |
      |Amount             | <amount>    |
      |Routing Check      | Commodity   |
#    |Default PM         | P           |
  # default PM can ve implemented after alternate PM is moved to upgrade
    And  I EXTRACT THE REQS TO SQ
    When I INITIATE A PREQS
    Then I FORMAT AND PROCESS THE CHECK WITH PDP
  Examples:
    | amount     | commodity    |
    | GT APO     | Sensitive    |
    | LT APO     | Sensitive    |
    | GT APO     | Regular      |
    | LT APO     | Regular      |

  @KFSQA-830 @BaseFunction @PURAP @PDP @SETUP @pending @coral @wip
  Scenario: Alt Pay and PDP SETUP
    Given I FORMAT AND PROCESS THE CHECK WITH PDP
