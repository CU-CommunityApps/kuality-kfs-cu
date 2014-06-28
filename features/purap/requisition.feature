Feature: Requistion

  [KFSQA-860] Create a Requisition document with an item amount under the DOLLAR_THRESHOLD_REQUIRING_AWARD_REVIEW
  and ensure proper routing either to Final that skips Node RequiresAwardReview
  [KFSQA-864] Verify routing with added accounting lines

  @KFSQA-860 @PREQ @Routing @tortoise
  Scenario: Requisition under dollar threshold Requiring Award Review
    Given I login as a KFS user to create an REQS
    And   I create the Requisition document with an Award Account and items that total less than the dollar threshold Requiring Award Review
    And   I submit the Requisition document
    When  I route the Requisition document to final
    Then  Award Review is not in the Requisition document workflow history

  @wip @KFSQA-864 @REQS @PREQ @Routing @PDP @POA
  Scenario: Financial Officer can add other accounts to REQ and document route to another FO - Implement KFSMI-8165 Test 1
  Given I submit a Requisition document with the following:
    | Vendor Type        | NonB2B    |
    | Add Vendor On REQS | Yes       |
    | Positive Approval  | Unchecked |
    | Account Type       | NonGrant  |
    | Commodity Code     | Regular   |
    | Amount             | GT APO    |
    And During Approval of the Requisition the Financial Officer adds a second line item for a second account
#    Then the Requisition document routes to the correct individuals based on the org review levels
    And I view the Requisition document from the Requisitions search
    Then  the next pending action for the Requisition document is an IN ACTION LIST from a  KFS-SYS Accounting Reviewer 0001 IT KFST

  @wip @KFSQA-864 @REQS @PREQ @Routing @PDP @POA @coral @over20min
  Scenario: Financial Officer can add other accounts to POA and docs route to another FO - Implement KFSMI-8165 Test 2
    Given I submit a Requisition document with the following:
      | Vendor Type        | NonB2B    |
      | Add Vendor On REQS | Yes       |
      | Positive Approval  | Unchecked |
      | Account Type       | NonGrant  |
      | Commodity Code     | Regular   |
      | Amount             | GT APO    |
#    | Default PM         | P           |
  # default PM can ve implemented after alternate PM is moved to upgrade
    And   During Approval of the Requisition the Financial Officer adds a second line item for a second account
    When  I extract the Requisition document to SciQuest
    And I submit a Purchase Order Amendment document with the following:
      | Default |      |
    And   During Approval of the Purchase Order Amendment the Financial Officer adds a line item
#    And I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And I view the Requisition document on my action list
    And I open the Purchase Order Amendment on the Requisition document
#    Then  the Purchase Order document routes to the correct individuals based on the org review levels
#    And I view the Requisition document from the Requisitions search
    Then  the next pending action for the Purchase Order Admendment document is an APPROVE from a KFS-SYS Accounting Reviewer
