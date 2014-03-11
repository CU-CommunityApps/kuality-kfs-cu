Tags
====

### General Purpose

| Tag      | Description |
| -------- | ----------- |
| @wip     | Work in progress. There should be no @wip tags on the master branch! |
| @smoke   | Smoke test. Generally tests functionality that should never ever be broken. |
| @cornell | This is a Cornell University-specific test. Your mileage may vary. |

### Known Problems

| Tag                  | Description |
| -------------------- | ----------- |
| @test-highlights-bug | This Scenario *should* fail. If it doesn't, you win! |
| @pending             | Pending. Probably added to master accidentally along with a different JIRA. Should be remediated someday. |
| @broken!             | Should be working, but definitely isn't. Someone should fix this ASAP. |
| @permissions-issue   | Paired with @broken!, this indicates that the problem is due to the permissions of the user(s) in the Scenario. |
| @needs-clean-up      | This test is technically correct, but has some style issues to fix (e.g. comments in feature). |

### Warnings

| Tag           | Description |
| ------------- | ----------- |
| @nightly-jobs | Scenario runs the Nightly Jobs processes, which requires the Quartz scheduler in Rice. |


### Approximate Speed

| Tag       | Description |
| --------- | ----------- |
| @hare     | ~ 30 seconds (or less) |
| @sloth    | > 30 seconds |
| @tortoise | > 1.5 minutes |
| @slug     | > 3.5 minutes |
| @coral    | > 5 minutes |

Consider these more as "relative" speeds. Assuming Rice is cooperating, this
should be more-or-less accurate, though (within +/- 5 seconds, hopefully).

See http://en.wikipedia.org/wiki/Slowest_animals for inspiration.
