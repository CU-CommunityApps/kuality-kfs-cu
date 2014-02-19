Then /^"([^"]*)" should not be displayed in the Accounting Line section$/ do |msg|
 on(AdvanceDepositPage).errors.should_not include msg
end

When /^I add a (source|target) Accounting Line for the (.*) document$/ do |line_type, document|
  doc_object = snake_case document
  page_klass = Kernel.const_get(get(doc_object).class.to_s.gsub(/(.*)Object$/,'\1Page'))

  on page_klass do
    case line_type
      when 'source'
        get(doc_object).
          add_source_line({
                     chart_code:               @account.chart_code,
                     account_number:           @account.number,
                     object:                   '4480',
                     reference_origin_code:    '01',
                     reference_number:         '777001',
                     amount:                   '25000.11'
                   })
      when 'target'
        get(doc_object).
          add_target_line({
                     chart_code:               @account.chart_code,
                     account_number:           @account.number,
                     object:                   '4480',
                     reference_origin_code:    '01',
                     reference_number:         '777002',
                     amount:                   '25000.11'
                   })
    end
  end
end

When /^I enter a (source|target) Accounting Line Description on the (.*) document$/ do |line_type, document|
  doc_object = get(snake_case(document))
  doc_object.accounting_lines[line_type.to_sym][0].edit line_description: "Hey #{line_type} edit works!"
end

When /^I remove (source|target) Accounting Line #([0-9]*) from the (.*) document$/ do |line_type, line_number, document|
  get(snake_case(document)).accounting_lines[line_type.to_sym].delete_at(line_number.to_i - 1)
end

Then /^the Accounting Line Description for the (.*) document equals the General Ledger Accounting Line Description$/ do |document|
  doc_object = get(snake_case(document))
  on AccountingLine do |lines|
    # We expect equal from and to lines, so this should be legit.
    0..doc_object.accounting_lines[:source].length do |l|
      lines.result_source_line_description(l).should == doc_object.accounting_lines[:source][l].line_description
      (lines.result_target_line_description(l).should == doc_object.accounting_lines[:target][l].line_description) unless doc_object.accounting_lines[:target].nil?
    end
  end
end

# This step is a little hairy and has potential to get much hairier. We may need to split it into
# multiple steps on document type if it gets worse.
And /^I add balanced Accounting Lines to the (Advance Deposit|Budget Adjustment|Credit Card Receipt|Disbursement Voucher|Distribution Of Income And Expense|General Error Correction|Internal Billing|Indirect Cost Adjustment|Journal Voucher|Non-Check Disbursement|Pre-Encumbrance|Service Billing|Transfer Of Funds) document$/ do |document|
  doc_object = get(snake_case(document))
  page_klass = Kernel.const_get(doc_object.class.to_s.gsub(/(.*)Object$/,'\1Page'))

  on page_klass do

    # Everybody has a source line at least
    new_source_line = {
        chart_code:     @accounts[0].chart_code,
        account_number: @accounts[0].number,
        object:         '4480',
        line_description: 'What a wonderful From line description!'
    }
    new_source_line.merge!({ amount: '100' }) unless document == 'Budget Adjustment'

    case document
      when'Budget Adjustment'
        new_source_line.merge!({
                               current_amount:   '250.11',
                               base_amount:      '125'
                             })
      when 'Advance Deposit'
      when'Auxiliary Voucher'
        new_source_line.merge!({
                                 object: '6690',
                                 debit:  '100',
                                 #credit: '100'
                               })
        new_source_line.delete(:amount)
      when 'General Error Correction'
        new_source_line.merge!({
                               reference_number:      '777001',
                               reference_origin_code: '01'
                             })
      when 'Pre-Encumbrance'
        new_source_line.merge!({
                                 object: '6100'
                               })
      when 'Internal Billing'
        new_source_line.merge!({
                                 object: '4023'
                               })
      when 'Indirect Cost Adjustment'
        new_source_line.delete(:object)
      when 'Transfer Of Funds'
        new_source_line.merge!({
                                 object: '8070'
                               })
      else
    end
    doc_object.add_source_line(new_source_line)

    # Some docs don't have a target line
    unless (document == 'Advance Deposit') || (document == 'Auxiliary Voucher') || (document == 'Pre-Encumbrance')
      new_target_line = {
          chart_code:     @accounts[1].chart_code,
          account_number: @accounts[1].number,
          object:         '4480',
          line_description: 'What a wonderful To line description!'
      }
      new_target_line.merge!({ amount: '100' }) unless document == 'Budget Adjustment'

      case document
        when'Budget Adjustment'
          new_target_line.merge!({
                               current_amount:   '250.11',
                               base_amount:      '125'
                             })
        when'General Error Correction'
          new_target_line.merge!({
                               reference_number:      '777002',
                               reference_origin_code: '01'
                             })
        when 'Pre-Encumbrance'
          new_target_line.merge!({
                                   object: '6100'
                                 })
        when 'Internal Billing'
          new_target_line.merge!({
                                   object: '4023'
                                 })
        when 'Indirect Cost Adjustment'
          new_target_line.delete(:object)
        when 'Transfer Of Funds'
          new_target_line.merge!({
                                   object: '7070'
                                 })
      end
      doc_object.add_target_line(new_target_line)
    end

    #pending 'Test test'
  end
end

And /^I add balanced Accounting Lines to the Auxiliary Voucher document$/ do
  on AuxiliaryVoucherPage do
    new_source_line = {
        chart_code:     @accounts[0].chart_code,
        account_number: @accounts[0].number,
        line_description: 'What a wonderful From line description!',
        object: '6690',
        debit:  '100'
    }
    @auxiliary_voucher.add_source_line(new_source_line)
    new_source_line.delete(:debit)
    new_source_line.merge!({credit: '100'})
    @auxiliary_voucher.add_source_line(new_source_line)
  end
end