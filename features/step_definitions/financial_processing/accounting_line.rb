Then /^"([^"]*)" should not be displayed in the Accounting Line section$/ do |msg|
 on(AdvanceDepositPage).errors.should_not include msg
end

When /^I add a (from|to) Accounting Line for the (.*) document$/ do |line_type, document|
  doc_object = snake_case document
  page_klass = Kernel.const_get(get(doc_object).class.to_s.gsub(/(.*)Object$/,'\1Page'))

  on page_klass do
    case line_type
      when 'from'
        get(doc_object).
          add_from_line({
                     chart_code:               @account.chart_code,
                     account_number:           @account.number,
                     object:                   '4480',
                     reference_origin_code:    '01',
                     reference_number:         '777001',
                     amount:                   '25000.11'
                   })
      when 'to'
        get(doc_object).
          add_to_line({
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

When /^I enter a (from|to) Accounting Line Description on the (.*) document$/ do |line_type, document|
  doc_object = snake_case document
  case line_type
    when 'from'
      get(doc_object).from_lines[0].edit line_description: 'Hey it works!'
    when 'to'
      get(doc_object).to_lines[0].edit line_description: 'Hey it works too!'
  end
end

When /^I remove (from|to) Accounting Line #([0-9]*) from the (.*) document$/ do |line_type, line_number, document|
  doc_object = snake_case document
  case line_type
    when 'from'
      get(doc_object).from_lines.delete_at(line_number.to_i - 1)
    when 'to'
      get(doc_object).to_lines.delete_at(line_number.to_i - 1)
  end
end

Then /^the Accounting Line Description for the (.*) document equals the General Ledger Accounting Line Description$/ do |document|
  doc_object = get(snake_case(document))
  on AccountingLine do |lines|
    # We expect equal from and to lines, so this should be legit.
    0..doc_object.from_lines.length do |l|
      lines.result_from_line_description(l).should == doc_object.from_lines[l].line_description
      lines.result_to_line_description(l).should == doc_object.to_lines[l].line_description
    end
  end
end