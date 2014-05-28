Feature: Utilities

  [KDO-557] Sometimes, we just want to run nightly batch jobs.

  @KDO-557 @utility @quartz @nightly-jobs
  Scenario: Just run the nightly batch jobs. Give it 30 minutes (max), if needed.
    Given Nightly Batch Jobs run, waiting at most 600 seconds for each step
    Then  the last Nightly Batch Job should have succeeded
