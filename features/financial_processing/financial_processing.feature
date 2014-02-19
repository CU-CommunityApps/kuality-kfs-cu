Feature: Generic Financial Processing

  [KFSQA-652] Initiator or qualified document role to recall a routed document. New 5.x feature

  @KFSQA-652
  Scenario Outline: Recall enroute Documents.
    Given  I am logged in as a KFS User for all these eDocs
    And    I start a <eDoc>> document
    And    I enter Accounting Lines for all these eDocs
    And    I submit all these documents
    And    The document status for all these documents goes to ENROUTE
    And    I Select The Document ID**
    And    I Select Recall and enter “Recall Test”
    When   I Select Recall and Cancel***
    Then   The document status is RECALLED

#  Or Opton 2…..
#  And     I Select Recall and enter “Return to Action List”
#  When  I Select Return to Action List”***
#  Then   The document status is SAVED
  Examples:
    | eDoc                               | docType | source_account | target_account | done? |
    | Advance Deposit                    | AD      | 2003600        |                | true  |
    | Auxiliary Voucher                  | AV      | H853800        |                | false |
