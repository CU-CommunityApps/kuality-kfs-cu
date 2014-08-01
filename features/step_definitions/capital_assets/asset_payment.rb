When /^I start an empty Asset Manual Payment document$/ do
  @asset_manual_payment = create AssetManualPaymentObject
end

And /^I add Asset Line (\d+) with Allocation Amount (\w+)$/ do |line_number, amount|
  on AssetManualPaymentPage do |page|
    page.asset_number.fit fetch_random_capital_asset_number
    page.add_asset_number
    page.allocate_amount(line_number.to_i - 1).fit amount
  end

end

And /^I add an Accounting Line to the Asset Manual Payment with Amount (\w+)$/ do |amount|
  on AssetManualPaymentPage do |page|
    page.account_number.fit  fetch_random_account_number
    page.object.fit fetch_random_capital_asset_object_code
    page.amount.fit amount
    page.post_date.fit right_now[:date_w_slashes] # add_source_line does not have this.  This is required
    page.add_acct_line
  end
  #@asset_manual_payment.add_source_line({
  #                                          account_number: accounting_line_info['Number'],
  #                                          object: accounting_line_info['Object Code'],
  #                                          amount: accounting_line_info['Amount'],
  #                                      })
  #
end

And /^I change the Account Amount for Accounting Line (\d+) to (\w+) for Asset Manual Payment$/ do |line_number, new_value|
  on(AssetManualPaymentPage).update_amount(line_number.to_i - 1).fit new_value
end

