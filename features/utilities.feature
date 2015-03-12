Feature: Utilities

  [KDO-557] Sometimes, we just want to run nightly batch jobs.

  @KDO-557 @utility @quartz @nightly-jobs @smoke
  Scenario: Just run the nightly batch jobs.
    Given All Nightly Batch Jobs are run
    Then  the last Nightly Batch Job should have succeeded
