Feature: Labor Journal Voucher

  [KFSQA-662] To properly control Labor Ledger entries, Cornell University modified the LLJV with
              approval node LLJVApproval. Cornell roles for Labor Distribution Manager (cu) will
              initiate the eDoc and LLJV Approver (cu) will approve it.

  @KFSQA-662 @FP @LLJV @BaseFunction @cornell @hare
  Scenario: Ensure the LLJVApproval node works.
    Given I am logged in as a KFS User for the LLJV document
    And   I submit a Labor Journal Voucher document with accounting lines
    And   I switch to the user with the next Pending Action in the Route Log for the Labor Journal Voucher document
    And   I view the Labor Journal Voucher document
    And   I approve the Labor Journal Voucher document
    And   the Labor Journal Voucher document goes to FINAL
