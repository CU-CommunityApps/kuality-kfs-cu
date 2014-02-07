And /^I (#{GeneralErrorCorrectionPage::available_buttons}) a GEC document$/ do |button|
  button.gsub!(' ', '_')
  @gec = create GeneralErrorCorrectionObject, press: button
  sleep 10 if (button == 'blanket_approve') || (button == 'approve')
end

When /^I start a GEC document$/ do
  @gec = create GeneralErrorCorrectionObject
end

And /^I add an Accounting Line to the GEC document with "Account Expired Override" selected$/ do
  on GeneralErrorCorrectionPage do
    @gec.add_from_line({
        chart_code:               @account.chart_code,
        account_number:           @account.number,
        object:                   '4480',
        reference_origin_code:    '01',
        reference_number:         '777001',
        amount:                   '25000.11',
        account_expired_override: :set
    })
    @gec.add_to_line({
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
