When /^I start an empty Labor Journal Voucher document$/ do
  @labor_journal_voucher = create LaborJournalVoucherObject
end

And /^I (#{LaborJournalVoucherPage::available_buttons}) a Labor Journal Voucher document$/ do |button|
  button.gsub!(' ', '_')
  @labor_journal_voucher = create LaborJournalVoucherObject,
                              press: nil, # We should add the accounting lines before submitting, eh?
                              initial_lines: [
                                  {
                                      type:             :source,
                                      account_number:   'G003704',
                                      object:           '4480',
                                      credit:           '250.11',
                                      line_description: nil
                                  },
                                  {
                                      type:             :source,
                                      account_number:   'G013300',
                                      object:           '4480',
                                      debit:            '250.11',
                                      line_description: nil
                                  }
                              ]

  on LaborJournalVoucherPage do |page|
    page.send(button)
  end
end