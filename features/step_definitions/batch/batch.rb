
include BatchUtilities

And /^Nightly Batch Jobs run$/ do
  # TODO: It would be nice to be able to switch back to the User
  #       that we were logged in as at the beginning of the batch
  #       jobs with out saying so explicitly.
  step 'I am logged in as a KFS Operations'
  step 'I run Nightly Out'
  step 'I run Scrubber'
  step 'I run Poster'
end

And /^Nightly Batch Jobs run, waiting at most (\d+) seconds for each step$/ do |seconds|
  # TODO: It would be nice to be able to switch back to the User
  #       that we were logged in as at the beginning of the batch
  #       jobs with out saying so explicitly.
  step 'I am logged in as a KFS Operations'
  step "I run Nightly Out, waiting at most #{seconds} seconds"
  step "I run Scrubber, waiting at most #{seconds} seconds"
  step "I run Poster, waiting at most #{seconds} seconds"
end

And /^I run (Nightly Out|Scrubber|Poster), waiting at most (\d+) seconds$/ do |action, seconds|
  case action
    when 'Nightly Out'
      run_unscheduled_job_until('nightlyOutJob', seconds)
    when 'Scrubber'
      run_unscheduled_job_until('scrubberJob', seconds)
    when 'Poster'
      run_unscheduled_job_until('posterJob', seconds)
  end
end

And /^I run (Nightly Out|Scrubber|Poster), not waiting for completion$/ do |action|

  case action
  when 'Nightly Out'
    run_nightly_out(false)
  when 'Scrubber'
    run_scrubber(false)
  when 'Poster'
    run_poster(false)
  end

end

And /^I run Nightly Out$/ do
  run_nightly_out(true)
end

And /^I run Scrubber$/ do
  run_scrubber(true)
end

And /^I run Poster$/ do
  run_poster(true)
end

Then /^the last Nightly Batch Job should have succeeded$/ do
  on(SchedulePage).job_status.should match(/Succeeded/)
end

And /^I run Auto Approve PREQ$/ do
  run_auto_approve_preq(true)
end

And /^I run Fax Pending Documents$/ do
  run_fax_pending_doc(true)
end

And /^I process Receiving for Payment Requests$/ do
  run_receiving_payment_request(true)
end

And /^I extract Electronic Invoices$/ do
  run_electronic_invoice_extract(true)
end

And /^I extract Regular PREQS to PDP for Payment$/ do
  run_pur_pre_disburse_extract(true)
end

And /^I extract Immediate PREQS to PDP for Payment$/ do
  run_pur_pre_disburse_immediate_extract(true)
end

And /^I approve Line Items$/ do
  run_approve_line_item_receiving(true)
end

And /^I close POS wtih Zero Balanecs$/ do
  run_auto_close_recurring_order(true)
end

And /^I load PREQ into PDP$/ do
  run_pdp_load_payment(true)
end

And /^I generate the ACH XML File$/ do
  run_pdp_extract_ach_payment(true)
end

And /^I generate the Check XML File$/ do
  run_pdp_extract_check(true)
end

And /^I generate the Cancelled Check XML File$/ do
  run_pdp_extract_canceled_check(true)
end

And /^I send EMAIL Notices to ACH Payees$/ do
  run_pdp_send_ach_advice_notification(true)
end

And /^I process Cancels and Paids$/ do
  run_pdp_cancel_and_paid(true)
end

And /^I generate the GL Files from PDP$/ do
  run_pdp_extract_gl_transaction(true)
end

And /^I populate the ACH Bank Table$/ do
  run_pdp_load_fed_reserve_bank_data(true)
end

And /^I clear out PDP Temporary Tables$/ do
  run_pdp_clear_pending_transaction(true)
end


And /^I run the Labor Enterprise Feed Process$/ do
  run_labor_enterprise_feed(true)
end

And /^I run the Labor Nightly Out Process$/ do
  run_labor_nightly_out(true)
end

And /^I run the Labor Scrubber Process$/ do
  run_labor_scrubber(true)
end

And /^I run the Labor Poster Process$/ do
  run_labor_poster(true)
end

And /^I run the Labor Balancing Job$/ do
  run_labor_balance(true)
end

And /^I run the Labor Feed Job$/ do
  run_labor_feed(true)
end

And /^I run the Labor Clear Pending Entries Job$/ do
  run_labor_clear_pending_entries(true)
end

And /^I collect the Capital Asset Documents$/ do
  run_nightly_out(true)
end

And /^I create the Plant Fund Entries$/ do
  run_scrubber(true)
end

And /^I move the Plant Fund Entries to Posted Entries$/ do
  run_poster(true)
end

And /^I clear Pending Entries$/ do
  run_clear_pending_entries(true)
end

And /^I create entries for CAB$/ do
  run_cab_extract(true)
end

