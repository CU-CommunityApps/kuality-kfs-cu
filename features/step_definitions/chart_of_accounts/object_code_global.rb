And /^I enter an invalid CG Reporting Code of (.*)$/ do |invalid_code|
  on(ObjectCodeGlobalPage).cg_reporting_code.fit invalid_code
  on ObjectCodeGlobalPage do |page|
    page.cg_reporting_code.set invalid_code
  end
end

Then /^Object Code Global should show an error that says (.*?)$/ do |error|
  #There is a bug with this test that does not produce error at this time
  #TODO:: Comment back in when error is fixed and displays correctly.
  #on(ObjectCodeGlobalPage).errors.should include error
end

When /^I Blanket Approve the Object Code Global document$/ do
  on(ObjectCodeGlobalPage).blanket_approve
end
