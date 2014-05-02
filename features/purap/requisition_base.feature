Feature: PURAP manual entry greater than 500 but less than 25000

  @KFSQA-853 @pending @purap @coral @wip
  Scenario Outline: PURAP manual >$500, <$25000 external vendor no wire
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
