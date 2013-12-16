Feature: Roles Administration

  As an administrator, I want to be able to set up
  roles in the system, so that I can control what
  the system users can do.

  Scenario: Adding an unassigned user to a Group in a Financial Processing Role
    Given I am backdoored as "khuntley"
    And   I create a Group
    And   I am backdoored as "admin"
    And   create an 'unassigned' User
    And   create a Role with permission to create financial processing documents
    And   add the Group to the Role
    When  I add the User to the Group
    Then  the User should be able to create a financial processing document