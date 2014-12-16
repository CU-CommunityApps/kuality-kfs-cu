Feature: Award and Proposal

  [KFSQA-977] Edit to grant number on award should be reflected on proposal table
  [KFSQA-977] Edit an award with an inactive account
  [KFSQA-977] On award enter duplicate accounts
  [KFSQA-977] On award enter duplicate organizations
  [KFSQA-977] On award enter duplicate project directors


  @KFSQA-977, @KFSPTS-1917, @KFSUPGRADE-591 @KFSPTS-990 @Proposed @smoke @slug
  Scenario: Edit to grant number on award should be reflected on proposal table
    Given   I am logged in as a KFS Contracts & Grants Processor
    When    I create new Proposal document
    When    I submit the Proposal document
    Then    the Proposal document goes to FINAL
    When    I create a new Award document from the Proposal document
    And     the Award document is populated by the Proposal document's fields
    When    I submit the Award document
    Then    the Award document goes to FINAL
    When    I edit a previously-approved Award
    And     I change the Grant Number for the Award Document
    And     I submit the Award document
    Then    the Award document goes to FINAL
    And     I verify the Grant Number change for the Award Document persists on the Proposal Document

  @KFSQA-977, @KFSMI-5494 @Proposed @smoke
  Scenario: Edit an award with an inactive account
    Given   I am logged in as a KFS Contracts & Grants Processor
    And     I edit a random Award
    And     I deactivate the account for the Award Document
    And     I change the Grant Number for the Award Document
    When    I submit the Award document
    Then    the Award document goes to FINAL
    And     I verify Grant Number change persists on the Award document
    When   I edit a previously-approved Award
    And     I change the Grant Number for the Award Document
    When    I submit the Award document
    Then    the Award document goes to FINAL
    And     I verify Grant Number change persists on the Award document

  @KFSQA-977, @KFSUPGRADE-594 @KFSPTS-990 @Proposed @smoke
  Scenario Outline: On award enter duplicate accounts
                    On award enter duplicate organizations
                    On award enter duplicate project directors
    Given   I am logged in as a KFS Contracts & Grants Processor
    And     I edit a random Award
    And     I add an existing <collection_name> to the Award Document
    When    I submit the Award document
    Then    I should get <collection_name> exists error
    When    I delete duplicate <collection_name> from the Award document
    And     I submit the Award document
    Then    the Award document goes to FINAL
    Examples:
    | collection_name  |
    | account          |
    | organization     |
    | project director |

