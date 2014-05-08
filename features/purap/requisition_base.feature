Feature: REQS, PO, PREQ,PDP

  [KFSQA-853] PUR-5  Sensitive Commodity Data Flag enh

  @KFSQA-853 @BaseFunction @REQS @PO @PREQ @PDP @pending @coral
  Scenario: PUR-5 Sensitive Commodity Data Flag enh
  Given I INITIATE A REQS with following:
    |Vendor Type        | NonB2B      |
    |Add Vendor On REQS | No          |
    |Positive Approval  | Unchecked   |
    |Account Type       | NonGrant    |
    |Commodity Code     | Sensitive   |
    |Amount             | GT APO      |
#    |Default PM         | P           |
    # default PM can be implemented after alternate PM is moved to upgrade
  And  I EXTRACT THE REQS TO SQ
  When I INITIATE A PREQS
  Then I FORMAT AND PROCESS THE CHECK WITH PDP

