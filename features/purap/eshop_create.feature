Feature: eSHOP Create

  [KFSQA-731] Create an e-SHOP order using a business to business vendor with an
              APO limit. Create order above the APO limit, but below the super-user
              APO limit. Check that order routes to Fiscal Officer for approval.

  @KFSQA-731 @E2E @PURAP @REQS @e-SHOP @cornell @wip1 @pending
  Scenario: Create e-shop order when the items' total is greater than the business
            to business total amount allowed for auto PO and less than business to
            business total amount allowed for superuser auto PO and verify the document
            routes to the fiscal officer.
    # Given I Initiate an eShop Order (Base Function)
    Given I am logged in as an e-SHOP User
    When  I go to the e-SHOP main page
    And   I search for an e-SHOP item with a Non-Sensitive Commodity Code
    And   I add e-SHOP items to my cart until the cart total reaches the Business to Business Total Amount For Automatic Purchase Order limit
    And   I view my e-SHOP cart
    And   I add a note to my e-SHOP cart
    And   I submit my e-SHOP cart
    Then  Payment Request Positive Approval Required is checked
    And   the e-SHOP cart has an associated Requisition document

    And   I stop here because The above steps should be rolled into a base function!

    When  I view the Requisition document
    And   I add these Accounting Lines to the Requisition document:
      | chart_code | account_number | object | amount |
      | 1          | 2              | 3      | 4      |
      | 5          | 6              | 7      | 8      |
    And   I calculate my Requisition document
    And   I submit the Requisition document
    Then  the document status is APPROVED
    And   the next pending action for the Requisition document is an APPROVE from a Fiscal Officer

