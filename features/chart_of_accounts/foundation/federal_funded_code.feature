Feature: Federal Funded Code

  [KFSPRJQ-307]

  @KFSPRJQ-307 @wip @foundation
  Scenario: Verify document error messages display for a Federal Funded Code
    Given I am logged in as a KFS Chart Manager
    When I create a blank Federal Funded Code
    And I submit the document
    Then I should get these error messages:
    | Document Description (Description) is a required field. |
    | Federal Funded Code (FedFundCd) is a required field.    |
    | Federal Funded Name (Name) is a required field.         |
    When I enter a description of 'KFSPRJQ-307 new'
    And I save the document
    Then The document should save successfully

  @KFSPRJQ-307 @wip @foundation
  Scenario: Create a Federal Funded Code
    Given I am logged in as a KFS Chart Manager
    When I create the Federal Funded Code with:
    | code | Z  |
    | name | Test FF new |
    | active | set      |
    #if Code already exists then this test will fail
    And I blanket approve the document
    Then I should be on the Maintenance tab

  @KFSPRJQ-307 @wip @foundation
  Scenario: View an existing Federal Funded Code
    Given I am logged in as a KFS Chart Manager
    When I select a random Federal Funded Code
    Then the Federal Funded Code data displays on the inquiry screen

  @KFSPRJQ-307 @wip @foundation
  Scenario: Copy a Federal Funded Code
    Given I am logged in as a KFS Chart Manager
    When I copy a random Federal Funding Code
    And I enter a description of 'KFSPRJQ-307 copy'
    And I enter a Federal Funded Code of 'Y'
    And I submit the document
    Then The document should submit successfully


  @KFSPRJQ-307 @wip @foundation
  Scenario: Edit an existing Federal Funded Code
    Given I am logged in as a KFS Chart Manager
    When I edit a random active Federal Funding Code
    And I enter a description of 'KFSPRJQ-307 edit'
    And I enter a Federal Funded Name of 'Test HEF Edit'
    And I submit the document
    Then The document should submit successfully

  @KFSPRJQ-307 @wip @foundation
  Scenario: Edit an inactive existing Federal Funded Code
    Given I am logged in as a KFS Chart Manager
    When I edit a random inactive Federal Funding Code
    And I enter a description of 'KFSPRJQ-307 inactive'
    Then I verify the Active Indicator is not checked on the Federal Funding Code
    And I submit the document
    Then The document should submit successfully


