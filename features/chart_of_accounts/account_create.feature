Feature: KFS Fiscal Officer Account Creation

  As a KFS Fiscal Officer I want to create an Account
  because I want to support a new project

#  Background:
#    Given I am backdoored as bla

  Scenario: Create an Account
    Given I am logged in as a KFS Fiscal Officer
    And   I create an Account
    When  I submit the Account
    Then  the Account Maintenance Document goes to final