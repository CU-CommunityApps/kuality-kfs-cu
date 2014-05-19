And /^I INITIATE A POA/ do
  steps %Q{
    Given I login as a Accounts Payable Processor to create a POA
    And   I fill out the PREQ initiation page and continue
    And   I change the Remit To Address
    And   I enter the Qty Invoiced and calculate
    And   I enter a Pay Date
    And   I attach an Invoice Image
    And   I calculate PREQ
    And   I submit the Payment Request document
    And   the Payment Request document goes to ENROUTE
    And   I switch to the user with the next Pending Action in the Route Log to approve Payment Request document to Final
    And   the Payment Request document goes to FINAL
    And   the Payment Request Doc Status is Department-Approved
    And   the Payment Request document's GLPE tab shows the Requisition document submissions
  }
end
