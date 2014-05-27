Feature: REQS, PO, PREQ,PDP

  [KFSQA-853] PUR-5  Sensitive Commodity Data Flag enh

  [KFSQA-854] POs Follow Routing per Organization Review (ORG 0100)

  [KFSQA-855] PUR-10  remove commodity review from PO

  [KFSQA-858] PUR-4 POA Changes to routing and permissions

  [KFSQA-882] GLPEs are wrong on Purchase Order Amendments (POAs)

  @KFSQA-853 @BaseFunction @REQS @PO @PREQ @PDP @Routing @coral
  Scenario: PUR-5 Sensitive Commodity Data Flag enh
    Given I initiate a Requisition document with the following:
      | Vendor Type        | NonB2B    |
      | Add Vendor On REQS | No        |
      | Positive Approval  | Unchecked |
      | Account Type       | NonGrant  |
      | Commodity Code     | Sensitive |
      | Amount             | GT APO    |
#    | Default PM         | P           |
  # default PM can ve implemented after alternate PM is moved to upgrade
    When  I extract the Requisition document to SciQuest
    And   I initiate a Payment Request document

  @KFSQA-854 @BaseFunction @REQS @PO @PREQ @PDP @Routing @coral
  Scenario Outline: POs Follow Routing per Organization Review (ORG 0100)
    Given I initiate a Requisition document with the following:
      | Vendor Type        | NonB2B    |
      | Add Vendor On REQS | No        |
      | Positive Approval  | Unchecked |
      | Account Type       | NonGrant  |
      | Commodity Code     | Sensitive |
      | Amount             | <amount>  |
      | Level              | <level>   |
      | Routing Check      | Base Org  |
  #    |Default PM         | P          |
    # default PM can ve implemented after alternate PM is moved to upgrade
    When  I extract the Requisition document to SciQuest
    And   I initiate a Payment Request document
  Examples:
    | amount  | level |
    | 100000  | 1     |
    | 500000  | 2     |
    | 5000000 | 3     |

  @KFSQA-855 @BaseFunction @REQS @PO @PREQ @PDP @Routing @coral
  Scenario Outline: PUR-10  remove commodity review from PO
    Given I initiate a Requisition document with the following:
      | Vendor Type        | NonB2B      |
      | Add Vendor On REQS | No          |
      | Positive Approval  | Unchecked   |
      | Account Type       | NonGrant    |
      | Commodity Code     | <commodity> |
      | Amount             | <amount>    |
      | Routing Check      | Commodity   |
#    |Default PM         | P           |
  # default PM can ve implemented after alternate PM is moved to upgrade
    When  I extract the Requisition document to SciQuest
    And   I initiate a Payment Request document
  Examples:
    | amount | commodity |
    | GT APO | Sensitive |
    | LT APO | Sensitive |
    | GT APO | Regular   |
    | LT APO | Regular   |

  @KFSQA-858 @BaseFunction @POA @PDP @coral
  Scenario: PUR-4 POA Changes to routing and permissions
    Given I initiate a Requisition document with the following:
      | Vendor Type        | NonB2B    |
      | Add Vendor On REQS | Yes       |
      | Positive Approval  | Unchecked |
      | Account Type       | NonGrant  |
      | Commodity Code     | Regular   |
      | Amount             | LT APO    |
#    | Default PM         | P           |
  # default PM can ve implemented after alternate PM is moved to upgrade
    When  I extract the Requisition document to SciQuest
    And   I initiate a Purchase Order Amendment document
    Then the POA Routes to the FO
    When  I initiate a Payment Request document

  @KFSQA-882 @BaseFunction @POA @PO @coral
  Scenario: GLPEs are wrong on Purchase Order Amendments (POAs)
    Given I initiate a Requisition document with the following:
      | Vendor Type        | NonB2B    |
      | Add Vendor On REQS | Yes       |
      | Positive Approval  | Unchecked |
      | Account Type       | NonGrant  |
      | Commodity Code     | Regular   |
      | Amount             | GT APO    |
#    | Default PM         | P           |
  # default PM can ve implemented after alternate PM is moved to upgrade
    When  I extract the Requisition document to SciQuest
    And   I initiate a Purchase Order Amendment document with the following:
      | Item Quantity | 1   |
      | Item Cost     | 100 |
    Then the Purchase Order Amendment document's GLPE tab shows the new item amount