Feature: Vendor Edit

  [KFSQA-755] I want to edit a vendor with ownership type INDIVIDUAL.

  @KFSQA-755 @cornell @slug
  Scenario: I want to edit a vendor with ownership type INDIVIDUAL
    # "rlc56" can't view notes
    Given   I am logged in as "rlc56"
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
    Given   I am logged in as "rlc56"
    When    I edit a Vendor with Vendor Number 35495-0
    Then    the Tax Number and Notes are Not Visible on Vendor page
    And     I change the Address Line 2 on Vendor Address tab
    And     I change the Phone Extension on Vendor Phone tab
    And     I submit the Vendor document
    And     the Vendor document goes to ENROUTE
    And     I am logged in as "pag4"
    And     I select Vendor document from my Action List
    And     I change the Address Attention on Vendor Address tab
    And     I change the Phone Type on Vendor Phone tab
    And     I approve the Vendor document
    And     the Vendor document goes to FINAL
    Given   I am logged in as "rlc56"
    When    I edit a Vendor with Vendor Number 35495-0
    Then    the Tax Number and Notes are Not Visible on Vendor page
    And     the Address and Phone Number changes persist

