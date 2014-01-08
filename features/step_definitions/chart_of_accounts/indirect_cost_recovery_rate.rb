When(/^I lookup an Rate ID using an alpha\-numeric value in the Indirect Cost Recovery Rate table$/) do

  on(MaintenancePage) do |page|
    page.maintenance_tab
    page.indirect_cost_recovery_rate
  end
  on IndirectCostRecoveryRateLookupPage do |page|
   page.rate_id.set 'EC1'
   page.search
  end
end

Then(/^I should see results returned for the  Indirect Cost Recovery Rate lookup$/) do
  on IndirectCostRecoveryRateLookupPage do |page|
   page.item_row('EC1').should exist
  end
end