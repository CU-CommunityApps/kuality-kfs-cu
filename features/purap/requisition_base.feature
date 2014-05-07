Feature: PURAP manual entry greater than 500 but less than 25000

  [KFSQA-853] PUR-5  Sensitive Commodity Data Flag enh

  [KFSQA-854] POs Follow Routing per Organization Review (ORG 0100)

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
    |Amount             | <amount>      |
    |Level              | <level>     |
#    |Default PM         | P           |
    # default PM can ve implemented after alternate PM is moved to upgrade
#    |APO            | GT          |
    # Vendor Type : Foreign, External, Internal
    # Account Type : Grant, ?.
    # Commodity Code : Regular, Sensitive
    # Amount : LT APO, GT APO, 100000, 500000, 5000000
    #
  And  I EXTRACT THE REQS TO SQ
  When I INITIATE A PREQS
  Then I FORMAT AND PROCESS THE CHECK WITH PDP
  Examples:
  | amount     | level    |
  | 100000     | 1        |
  | 500000     | 2        |
  | 5000000    | 3        |

#  Given I Login as a PDP Format Disbursement Processor
#  And   I format Disbursement
#  And   I select continue on Format Disbursement Summary
#  And   a Format Summary Lookup displays
