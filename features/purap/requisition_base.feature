Feature: REQS, PO, PREQ,PDP

#  [KFSQA-853] PUR-5  Sensitive Commodity Data Flag enh
#
#  [KFSQA-854] POs Follow Routing per Organization Review (ORG 0100)
#
#  [KFSQA-855] PUR-10  remove commodity review from PO
#
#  [KFSQA-858] PUR-4 POA Changes to routing and permissions
#
#  [KFSQA-882] GLPEs are wrong on Purchase Order Amendments (POAs)
#
#  [KFSQA-994] I CREATE A CAPITAL ASSET REQS E2E (Individual Assets/New)
#
#  [KFSQA-995] Create a Capital Asset starting with Base Function attributes and change Asset to System Type of One System with a System State of New System. Take the asset from Requisition to APO to PREQ to CAB and to Payment.
#
#  [KFSQA-997] First, create a initial Capital Asset with Base Function attributes. Second, create a modification to this asset. Keep the System Type
#              of Individual Assets but with a System State of Modify Existing System. Retrieve the previously created asset for modification. Take
#              the asset from Requisition to APO to PREQ to CAB and to Payment.
#
#  [KFSQA-998] First, create a initial Capital Asset with Base Function attributes. Second, create a modification to this asset. Keep the System Type
#              of One System but with a System State of Modify Existing System. Retrieve the previously created asset for modification. Take
#              the asset from Requisition to APO to PREQ to CAB and to Payment.
#
#  [KFSQA-996] Create a Capital Asset starting with Base Function attributes and change Asset to System Type of Multiple System with a System State of New System. Take the asset from Requisition to APO to PREQ to CAB and to Payment.
#
#  [KFSQA-999]  First, create a initial Capital Asset with Base Function attributes. Second, create a modification to this asset. Change REQS System Type to Multiple System with a System State of Modify Existing System. Retrieve the previously created asset for modification. Take the asset from Requisition to APO to PREQ to CAB and to Payment.
#
#  [KFSQA-967]  System should not allow POA to be created that contains accounts with 0% distribution
#
#  @KFSQA-853 @BaseFunction @REQS @PO @PREQ @PDP @Routing @coral
#  Scenario: PUR-5 Sensitive Commodity Data Flag enh
#    Given I initiate a Requisition document with the following:
#      | Vendor Type        | NonB2B    |
#      | Add Vendor On REQS | No        |
#      | Positive Approval  | Unchecked |
#      | Account Type       | NonGrant  |
#      | Commodity Code     | Sensitive |
#      | Amount             | GT APO    |
##    | Default PM         | P           |
#  # default PM can be implemented after alternate PM is moved to upgrade
#    When  I extract the Requisition document to SciQuest
#    And   I initiate a Payment Request document
#
#  @KFSQA-854 @BaseFunction @Routing @coral
#  Scenario Outline: POs Follow Routing per Organization Review (ORG 0100)
#    Given I initiate a Requisition document with the following:
#      | Vendor Type        | NonB2B    |
#      | Add Vendor On REQS | No        |
#      | Positive Approval  | Unchecked |
#      | Account Type       | NonGrant  |
#      | Commodity Code     | Sensitive |
#      | Amount             | <amount>  |
#      | Level              | <level>   |
#      | Routing Check      | Base Org  |
#  #    |Default PM         | P          |
#    # default PM can ve implemented after alternate PM is moved to upgrade
#    Then  the Requisition document routes to the correct individuals based on the org review levels
#    When  I extract the Requisition document to SciQuest
#    Then  the Purchase Order document routes to the correct individuals based on the org review levels
#    And   I initiate a Payment Request document
#  Examples:
#    | amount  | level |
#    | 100000  | 1     |
#    | 500000  | 2     |
#    | 5000000 | 3     |
#
#  @KFSQA-855 @BaseFunction @Routing @coral
#  Scenario Outline: PUR-10  remove commodity review from PO
#    Given I initiate a Requisition document with the following:
#      | Vendor Type        | NonB2B      |
#      | Add Vendor On REQS | No          |
#      | Positive Approval  | Unchecked   |
#      | Account Type       | NonGrant    |
#      | Commodity Code     | Sensitive   |
#      | Amount             | <amount>    |
#      | Routing Check      | Commodity   |
##    |Default PM         | P           |
#  # default PM can be implemented after alternate PM is moved to upgrade
#    Then  the Commodity Reviewer is in the routing log for Requisition document
#    When  I extract the Requisition document to SciQuest
#    Then  the Commodity Reviewer is not in the routing log for Purchase Order document
#    And   I initiate a Payment Request document
#  Examples:
#    | amount |
#    | GT APO |
#    | LT APO |
#
#  @KFSQA-858 @BaseFunction @POA @PDP @coral
#  Scenario: PUR-4 POA Changes to routing and permissions
#    Given I initiate a Requisition document with the following:
#      | Vendor Type        | NonB2B    |
#      | Add Vendor On REQS | Yes       |
#      | Positive Approval  | Unchecked |
#      | Account Type       | NonGrant  |
#      | Commodity Code     | Regular   |
#      | Amount             | LT APO    |
##    | Default PM         | P           |
#  # default PM can be implemented after alternate PM is moved to upgrade
#    When  I extract the Requisition document to SciQuest
#    And   I initiate a Purchase Order Amendment document
#    Then the POA Routes to the FO
#    When  I initiate a Payment Request document
#
#  @KFSQA-882 @BaseFunction @POA @PO @coral
#  Scenario: GLPEs are wrong on Purchase Order Amendments (POAs)
#    Given I initiate a Requisition document with the following:
#      | Vendor Type        | NonB2B    |
#      | Add Vendor On REQS | Yes       |
#      | Positive Approval  | Unchecked |
#      | Account Type       | NonGrant  |
#      | Commodity Code     | Regular   |
#      | Amount             | GT APO    |
##    | Default PM         | P           |
#  # default PM can be implemented after alternate PM is moved to upgrade
#    When  I extract the Requisition document to SciQuest
#    And   I initiate a Purchase Order Amendment document with the following:
#      | Item Quantity | 1   |
#      | Item Cost     | 100 |
#    Then the Purchase Order Amendment document's GLPE tab shows the new item amount
#
#  @KFSQA-994 @KFSQA-995 @KFSQA-996 @E2E @REQS @PO @PREQ @PDP @coral
#  Scenario Outline: I CREATE A CAPITAL ASSET REQS E2E (Individual Assets/New)/(One System/New System)/(Multiple Systems/New System)
#    Given I initiate a Requisition document with the following:
#      | Vendor Type        | NonB2B            |
#      | Add Vendor On REQS | Yes               |
#      | Positive Approval  | Unchecked         |
#      | Account Type       | NonGrant          |
#      | Amount             | 1000              |
#      | CA System Type     | <CA System Type>  |
#      | CA System State    | New System        |
#
##    |Default PM         | P           |
## default PM can be implemented after alternate PM is moved to upgrade
#    And  I extract the Requisition document to SciQuest
#    When I initiate a Payment Request document
#    And  I run the nightly Capital Asset jobs
#    And  I build a Capital Asset from AP transaction
#    Then I format and process the check with PDP
#  Examples:
#  | CA System Type     |
#  | Individual Assets  |
#  | One System         |
#  | Multiple Systems   |
#
#  @KFSQA-997 @KFSQA-998 @KFSQA-999 @E2E @REQS @PO @PREQ @PDP @coral
#  Scenario Outline: Modify a Capital Asset REQS E2E (Individual Asset/Modify Existing System)/(One System/Modify Existing System)/(Multiple Systems/Modify Existing System)
#    Given I initiate a Requisition document with the following:
#      | Vendor Type        | NonB2B                  |
#      | Add Vendor On REQS | Yes                     |
#      | Positive Approval  | Unchecked               |
#      | Account Type       | NonGrant                |
#      | Amount             | 1000                    |
#      | CA System Type     | <CA System Type>        |
#      | CA System State    | New System              |
#
##    |Default PM         | P           |
## default PM can be implemented after alternate PM is moved to upgrade
#    And  I extract the Requisition document to SciQuest
#    When I initiate a Payment Request document
#    And  I run the nightly Capital Asset jobs
#    And  I build a Capital Asset from AP transaction
## new REQS to modify CA created from above
#    Given I initiate a Requisition document with the following:
#      | Vendor Type        | NonB2B                  |
#      | Add Vendor On REQS | Yes                     |
#      | Positive Approval  | Unchecked               |
#      | Account Type       | NonGrant                |
#      | Amount             | 1000                    |
#      | CA System Type     | <CA System Type>        |
#      | CA System State    | Modify Existing System  |
#
##    |Default PM         | P           |
## default PM can be implemented after alternate PM is moved to upgrade
#    And  I extract the Requisition document to SciQuest
#    When I initiate a Payment Request document
#    And  I run the nightly Capital Asset jobs
#    And  I modify existing Capital Asset from AP transaction and apply payment
#    Then I format and process the check with PDP
#  Examples:
#    | CA System Type     |
#    | Individual Assets  |
#    | One System         |
#    | Multiple Systems   |
#
#  @KFSQA-967 @PO @POA @REQS @coral
#  Scenario: System should not allow POA to be created that contains accounts with 0% distribution
#    Given I initiate a Requisition document with the following:
#      | Vendor Type        | NonB2B    |
#      | Add Vendor On REQS | Yes       |
#      | Positive Approval  | Unchecked |
#      | Account Type       | NonGrant  |
#      | Commodity Code     | Regular   |
#      | Amount             | LT APO    |
#    When  I extract the Requisition document to SciQuest
#    And   I create a Purchase Order Amendment document
#    And   I add an Accounting Line to Item #1 on the Purchase Order Amendment document with 0 percent
#    And   I calculate the Purchase Order Amendment document
#    When  I submit the Purchase Order Amendment document
#    Then  I should get these error messages:
#      | Item 1 has an invalid accounting percentage. Accounting lines cannot be 0%. |
#      | Item 1 has an impermissible 0% accounting line.                             |
