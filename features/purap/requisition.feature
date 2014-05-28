Feature: Requistion

  [KFSQA-860] Create a Requisition document with an item amount under the DOLLAR_THRESHOLD_REQUIRING_AWARD_REVIEW
              and ensure proper routing either to Final that skips Node RequiresAwardReview

  @KFSQA-860 @PREQ @Routing @coral
  Given I initiate a Requisition document
  And   I add an Award Account
  And   I enter items that total less than the DOLLAR_THRESHOLD_REQUIRING_AWARD_REVIEW parameter
  And   I submit the Requisition document
  When  I route the Requisition document to FINAL by clicking approve for each request
  Then  the RequiresAwardReview Node is skipped
