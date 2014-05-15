Feature: Create Asset Fabrication Maintenance Document

  [wip] THESE ARE TO SHOW DATA PAGE OBJECTS ARE WORKING WILL BE DELETED BEFORE MERGE WITH MASTER
  Create a FMD to test data object

  @wip @pending
  Scenario: Create a Asset Fabrication Maintenance Document
    Given I am logged in as "eap2"
    And   I create a Asset Fabrication Maintenance Document
    Then  the Asset Fabrication Maintenance Document Document saves with no errors

  @wip @pending
  Scenario: Create a Pre Asset Tagging Document
    Given I am logged in as "eap2"
    And   I create a Pre Asset Tagging Document
    Then  the Asset Fabrication Maintenance Document Document saves with no errors