And /^I (#{GeneralErrorCorrectionPage::available_buttons}) a General Error Correction document$/ do |button|
  button.gsub!(' ', '_')
  @general_error_correction = create GeneralErrorCorrectionObject, press: button
  sleep 10 if (button == 'blanket_approve') || (button == 'approve')
end

When /^I start a General Error Correction document$/ do
  visit(MainPage).general_error_correction
  @general_error_correction = create GeneralErrorCorrectionObject
end

When /^I start an empty General Error Correction document$/ do
  visit(MainPage).general_error_correction
  @general_error_correction = create GeneralErrorCorrectionObject
end


And /^I add an Accounting Line to the General Error Correction document with "Account Expired Override" selected$/ do
  on GeneralErrorCorrectionPage do
    @general_error_correction.add_from_line({
        chart_code:               @account.chart_code,
        account_number:           @account.number,
        object:                   '4480',
        reference_origin_code:    '01',
        reference_number:         '777001',
        amount:                   '25000.11',
        account_expired_override: :set
    })
    @general_error_correction.add_to_line({
        chart_code:               @account.chart_code,
        account_number:           @account.number,
        object:                   '4480',
        reference_origin_code:    '01',
        reference_number:         '777002',
        amount:                   '25000.11',
        account_expired_override: :set
    })
  end
end

And /^I add balanced Accounting Lines to the General Error Correction document$/ do
  on GeneralErrorCorrectionPage do
    @general_error_correction.add_from_line({
                                              chart_code:               @account.chart_code,
                                              account_number:           @account.number,
                                              object:                   '4480',
                                              reference_origin_code:    '01',
                                              reference_number:         '777001',
                                              amount:                   '25000.11'
                                            })
    @general_error_correction.add_to_line({
                                            chart_code:               @account.chart_code,
                                            account_number:           @account.number,
                                            object:                   '4480',
                                            reference_origin_code:    '01',
                                            reference_number:         '777002',
                                            amount:                   '25000.11'
                                          })
  end
end