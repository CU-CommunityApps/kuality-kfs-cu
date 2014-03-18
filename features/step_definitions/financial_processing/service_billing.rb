When /^I start an empty Service Billing document$/ do
  @service_billing = create ServiceBillingObject
end

When /^I attempt to start an empty Service Billing document$/ do
  visit(MainPage).service_billing
end

