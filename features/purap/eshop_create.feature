Feature: eSHOP Create
#
#  [KFSQA-731] Create an e-SHOP order using a business to business vendor with an
#              APO limit. Create order above the APO limit, but below the super-user
#              APO limit. Check that order routes to Fiscal Officer for approval.
#
#  {KFSQS-1011] Enter an eshop order for a high dollar amount using a sensitive commodity on a Contract
#               and Grants account. Testing from Req to PO to PREQ, that the order routes through all appropriate approvals.
#               Includes: fiscal officer, contracts and grants processor, contract manager assignment, and accounting reviewers.
#
#  @KFSQA-731 @E2E @PURAP @REQS @e-SHOP @cornell @slug
#  Scenario: Create e-shop order when the items' total is greater than the business
#            to business total amount allowed for auto PO and less than business to
#            business total amount allowed for superuser auto PO and verify the document
#            routes to the fiscal officer.
#    Given I am logged in as an e-SHOP User
#    When  I go to the e-SHOP main page
#    And   I search for an e-SHOP item with a Non-Sensitive Commodity Code
#    And   I add e-SHOP items to my cart until the cart total reaches the Business to Business Total Amount For Automatic Purchase Order limit
#    And   I view my e-SHOP cart
#    And   I add a note to my e-SHOP cart
#    And   I submit my e-SHOP cart
#    And   I add a random address to the Delivery tab on the Requisition document
#    And   I add a random Requestor Phone number to the Requisition document
#    And   I add these Accounting Lines to Item #1 on the Requisition document:
#      | Chart Code | Account Number       | Object Code | Amount |
#      | Default    | Unrestricted Account | Expenditure | 10     |
#    And   I calculate the Requisition document
#    And   I submit the Requisition document
#    Then  the document should have no errors
#    When  I reload the Requisition document
#    Then  Payment Request Positive Approval Required is not required
#    And   the e-SHOP cart has an associated Requisition document
#    And   the document status is ENROUTE
#    And   the next pending action for the Requisition document is an APPROVE from a Fiscal Officer
#
#  @KFSQA-856 @BaseFunction @PDP @PO @PREQ @REQS @coral
#  Scenario: e-SHOP to PO to PREQ to PDP
#    Given I initiate an e-SHOP order
#    When  I route the Requisition document to final
#    And   I extract the Requisition document to SciQuest
#    And   I initiate a Payment Request document
#    Then  I format and process the check with PDP
#
#  @KFSQA-1011 @E2E @PURAP @PO @PREQ @REQS @smoke @Routing @coral
#  Scenario: Enter an eshop order for a high dollar amount using a sensitive commodity on a Contract
#            and Grants account. Testing from Req to PO to PREQ, that the order routes through all appropriate approvals.
#            Includes: fiscal officer, contracts and grants processor, contract manager assignment, and accounting reviewers.
#    Given I am logged in as an e-SHOP Plus User without a favorite account
#    And   I go to the e-SHOP main page
#    And   I view my e-SHOP cart
#    And   I clear my e-SHOP cart
#    And   I go to the e-SHOP main page
#    And   I search for an e-SHOP item with a Sensitive Commodity Code
#    When  I add over $10000000 worth of e-SHOP items to my cart
#    And   I view my e-SHOP cart
#    And   I add a note to my e-SHOP cart
#    And   I submit my e-SHOP cart
#    And   I add a random address to the Delivery tab on the Requisition document
#    And   I add a random Requestor Phone number to the Requisition document
#    And   I calculate the Requisition document
#    And   I submit the Requisition document
#    Then  I should get an error saying "Item 1 does not contain at least one account."
#    And   I add these Accounting Lines to Item #1 on the Requisition document:
#      | Chart Code | Account Number       | Object Code |
#      | Default    | Grant                | Expenditure |
#    And   I add an attachment to the Requisition document
#    And   I add a file attachment to the Notes and Attachment Tab of the Requisition document
#    And   I calculate the Requisition document
#    And   I submit the Requisition document
#    Then  the Requisition document goes to ENROUTE
#    And   I verify that the following Pending Action approvals are requested:
#      | Fiscal Officer |
#    And   I verify that the following Future Action approvals are requested:
#      | Accounting Reviewer          |
#      | Contracts & Grants Processor |
#      | Commodity Reviewer           |
#      | Separation of Duties         |
#    And   I switch to the user with the next Pending Action in the Route Log for the Requisition document
#    And   I view the Requisition document on my action list
#    And   I change to Capital Asset object code
#    And   I calculate the Requisition document
#    And   I approve the Requisition document
#    Then  I should get an error saying "Capital Assets are being purchased - the information in the Capital Asset tab must be completed."
#    And   I fill in Capital Asset tab on Requisition document with:
#      | CA System Type  | One System  |
#      | CA System State | New System  |
#    And   I calculate the Requisition document
#    When  I approve the Requisition document
#    Then  the Requisition document goes to ENROUTE
#    When  I route the Requisition document to final
#    Then  the Requisition document goes to FINAL
#    Given I am logged in as a Purchasing Processor
#    When  I submit a Contract Manager Assignment for the Requisition
#    Given I am logged in as a PURAP Contract Manager
#    And   I retrieve the Requisition document
#    When  the View Related Documents Tab PO Status displays
#    Then  the Vendor Choice is populated
#    And   I calculate and verify the GLPE tab
#    When  I submit the Purchase Order document
#    Then  the Purchase Order document goes to ENROUTE
#    Given I switch to the user with the next Pending Action in the Route Log to approve Purchase Order document to Final
#    Given I login as a Accounts Payable Processor to create a PREQ
#    And   I fill out the PREQ initiation page and continue
#    And   I enter the Qty Invoiced and calculate
#    And   I enter a Pay Date
#    And   I attach an Invoice Image to the Payment Request document
#    And   I calculate the Payment Request document
#    When  I submit the Payment Request document
#    Then  the Payment Request document goes to ENROUTE
#    Given I am logged in as FTC/BSC member User
#    Then  I can not search and retrieve the Payment Request document
#    Given I am logged in as a Sensitive Data Viewer
#    Then  I view the Payment Request document
