Feature: Labor Distribution

  [KFSQA-983] Base Function : I create a Salary Expense Transfer

  [KFSQA-984] Base Function : I create a Benefit Expense Transfer

  [KFSQA-985] Base Function : I run the nightly Labor batch process

  [KFSQA-970] Background: Tests submission of a salary expense transfer and functionality of transfers
              between account types, calculations between rates, and labor access security between orgs.
              Required Setup Data specifications are located in the JIRA.
              Data used in this test is specified in KFS Parameter: TEST_ST_ACCOUNT_TYPES_RATES_ACCESS_SECURITY
              Data values need to be identified by the following symbols in the Parameter Values:
              initiator, employee, to_account_different_types, to_account_different_rates, user_outside_organization,
              user_inside_organization

  [KFSQA-1012] Background: This tests privileged functionality for cross divisional transfers and
               ability to edit object codes on a salary transfer edoc.
               Data used in this test is specified in KFS Parameter: TEST_ST_PRIVILEGED_CROSS_DIVISIONAL_OBJECT_EDIT
               Data values need to be identified by the following symbols in the Parameter Values:
               employee, to_account_different_types, labor_object_code


  @KFSQA-983 @BaseFunction @ST @slug @nightly-jobs @solid
  Scenario: Base Function : I create a Salary Expense Transfer
    Given I create a Salary Expense Transfer as a Salary Transfer Initiator
      | Parameter Name | TEST_ST_CREATE |
    And   I transfer the Salary to another Account in my Organization
    And   I submit the Salary Expense Transfer document
    And   the Salary Expense Transfer document goes to FINAL
    #Remaining validation will be performed after the nightly batch jobs are executed for this feature file
    Then  references to test KFSQA-983 instance data are saved for validation after batch job execution

  @KFSQA-984 @BaseFunction @BT @tortoise
  Scenario: Base Function : I create a Benefit Expense Transfer
    Given  I create a Benefit Expense Transfer with following:
      |From Account  | A464100   |
      |To Account    | A453101   |

  # Removed this scenario as a @solid AFT because the same functionality is verified in scenario KDO-557
  # "Run the labor and general ledger critical path batch jobs".
  @KFSQA-985 @BaseFunction @tortoise @nightly-jobs
  Scenario: Base Function for labor nightly batch process.
    Given I run the nightly Labor batch process
    And   I am logged in as a Salary Transfer Initiator
    # this is just an example to validate the labor batch process is OK.
    # this step requires/presumes remembered_employee_id is set to the employee id being used for the test;
    # otherwise, the default parameter employee id is used for verification
    Then  the labor ledger pending entry for employee is empty

  @KFSQA-970 @ST @smoke @coral @nightly-jobs @solid
  Scenario: Salary Expense Transfer test between account types, between rates, and for labor access security.
    Given I create a Salary Expense Transfer as a Salary Transfer Initiator
      | Parameter Name | TEST_ST_ACCOUNT_TYPES_RATES_ACCESS_SECURITY |
    And   I transfer the Salary between accounts with different Account Types
    And   I submit the Salary Expense Transfer document
    And   I remember the Salary Expense Transfer document number
    Then  I should get an error that starts with "Invalid transfer between account types"
    And   I transfer the Salary to an Account with a different Rate but the same Account Type and Organization
    And   I save the Salary Expense Transfer document
    And   the Labor Ledger Pending entries verify for the accounting lines on the Salary Expense Transfer document
    And   I submit the Salary Expense Transfer document
    And   the Salary Expense Transfer document goes to ENROUTE
    And   I route the Salary Expense Transfer document to final
    Then  the Salary Expense Transfer document goes to FINAL
    And   a Salary Expense Transfer initiator outside the organization cannot view the document
    And   a Salary Expense Transfer initiator inside the organization can view the document
    #Remaining validation will be performed after the nightly batch jobs are executed for this feature file
    Then  references to test KFSQA-970 instance data are saved for validation after batch job execution

   @KFSQA-1012 @ST @smoke @nightly-jobs @coral @solid
  Scenario: Submit a salary transfer edoc between account types, edit the object code, verify pending entries, and submit successfully.
    Given I create a Salary Expense Transfer as a Labor Distribution Manager:
      | Parameter Name | TEST_ST_PRIVILEGED_CROSS_DIVISIONAL_OBJECT_EDIT |
    And   I transfer the Salary between accounts with different Account Types
    And   I update the Labor Object Code on the Salary Expense Transfer Document
    And   I save the Salary Expense Transfer document
    And   the Labor Ledger Pending entries verify for the accounting lines on the Salary Expense Transfer document
    And   I submit the Salary Expense Transfer document
    And   the Salary Expense Transfer document goes to ENROUTE
    And   I blanket approve the Salary Expense Transfer document
    Then  the Salary Expense Transfer document goes to FINAL
    #Remaining validation will be performed after the nightly batch jobs are executed for this feature file
     Then  references to test KFSQA-1012 instance data are saved for validation after batch job execution

  @nightly-jobs @solid
  Scenario: Run Nightly batch jobs required for Labor Distribution Tests Verification
    Given   I run the nightly Labor batch process
    Then    There are no incomplete Batch Job executions

  @KFSQA-983 @validation-after-batch @solid
  Scenario: Validation For Base Function : I create a Salary Expense Transfer
    Given All Nightly Batch Jobs have completed successfully
    And   I can retrieve references to test KFSQA-983 instance data saved for validation after batch job execution
    And   I am logged in as a Labor Distribution Manager
    Then  the labor ledger pending entry for employee is empty

  @KFSQA-970 @validation-after-batch @solid
  Scenario: Validation for Salary Expense Transfer test between account types, between rates, and for labor access security
    Given All Nightly Batch Jobs have completed successfully
    And   I can retrieve references to test KFSQA-970 instance data saved for validation after batch job execution
    And   I am logged in as a Labor Distribution Manager
    Then  the labor ledger pending entry for employee is empty

  @KFSQA-1012 @validation-after-batch @solid
  Scenario: Validation for Submit a salary transfer edoc between account types, edit the object code, verify pending entries, and submit successfully
    Given All Nightly Batch Jobs have completed successfully
    And   I can retrieve references to test KFSQA-1012 instance data saved for validation after batch job execution
    And   I am logged in as a Labor Distribution Manager
    Then  the labor ledger pending entry for employee is empty
