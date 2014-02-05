And /^I (#{GeneralErrorCorrectionPage::available_buttons}) a GEC document$/ do |button|
  button.gsub!(' ', '_')
  @gec = create GeneralErrorCorrectionObject, press: button
  sleep 10 if (button == 'blanket_approve') || (button == 'approve')
end

When /^I start a GEC document$/ do
  @gec = create GeneralErrorCorrectionObject
end

And /^I add an Accounting Line to the GEC document with "Account Expired Override" selected$/ do
  from_line = {
      chart_code:            @account.chart_code, #'IT',
      account_number:        @account.number, #'G003704',
      object:                '4480',
      reference_origin_code: '01',
      reference_number:      '777001',
      amount:                '25000.11'
  }
  to_line = {
      chart_code:             @account.chart_code, #'IT',
      account_number:        @account.number, #'G013300',
      object:                '4480',
      reference_origin_code: '01',
      reference_number:      '777002',
      amount:                '25000.11'
  }

  @gec.add_from_line(from_line)
  @gec.add_to_line(to_line)

  pending 'This step does not work yet...'
end
