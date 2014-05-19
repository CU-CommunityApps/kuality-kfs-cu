Feature: Purchase Order

  [KFSQA-882] GLPEs are wrong on Purchase Order Amendments (POAs) KFSMI-9879

  @KFSQA-882 @REQS @PO @pending @coral @wip
  Scenario: GLPEs are wrong on Purchase Order Amendments (POAs) KFSMI-9879
    Given I INITIATE A REQS with following:
      |Vendor Type        | NonB2B      |
      |Add Vendor On REQS | No          |
      |Positive Approval  | Unchecked   |
      |Account Type       | NonGrant    |
      |Commodity Code     | Sensitive   |
      |Amount             | GT APO      |
    And   I EXTRACT THE REQS TO SQ
#    And   I INITIATE A POA
#    And   I add to already ordered items and the combined total of the PO plus the POA increases by $100.00
#    When  I run the overnight batch jobs
#    Then  the GL Entries are verified (GLPE of PO + GLPE of POA are posted)