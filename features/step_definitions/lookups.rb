Then /^the Lookup should return results$/ do
  on(Lookups).results_table.rows.length.should > 0
end

And /^I visit the main page$/ do
  visit(MainPage)
end