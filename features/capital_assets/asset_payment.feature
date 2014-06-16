Feature: Asset Payment

  [KFSQA-969] Submit an allocated asset manual payment where total allocations are not equal to the asset line. Test that trying to submit the out of balance payment
              displays an error. Correct the transaction so that allocations equal asset line and test payment can be submitted without an error.

  @KFSQA-969 @KFSMI-8992 @cornell @slug
  Scenario: Capital Asset Allocations of Manual Payment Out of Balance with Asset Line
    Given I Login as an Asset Processor
    And   I start an empty Asset Manual Payment document
    And   I add an Asset with the following fields:
      | Asset Number       | 502985     |
      | Allocation Amount  | 800        |
      | Line Number        | 0          |
    And   I add an Asset with the following fields:
      | Asset Number       | 502855     |
      | Allocation Amount  | 1000       |
      | Line Number        | 1          |
    And   I add an Accounting Line to the Asset Manual Payment with the following fields:
      | Number       | R123400        |
      | Object Code  | 3630           |
      | Amount       | 1800           |
    And   I add an Accounting Line to the Asset Manual Payment with the following fields:
      | Number       | G254700        |
      | Object Code  | 3630           |
      | Amount       | 500            |
    When  I submit the Asset Manual Payment document
    Then  I should get an error saying "Asset payment allocation by amount must equal asset payments"
    And   I change the Account Amount for Accounting Line 1 to 800 for Asset Manual Payment
    And   I change the Account Amount for Accounting Line 2 to 1000 for Asset Manual Payment
    When  I submit the Asset Manual Payment document and confirm any questions
    Then  the Asset Manual Payment document goes to FINAL

