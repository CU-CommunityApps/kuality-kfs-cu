And /^I (#{GeneralErrorCorrectionPage::available_buttons}) a GEC document$/ do |button|
  button.gsub!(' ', '_')
  @gec = create GeneralErrorCorrectionObject, press: button
  sleep 10 if (button == 'blanket_approve') || (button == 'approve')
end

And /^I add an Accounting Line to the GEC document with "Account Expired Override" selected$/ do
  pending
end

When /^I (.*) a GEC document for an expired Account$/ do |button|
  button.gsub!(' ', '_')
  # TODO: Find an expired Account (chart, acct_number), and appropriate settings for Object, Ref Origin Code, and Reference Number
  #visit(MainPage).account
  #on AccountLookupPage do |page|
  #  # FIXME: These values should be set by a service.
  #  page.chart_code.fit     'IT'
  #  page.account_number.fit '147*'
  #  page.search
  #  page.sort_results_by('Account Expiration Date')
  #  page.sort_results_by('Account Expiration Date') # Need to do this twice to get the expired ones in front
  #
  #  col_index = page.header_row_key.index(:account_expiration_date)
  #  account_row_index = page.results_table
  #                          .rows.collect { |row| row[col_index].text if row[col_index].text.split('/').length == 3}[1..page.results_table.rows.length]
  #                               .collect { |cell| DateTime.strptime(cell, '%m/%d/%Y') < DateTime.now }.index(true)
  #  page.results_table[account_row_index][page.header_row_key.index(:account_number)].click
  #end
  #on AccountPage do |page|
  #  # We're only really interested in these parts
  #  @account = make AccountObject
  #  @account.number =
  #  @account.chart_code =
  #end

  from_line = {
    chart_code:            'IT',
    account_number:        'G003704',
    object:                '4480',
    reference_origin_code: '01',
    reference_number:      '777001',
    amount:                '25000.11'
  }
  to_line = {
    chart_code:            'IT',
    account_number:        'G013300',
    object:                '4480',
    reference_origin_code: '01',
    reference_number:      '777002',
    amount:                '25000.11'
  }

  # TODO: Create a GEC document with the Account using that button press
  @gec = create GeneralErrorCorrectionObject, press: button, from_lines: from_line, to_lines: to_line
  #sleep 10 if (button == 'blanket_approve') || (button == 'approve')
  pending
end
