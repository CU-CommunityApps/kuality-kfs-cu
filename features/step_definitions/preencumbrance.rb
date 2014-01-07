When /^I blanket approve a Pre-Encumbrance Document for Account number "([^"]*)"$/ do |acct_num|
  @browser.goto "#{$base_url}portal.do?channelTitle=Pre-Encumbrance&channelUrl=financialPreEncumbrance.do?methodToCall=docHandler&command=initiate&docTypeName=PE"
  on PreEncumbrancePage do |page|
    page.description.set '[KFSQA-587] Test Account Pre-Encumbrance'
    page.new_encumbrance.set {
      :chart_code '',
      :account_number '',
      :object '',
      :amount ''
    }
  end
end

Then /^the Pre-Encumbrance posts either as a pending or completed GL entry$/ do
  pending
end