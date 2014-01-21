When /^I lookup a Rate ID using an alpha\-numeric value in the Indirect Cost Recovery Rate table$/ do

  on MaintenancePage do |page|
    page.maintenance_tab
    page.indirect_cost_recovery_rate
  end

  on IndirectCostRecoveryRateLookupPage do |page|
   page.rate_id.set 'EC1'
   page.search
  end

end