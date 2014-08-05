Feature: eSHOP Create

  [KFSQA-731] Create an e-SHOP order using a business to business vendor with an
              APO limit. Create order above the APO limit, but below the super-user
              APO limit. Check that order routes to Fiscal Officer for approval.

  @KFSQA-731 @E2E @PURAP @REQS @e-SHOP @cornell @slug
  Scenario: Create e-shop order when the items' total is greater than the business
            to business total amount allowed for auto PO and less than business to
            business total amount allowed for superuser auto PO and verify the document
            routes to the fiscal officer.
    Given I am logged in as an e-SHOP User
    When  I go to the e-SHOP main page
    And   I search for an e-SHOP item with a Non-Sensitive Commodity Code
    And   I add e-SHOP items to my cart until the cart total reaches the Business to Business Total Amount For Automatic Purchase Order limit
    And   I view my e-SHOP cart
    And   I add a note to my e-SHOP cart
    And   I submit my e-SHOP cart
    And   I add a random address to the Delivery tab on the Requisition document
    And   I add a random Requestor Phone number to the Requisition document
    And   I add these Accounting Lines to Item #1 on the Requisition document:
      | chart_code | account_number       | object_code | amount |
      | Default    | Unrestricted Account | Expenditure | 10     |
    And   I calculate the Requisition document
    And   I submit the Requisition document
    Then  the document should have no errors
    When  I reload the Requisition document
    Then  Payment Request Positive Approval Required is not required
    And   the e-SHOP cart has an associated Requisition document
    And   the document status is ENROUTE
    And   the next pending action for the Requisition document is an APPROVE from a Fiscal Officer

  @KFSQA-856 @BaseFunction @PDP @PO @PREQ @REQS @coral
  Scenario: e-SHOP to PO to PREQ to PDP
    Given I initiate an e-SHOP order
    When  I route the Requisition document to final
    And   I extract the Requisition document to SciQuest
    And   I initiate a Payment Request document
    Then  I format and process the check with PDP
