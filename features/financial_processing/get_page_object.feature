Feature: Create page object

  Want to be able to get all the elements on a page to quickly create page objects for testing

  Scenario: get page objects for any page
    Given I am am logged in as a KFS Chart Administrator
    When I visit the somethig page
    Then I get all the page objects from the page
