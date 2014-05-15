Feature: Labor Distribution

  @KFSQA-974 @pending @wip
  Scenario: test created LD data and page objects for BT.
    Given I am logged in as "rae28"
    And   I start an empty Benefit Expense Transfer document
    And   I search and retrieve Ledger Balance entry
    And   I copy source account to target account
#    And   I change target account number to '1258320'
    And   I change target sub account number to '3003'
    And   I submit the Benefit Expense Transfer document
    And   the Benefit Expense Transfer document goes to ENROUTE
    And   I switch to the user with the next Pending Action in the Route Log for the Benefit Expense Transfer document
    And   I view the Benefit Expense Transfer document
#    And   I approve the Benefit Expense Transfer document
#    And   the Benefit Expense Transfer document goes to ENROUTE
##    And   I switch to the user with the next Pending Action in the Route Log for the Benefit Expense Transfer document
##    And   I view the Benefit Expense Transfer document
##    And   I approve the Benefit Expense Transfer document
##    And   the Benefit Expense Transfer document goes to FINAL

  @KFSQA-974 @ProcessImprovement @pending @wip
  Scenario: test created LD data and page objects for ST.
    Given I am logged in as "rae28"
    And   I start an empty Salary Expense Transfer document
    And   I search and retrieve Ledger Balance entry
    And   I copy source account to target account
    And   I change target account number to 'G264700'
#    And   I change target sub account number to '3003'
    And   I submit the Salary Expense Transfer document
    And   the Salary Expense Transfer document goes to ENROUTE
    And   I switch to the user with the next Pending Action in the Route Log for the Salary Expense Transfer document
    And   I view the Salary Expense Transfer document
#    And   I approve the Salary Expense Transfer document
#    And   the Salary Expense Transfer document goes to ENROUTE
#    And   I switch to the user with the next Pending Action in the Route Log for the Salary Expense Transfer document
#    And   I view the Salary Expense Transfer document
#    And   I approve the Salary Expense Transfer document
#    And   the Salary Expense Transfer document goes to FINAL
