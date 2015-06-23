Feature: Batch Utilities

  [KDO-557] Run labor and general ledger critical path batch jobs to clear any residual data from the database
            prior to the AFTs running.
            NOTE: This feature should be run as the very FIRST AFT and generate an output report. In order to achieve
            this desired outcome in the future as more AFTs are added, we may need to rename folders, files, or features
            based upon how Cucumber parses the directory tree and its file contents.

  @KDO-557 @quartz @nightly-jobs @smoke @solid
  Scenario: Run the labor and general ledger critical path batch jobs.
    Given All Nightly Batch Jobs are run
    Then  the last Nightly Batch Job should have succeeded
