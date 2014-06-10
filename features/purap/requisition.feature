Feature: Requistion

  [KFSQA-860] Create a Requisition document with an item amount under the DOLLAR_THRESHOLD_REQUIRING_AWARD_REVIEW
              and ensure proper routing either to Final that skips Node RequiresAwardReview

  @KFSQA-860 @PREQ @Routing @tortoise
  Scenario: Requisition under dollar threshold Requiring Award Review
    Given I login as a KFS user to create an REQS
    And   I create the Requisition document with an Award Account and items that total less than the dollar threshold Requiring Award Review
    And   I submit the Requisition document
    When  I route the Requisition document to final
    Then  Award Review is not in the Requisition document workflow history