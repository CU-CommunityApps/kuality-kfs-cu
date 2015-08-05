And /^I (#{LaborJournalVoucherPage::available_buttons}) a Labor Journal Voucher document with accounting lines$/ do |button|
  @labor_journal_voucher = create LaborJournalVoucherObject,
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
  step "I #{button} the Labor Journal Voucher document"
end
