Feature: Service Billing

  [KFSQA-668] IB e2e Test Business Process (Basic)

  @KFSQA-668 @nightly-jobs @wip
  Scenario: SB Authorization Error and E2E
    Given   I am logged in as "sml65"
    And     I should get an error saying "We're sorry, you are currently not authorized to perform this KFS function:"
    And     I am logged in as a KFS User
    And     I start an empty Service Billing document
    And     I add a source Accounting Line to the Service Billing document with the following:
      | Chart Code   | IT |
      | Number       | G003704 |
      | Object Code  | 4020  |
      | Amount       | 100 |
    And     I add a target Accounting Line to the Service Billing document with the following:
      | Chart Code   | IT |
      | Number       | G003704 |
      | Object Code  | 4020  |
      | Amount       | 100 |

    And     I save the Service Billing document
#    And      The SB Accounting Line equals the GLPE**
    And     I submit the Service Billing document
    And     the Service Billing document goes to ENROUTE
    And     I am logged in as a KFS Fiscal Officer
    And     I view the Service Billing document
    And     I blanket approve the Service Billing document
    And     the Service Billing document goes to FINAL

#  And      I Lookup the SB Accounting Line using Available Balances Lookup
#  And      I select Include Pending Entries
#  And      I select the Current Month from the General Ledger Balance Lookup
#  And      The General Ledger Balance Lookup displays the Document ID
#  And      The SB Accounting Line equals the displayed amounts

    And     I am logged in as a KFS Technical Administrator
    And     Nightly Batch Jobs run
    When    I am logged in as a KFS Chart Manager
    Then    the Service Billing document accounting lines equal the General Ledger entries
