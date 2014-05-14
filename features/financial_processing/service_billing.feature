Feature: Service Billing

  [KFSQA-668] IB e2e Test Business Process (Basic)

  @KFSQA-668 @nightly-jobs
  Scenario: SB Authorization Error and E2E
    Given   I am logged in as a KFS User
    And     I attempt to start an empty Service Billing document
    And     I should get an Authorization Exception Report error
    And     I am logged in as a KFS User for the SB document
    And     I start an empty Service Billing document
    And     I add a Source Accounting Line to the Service Billing document with the following:
      | Chart Code   | IT      |
      | Number       | U243700 |
      | Object Code  | 4023    |
      | Amount       | 100     |
    And     I add a Target Accounting Line to the Service Billing document with the following:
      | Chart Code   | IT      |
      | Number       | G013300 |
      | Object Code  | 4023    |
      | Amount       | 100     |
    And     I save the Service Billing document
    And     the Service Billing document accounting lines equal the General Ledger Pending entries
    And     I submit the Service Billing document
    And     the Service Billing document goes to FINAL
    And     I am logged in as a KFS Technical Administrator
    And     Nightly Batch Jobs run
    When    I am logged in as a KFS Chart Manager
    Then    the Service Billing document accounting lines equal the General Ledger entries
