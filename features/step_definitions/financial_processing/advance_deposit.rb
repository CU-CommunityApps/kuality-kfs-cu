include BatchUtilities

And /^I create an AD document$/ do
  @advance_deposit = create AdvanceDepositObject
end

And /^Nightly Batch Jobs run$/ do
  step 'I am logged in as a KFS Technical Administrator'
  run_nightly_out(true)
  run_poster(true)
  run_scrubber(true)
end

When /^I submit the AD document$/ do
  @advance_deposit.view
  @advance_deposit.submit
end

Then /^the AD document submits with no errors$/ do
  on(AdvanceDepositPage).document_status.should == 'ENROUTE'
end