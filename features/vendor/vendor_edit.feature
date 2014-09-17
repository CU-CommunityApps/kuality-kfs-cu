Feature: Vendor Edit

  [KFSQA-755] I want to edit a vendor with ownership type INDIVIDUAL.

  [KFSQA-773] PO Vendor Edit, with Expired Insurance.
  
  [KFSQA-839] Cornell modified the routing of Vendor eDocs to always include a second review.
              Whenever Create-New or Lookup-Edit (Role CU Vendor Initiator) change a vendor
              record --- a second reviewer (assigned the role Vendor Reviewer Omit Initiator)
              needs to approve the eDoc. Additionally, Cornell has added roles to
              1) View attachments ---Vendor Attachment viewer (cu), and,
              2) Update the Contract Tab --- Vendor Contract Editor (cu).
              Moreover, Cornell added (as display on addresses) the KFS internal
              data element named Vendor Address Generated Identifier.

  [KFSQA-839] I am able to edit a vendor's contract information using the new role Vendor Contract Editor

  @KFSQA-755 @cornell @slug @E2E @VendorEdit
  Scenario: I want to edit a vendor with ownership type INDIVIDUAL
    Given   I am logged in as a Vendor Initiator
    When    I edit a Vendor with Vendor Number 35495-0
    Then    the Tax Number and Notes are Not Visible on Vendor page
    And     I change the Address Line 1 on Vendor Address tab
    And     I change the Phone Number on Vendor Phone tab
    And     I submit the Vendor document
    And     the Vendor document goes to ENROUTE
    And     I am logged in as a Vendor Reviewer
    And     I select Vendor document from my Action List
    And     I change the Address Line 1 on Vendor Address tab
    And     I change the Phone Number on Vendor Phone tab
    And     I approve the Vendor document
    And     the Vendor document goes to FINAL
    Given   I am logged in as a Vendor Initiator
    When    I edit a Vendor with Vendor Number 35495-0
    Then    the Tax Number and Notes are Not Visible on Vendor page
    And     I change the Address Line 2 on Vendor Address tab
    And     I change the Phone Extension on Vendor Phone tab
    And     I submit the Vendor document
    And     the Vendor document goes to ENROUTE
    And     I switch to the user with the next Pending Action in the Route Log for the Vendor document
    And     I select Vendor document from my Action List
    And     I change the Address Attention on Vendor Address tab
    And     I change the Phone Type on Vendor Phone tab
    And     I approve the Vendor document
    And     the Vendor document goes to FINAL
    Given   I am logged in as a Vendor Initiator
    When    I edit a Vendor with Vendor Number 35495-0
    Then    the Tax Number and Notes are Not Visible on Vendor page
    And     the Address and Phone Number changes persist

  @KFSQA-773 @cornell @slug @E2E @VendorEdit
  Scenario: PO Vendor Edit, with Expired Insurance.
    # user who can initiate/blanket approve vendor
    Given   I am logged in as a Vendor Initiator and Manager
    When    I edit a Vendor with Vendor Number 12587-1
    And     I update the General Liability with expired date
    And     I blanket approve the Vendor document with expired liability date
    Then    the Vendor document goes to FINAL
    Given   I am logged in as a Vendor Initiator
    When    I edit a Vendor with Vendor Number 12587-1
    And     I change the Address Line 1 on Vendor Address tab
    And     I change the Phone Number on Vendor Phone tab
    And     I submit the Vendor document with expired liability date
    Then    the Vendor document goes to ENROUTE
    And     I switch to the user with the next Pending Action in the Route Log for the Vendor document
    And     I select Vendor document from my Action List
    Then    the changes to Vendor document have persisted
    And     I change the Address Line 2 on Vendor Address tab
    And     I change the Phone Extension on Vendor Phone tab
    And     I close and save the Vendor document
    And     I select Vendor document from my Action List
    Then    the changes to Vendor document have persisted
    And     I approve the Vendor document with expired liability date
    Then    the Vendor document goes to FINAL
    # TODO : This should be the person whe just created the Vendor document.  'vendor initiator' is the first member in the role, so it should be ok in the same run
    Given   I am logged in as a Vendor Initiator
    And     I select Vendor document from my Action List
    And     I fyi the Vendor document
    When    I edit a Vendor with Vendor Number 12587-1
    Then    the changes to Vendor document have persisted

  @KFSQA-839 @cornell @VendorEdit @Routing @smoke @coral
  Scenario: Edit a vendor and ensure routing to the second reviewer. Confirm display of Vendor Address Generated Identifier. Confirm previously added attachments persist.
    Given I am logged in as a Vendor Initiator
    And   I edit a PO Vendor with Supplier Diversity
    And   I add a Supplier Diversity to the Vendor document
    And   I add a Search Alias to the Vendor document
    And   I note how many attachments the Vendor document has already
    And   I add an attachment to the Vendor document
    And   I submit the Vendor document, confirming any questions, if it is not already FINAL
    And   the next pending action for the Vendor document is an APPROVE from a KFS-VND Reviewer
    And   I route the Vendor document to final
    And   I am logged in as a Vendor Attachment viewer (cu)
    And   I open the Vendor from the Vendor document
    When  the Address Tab displays Vendor Address Generated Identifiers for each Address
    Then  the Vendor document's Notes Tab displays the added attachment

  @KFSQA-839 @cornell @VendorEdit @Routing @smoke @coral
  Scenario: I am able to edit a vendor's contract information using the new role Vendor Contract Editor
    Given I am logged in as a Vendor Contract Editor(cu)
    When  I edit a Vendor with an active Contract
    And   I edit a contract on Vendor Contract tab
    And   I submit the Vendor document, confirming any questions, if it is not already FINAL
    Then  the next pending action for the Vendor document is an APPROVE from a KFS-VND Reviewer
