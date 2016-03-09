Feature: Requistion
#
#  [KFSQA-860] Create a Requisition document with an item amount under the DOLLAR_THRESHOLD_REQUIRING_AWARD_REVIEW
#  and ensure proper routing either to Final that skips Node RequiresAwardReview
#  [KFSQA-864] Verify routing with added accounting extra lines during approval on the Requisition and Purchase Order
#
#  @KFSQA-860 @PREQ @Routing @tortoise
#  Scenario: Requisition under dollar threshold Requiring Award Review
#    Given I am logged in as a KFS User for the REQS document
#    And   I create the Requisition document with an Award Account and items that total less than the dollar threshold Requiring Award Review
#    And   I submit the Requisition document
#    When  I route the Requisition document to final
#    Then  Award Review is not in the Requisition document workflow history
#
#  @KFSQA-864 @REQS @PREQ @Routing @PDP @POA @coral
#  Scenario: Financial Officer can add other accounts to REQ and document route to another FO - Implement KFSMI-8165 Test 1
#  Given I submit a Requisition document with the following:
#    | Vendor Type        | NonB2B    |
#    | Add Vendor On REQS | Yes       |
#    | Positive Approval  | Unchecked |
#    | Account Type       | NonGrant  |
#    | Commodity Code     | Regular   |
#    | Amount             | GT APO    |
#    And  I view the Requisition document from the Requisitions search
#    And  I switch to the user with the next Pending Action in the Route Log for the Requisition document
#    And  I view the Requisition document on my action list
#    And  I set the added account percent to 50
#    And  I add these Accounting Lines to Item #1 on the Requisition document:
#      | Chart Code | Account Number       | Object Code | Percent |
#      | Default    | 1093603              | 6570        | 50      |
#    And  I calculate the Requisition document
#    And  I approve the Requisition document
#    And  I view the Requisition document from the Requisitions search
#    Then the next pending action for the Requisition document is an IN ACTION LIST from a  KFS-SYS Accounting Reviewer
#
#  @KFSQA-864 @REQS @PREQ @Routing @PDP @POA @coral
#  Scenario: Financial Officer can add other accounts to POA and docs route to another FO - Implement KFSMI-8165 Test 2
#    Given I submit a Requisition document with the following:
#      | Vendor Type        | NonB2B    |
#      | Add Vendor On REQS | Yes       |
#      | Positive Approval  | Unchecked |
#      | Account Type       | NonGrant  |
#      | Commodity Code     | Regular   |
#      | Amount             | GT APO    |
#    And  I view the Requisition document from the Requisitions search
#    And  I switch to the user with the next Pending Action in the Route Log for the Requisition document
#    And  I view the Requisition document on my action list
#    And  I set the added account percent to 50
#    And  I add these Accounting Lines to Item #1 on the Requisition document:
#      | Chart Code | Account Number       | Object Code | Percent |
#      | Default    | 1271001              | 6570        | 50      |
#    And  I calculate the Requisition document
#    And  I approve the Requisition document
#    When I extract the Requisition document to SciQuest
#    And  I submit a Purchase Order Amendment document
#    And  I view the Requisition document from the Requisitions search
#    And  I open the Purchase Order Amendment on the Requisition document
#    Then the next pending action for the Requisition document is an APPROVE from a  KFS-SYS Fiscal Officer IT
