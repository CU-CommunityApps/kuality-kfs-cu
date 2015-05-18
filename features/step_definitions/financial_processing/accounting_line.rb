When /^I add a (source|target) Accounting Line for the (.*) document$/ do |line_type, document|
  doc_object = snake_case document

  on page_class_for(document) do
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

  on page_class_for(document) do

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
                                 object:         '6510',
                                 current_amount: '10.00'
                               })
      when 'Advance Deposit'
      when'Auxiliary Voucher'
        new_source_line.merge!({
                                 object: '6690',
                                 debit:  '100'
                               })
        new_source_line.delete(:amount)
      when'Credit Card Receipt'
        new_source_line.merge!({
                                 object: '4010'
                               })
      when'Disbursement Voucher'
        new_source_line.merge!({
                                 object: '6430'
                               })
      when 'General Error Correction'
        new_source_line.merge!({
                               reference_number:      rand(100..99999),
                               reference_origin_code: fetch_random_origination_code
                             })
      when 'Non-Check Disbursement'
        new_source_line.merge!({
                                   reference_number: '1234',
                                   object:           '6540'
                               })
      when 'Pre-Encumbrance'
        new_source_line.merge!({
                                 object: '6540'
                               })
      when 'Internal Billing'
        new_source_line.merge!({
                                 object: '4023'
                               })
      when 'Indirect Cost Adjustment'
        new_source_line.delete(:object)
      when 'Journal Voucher'
        new_source_line.merge!({
                                 object: '6540',
                                 debit:  '100',
                               })
        new_source_line.delete(:amount)
      when 'Transfer Of Funds'
        new_source_line.merge!({
                                 object: '8070'
                               })
      when 'Service Billing'
        new_source_line.merge!({
                                   object: '4023'
                               })
      else
    end
    doc_object.add_source_line(new_source_line)

    # Some docs don't have a target line
    unless (document == 'Advance Deposit') || (document == 'Auxiliary Voucher') ||
           (document == 'Pre-Encumbrance') || (document == 'Non-Check Disbursement') ||
           (document == 'Journal Voucher') || (document == 'Credit Card Receipt') ||
           (document == 'Disbursement Voucher')
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
                                   object:         '6540',
                                   current_amount: '10.00'
                                 })
        when'General Error Correction'
          new_target_line.merge!({
                               reference_number:      '777002',
                               reference_origin_code: '01'
                             })
        when 'Pre-Encumbrance'
          new_target_line.merge!({
                                   object: '6510'
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
        when 'Service Billing'
          new_target_line.merge!({
                                     object: '4023'
                                 })
      end
      doc_object.add_target_line(new_target_line)
    end

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

And /^I add a (Source|Target|From|To) Accounting Line to the (.*) document with the following:$/ do |line_type, document, table|
  accounting_line_info = table.rows_hash
  accounting_line_info.delete_if { |k,v| v.empty? }
  unless accounting_line_info['Number'].nil?
    doc_object = snake_case document

    on page_class_for(document) do
      case line_type
        when 'Source', 'From'
          new_source_line = {
              chart_code:     accounting_line_info['Chart Code'],
              account_number: accounting_line_info['Number'],
              object:         accounting_line_info['Object Code'],
              amount:         accounting_line_info['Amount']
          }
          case document
            when'Budget Adjustment'
              new_source_line.merge!({
                                         object:         '6510',
                                         current_amount: accounting_line_info['Amount']
                                     })
              new_source_line.delete(:amount)
            when 'Advance Deposit'
            when'Auxiliary Voucher', 'Journal Voucher'
              new_source_line.merge!({
                                         object: '6690',
                                         debit:  accounting_line_info['Amount']
                                     })
              new_source_line.delete(:amount)
              get(doc_object).add_source_line(new_source_line)
              new_source_line.merge!({
                                         credit:  accounting_line_info['Amount']
                                     })
              new_source_line.delete(:debit)
            when 'General Error Correction'
              new_source_line.merge!({
                                         reference_number:      '777001',
                                         reference_origin_code: '01'
                                     })
            when 'Pre-Encumbrance'
              if accounting_line_info.has_key?'Auto Disencumber Type'
                new_source_line.merge!({
                                         auto_dis_encumber_type:    accounting_line_info['Auto Disencumber Type'],
                                         partial_transaction_count: accounting_line_info['Partial Transaction Count'],
                                         partial_amount:            accounting_line_info['Partial Amount'],
                                         start_date:                accounting_line_info['Start Date']
                                      })
              end
            when 'Internal Billing', 'Service Billing'
              new_source_line.merge!({
                                         object: '4023'
                                     })
            when 'Indirect Cost Adjustment'
              new_source_line.delete(:object)
            when 'Non-Check Disbursement'
              new_source_line.merge!({
                                         reference_number:      '777001'
                                     })
            when 'Transfer Of Funds'
              new_source_line.merge!({
                                         object: '8070'
                                     })
            when 'Disbursement Voucher'
              new_source_line.merge!({
                                         object: '6100'
                                     })
            else
          end
          get(doc_object).add_source_line(new_source_line)
        when 'Target', 'To'
          new_target_line = {
              chart_code:     accounting_line_info['Chart Code'],
              account_number: accounting_line_info['Number'],
              object:         accounting_line_info['Object Code'],
              amount:         accounting_line_info['Amount']
          }
          case document
            when'Budget Adjustment'
              new_target_line.merge!({
                                         object:         '6540',
                                         current_amount: accounting_line_info['Amount']
                                     })
              new_target_line.delete(:amount)
            when'General Error Correction'
              new_target_line.merge!({
                                         reference_number:      '777002',
                                         reference_origin_code: '01'
                                     })
            when 'Pre-Encumbrance'
              if accounting_line_info.has_key?'Reference Number'
                new_target_line.merge!({
                                          reference_number:    accounting_line_info['Reference Number']
                                       })
              end
            when 'Internal Billing', 'Service Billing'
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
          get(doc_object).add_target_line(new_target_line)
      end
    end
  end
end

And /^I add a source Accounting Line to the (.*) document with a bad object code$/ do |document|
  doc_object = snake_case document
  new_source_line = {
      chart_code:     get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
      account_number: 'G003704',
      object:         '4010',
      amount:         '300'
  }
  get(doc_object).add_source_line(new_source_line)
  get(doc_object).accounting_lines[:source].clear
end
