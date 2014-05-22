Feature: Labor Distribution

  [KFSQA-985] Base Function : I RUN THE NIGHTLY LABOR BATCH PROCESSES

  @KFSQA-985 @BaseFunction @wip
  Scenario: Base Function for labor nightly batch process.
    Given I RUN THE NIGHTLY LABOR BATCH PROCESSES
    # this is just an example to validate the labor batch process is OK.  For different ST/BT
    # this step may revised or make more general
    Then  the labor ledger pending entry for employee '1013939' is empty