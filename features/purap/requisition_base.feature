Feature: PURAP manual entry greater than 500 but less than 25000

  @KFSQA-853 @pending @purap @coral @wip
  Scenario: PURAP manual >$500, <$25000 external vendor no wire
  Given I INITIATE A REQS with following:
    |Vendor Type        | NonB2B     |
    |Add Vendor On REQS | No          |
    |Positive Approval  | Unchecked     |
    |Account Type       | NonGrant       |
    |Commodity Code     | Sensitive   |
    |APO                | GT          |
#    |Default PM         | P           |
    # default PM can ve implemented after alternate PM is moved to upgrade
#    |APO            | GT          |
    # Vendor Type : Foreign, External, Internal
    # Account Type : Grant, ?.
    # Commodity Code : Regular, Sensitive
    # APO : LT, GT.  Do we need EQ
    #
  And  I EXTRACT THE REQS TO SQ
  When I INITIATE A PREQS
  Then I FORMAT AND PROCESS THE CHECK WITH PDP

#  Given I Login as a PDP Format Disbursement Processor
#  And   I format Disbursement
#  And   I select continue on Format Disbursement Summary
#  And   a Format Summary Lookup displays
