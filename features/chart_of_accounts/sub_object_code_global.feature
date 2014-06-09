Feature: Sub Object Code Global

  [KFSQA-617] Sub-Object Global Lookup Modification, As a KFS Chart Manager, on
              the Sub-Object Global, I want to add multiple account lines using
              using Organizational Codes to be efficient.

  @KSFQA-617 @cornell @AcctLookup @KITI-2953 @sloth
  Scenario: Create a Sub-Object Code Global using an organization hierarchy
    Given I am logged in as a KFS Chart Manager
    And   I save a Sub-Object Code Global document
    When  I add multiple account lines using Organization Code 9002
    Then  retrieved accounts equal all Active Accounts for these Organization Codes:
      | U018313 |
      | U018306 |
      | U018314 |
      | U018309 |
      | U018302 |
      | U018315 |
      | U018310 |
      | U018303 |
      | U018311 |
      | U018307 |
      | U018312 |
      | U018304 |
      | U018301 |
      | U018308 |

