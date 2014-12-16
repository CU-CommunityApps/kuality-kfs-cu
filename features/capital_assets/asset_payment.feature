Feature: Asset Payment

  [KFSQA-969] Submit an allocated asset manual payment where total allocations are not equal to the asset line. Test that trying to submit the out of balance payment
              displays an error. Correct the transaction so that allocations equal asset line and test payment can be submitted without an error.

  @KFSQA-969 @KFSMI-8992 @cornell @slug @smoke @solid
  Scenario: Capital Asset Allocations of Manual Payment Out of Balance with Asset Line
    Given I Login as an Asset Processor
    And   I start an empty Asset Manual Payment document
    And   I add Asset Line 1 with Allocation Amount 800
    And   I add Asset Line 2 with Allocation Amount 1000
    And   I add an Accounting Line to the Asset Manual Payment with Amount 1800
    And   I add an Accounting Line to the Asset Manual Payment with Amount 500
    When  I submit the Asset Manual Payment document
    Then  I should get an error saying "Asset payment allocation by amount must equal asset payments"
    And   I change the Account Amount for Accounting Line 1 to 800 for Asset Manual Payment
    And   I change the Account Amount for Accounting Line 2 to 1000 for Asset Manual Payment
    When  I submit the Asset Manual Payment document and confirm any questions
    Then  the Asset Manual Payment document goes to FINAL

