Feature: REQS, PO, PREQ,PDP

  [KFSQA-853] PUR-5  Sensitive Commodity Data Flag enh

  [KFSQA-854] POs Follow Routing per Organization Review (ORG 0100)

  [KFSQA-855] PUR-10  remove commodity review from PO

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

  @KFSQA-854 @BaseFunction @REQS @PO @PREQ @PDP @Routing @coral @pending @wip
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

  @KFSQA-855 @BaseFunction @REQS @PO @PREQ @PDP @Routing @pending @coral @wip
  Scenario: PUR-10  remove commodity review from PO
    Given I INITIATE A REQS with following:
      |Vendor Type        | NonB2B      |
      |Add Vendor On REQS | No          |
      |Positive Approval  | Unchecked   |
      |Account Type       | NonGrant    |
      |Commodity Code     | Sensitive   |
      |Amount             | GT APO      |
      |Routing Check      | Commodity   |
#    |Default PM         | P           |
  # default PM can ve implemented after alternate PM is moved to upgrade
    And  I EXTRACT THE REQS TO SQ
    When I INITIATE A PREQS
    Then I FORMAT AND PROCESS THE CHECK WITH PDP

