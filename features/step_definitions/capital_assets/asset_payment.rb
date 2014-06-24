When /^I start an empty Asset Manual Payment document$/ do
  @asset_manual_payment = create AssetManualPaymentObject
end

And /^I add an Asset with the following fields:$/ do |table|
  asset_info = table.rows_hash
  asset_info.delete_if { |k,v| v.empty? }
  puts asset_info,asset_info['Asset Number']
  on AssetManualPaymentPage do |page|
    page.asset_number.fit asset_info['Asset Number']
    page.add_asset_number
    page.allocate_amount(asset_info['Line Number'].to_i).fit asset_info['Allocation Amount']
  end

end

And /^I add an Accounting Line to the Asset Manual Payment with the following fields:$/ do |table|
  accounting_line_info = table.rows_hash
  accounting_line_info.delete_if { |k,v| v.empty? }
  puts accounting_line_info
  on AssetManualPaymentPage do |page|
    page.account_number.fit accounting_line_info['Number']
    page.object.fit accounting_line_info['Object Code']
    page.amount.fit accounting_line_info['Amount']
    page.post_date.fit right_now[:date_w_slashes]
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

