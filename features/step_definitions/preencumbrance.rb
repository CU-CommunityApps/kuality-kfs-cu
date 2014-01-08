When /^I blanket approve a Pre-Encumbrance Document for Account number "([^"]*)"$/ do |acct_num|
  visit PreEncumbrancePage do |page|
    settings = {
      description:    '[KFSQA-587] Test Account Pre-Encumbrance',
      chart_code:     'IT',
      account_number: acct_num,
      object:         '6100',
      amount:         '0.01'
    }


    #page.description.set    '[KFSQA-587] Test Account Pre-Encumbrance'
    #page.chart_code.set     'IT'
    #page.account_number.set acct_num
    #page.object.set         '6100'
    #page.amount.set         '0.01'
  end
end

Then /^the Pre-Encumbrance posts either as a pending or completed GL entry$/ do
  pending
end