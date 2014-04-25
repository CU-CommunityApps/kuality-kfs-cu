Then /^"([^"]*)" should not be displayed in the Accounting Line section$/ do |msg|
 on(AdvanceDepositPage).errors.should_not include msg
end

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
                               reference_number:      '777001',
                               reference_origin_code: '01'
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
              new_source_line.merge!({
                                         object: '6100'
                                     })
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
              new_target_line.merge!({
                                         object: '6100'
                                     })
              unless @remembered_document_id.nil?
                new_target_line.merge!({
                                         reference_number:      @remembered_document_id,
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


Then /^the (.*) document accounting lines equal the General Ledger entries$/ do |document|
  # do a search for GL entries
  # go through each IB accounting line
  # match it with it's two entries in the gl
  doc_object = get(snake_case(document))

  visit(MainPage).general_ledger_entry
  on GeneralLedgerEntryLookupPage do |page|
    # We're assuming that Fiscal Year and Fiscal Period default to today's values
    page.doc_number.fit        doc_object.document_id
    page.balance_type_code.fit ''
    page.pending_entry_approved_indicator_all
    page.search

    # verify number of resuls is twice the number of accounting lines
    (page.results_table.rows.length-1).should == (doc_object.accounting_lines[:source].length + doc_object.accounting_lines[:target].length) * 2

    page.results_table.rows.each do |row|
    end

    all_accounting_lines = doc_object.accounting_lines[:source] + doc_object.accounting_lines[:target]
    all_accounting_lines.each do |accounting_line|
      found_original = false
      found_offset = false

      account_number_col = page.column_index(:account_number)
      amount_col = page.column_index(:transaction_ledger_entry_amount)
      description_col = page.column_index(:transaction_ledger_entry_description)

      page.results_table.rows.each do |row|
        if row[account_number_col].text == accounting_line.account_number && row[amount_col].text.groom == accounting_line.amount.groom
          if row[description_col].text.strip == accounting_line.line_description.strip
            found_original = true
          else if row[description_col].text.strip == 'TP Generated Offset'
                 found_offset = true
               end
          end
        end
      end
      found_original.should be true
      found_offset.should be true
      end
  end
end

Then /^the (.*) document accounting lines equal the General Ledger Pending entries$/ do |document|
  # view the document?
  # open up pending entries
  # match accounts with GLPEs
  doc_object = get(snake_case(document))
  page_klass = Kernel.const_get(doc_object.class.to_s.gsub(/(.*)Object$/,'\1Page'))

  on page_klass do |page|
    page.expand_all

    # verify number of resuls is twice the number of accounting lines
    (page.glpe_results_table.rows.length-1).should == (doc_object.accounting_lines[:source].length + doc_object.accounting_lines[:target].length) * 2

    all_accounting_lines = doc_object.accounting_lines[:source] + doc_object.accounting_lines[:target]
    all_accounting_lines.each do |accounting_line|
      found_d = false
      found_c = false

      account_number_col = page.glpe_results_table.keyed_column_index(:account_number)
      amount_col = page.glpe_results_table.keyed_column_index(:amount)
      dc_col = page.glpe_results_table.keyed_column_index(:d_c)

      page.glpe_results_table.rest.each do |row|
        if row[account_number_col].text == accounting_line.account_number && row[amount_col].text.groom == accounting_line.amount.to_s.groom
          if row[dc_col].text.strip == 'D'
            found_d = true
          else if row[dc_col].text.strip == 'C'
                 found_c = true
               end
          end
        end
      end
      found_d.should be true
      found_c.should be true
    end
  end
end

And /^I lookup the (Encumbrance|Disencumbrance|Source|Target|From|To) Accounting Line for the (.*) document via Available Balances with these options selected:$/ do |al_type, document, table|
  doc_object = document_object_for(document)
  alt = AccountingLineObject::get_type_conversion(al_type)

  visit(MainPage).available_balances
  on AvailableBalancesLookupPage do |lookup|
    lookup.fiscal_year.fit                  right_now[:year]
    lookup.chart_code.fit                   doc_object.accounting_lines[alt].first.chart_code # We're assuming this exists, of course.
    lookup.account_number.fit               doc_object.accounting_lines[alt].first.account_number
    lookup.send("consolidation_option_#{snake_case(table.rows_hash['Consolidation Option']).to_s}") unless table.rows_hash['Consolidation Option'].nil?
    lookup.send("include_pending_entry_approved_indicator_#{table.rows_hash['Include Pending Ledger Entry'].downcase}") unless table.rows_hash['Include Pending Ledger Entry'].nil?
    lookup.search
  end
end

And /^these fields in the Available Balances lookup match the ones submitted in the (.*) document:$/ do |document, table|
  # Note: This assumes you're already on the Available Balances lookup page and have run the lookup
  doc_object = document_object_for(document)
  lookup_cols = table.raw.flatten.collect { |f| on(AvailableBalancesLookupPage).column_index(snake_case(f)) }

  lookup_cols.each do |col|
    case col
      when :encumbrance_amount
        on(AvailableBalancesLookupPage).column(col).any? { |cell| cell.text == doc_object.accounting_lines[:source].first.amount }
      else
        # Do nothing
    end
  end
end

And /^I open the (.*) General Ledger Balance Lookup in the Available Balances lookup that matches the one submitted for (Encumbrance|Disencumbrance|Source|Target|From|To) Accounting Line on the (.*) document$/ do |column, al_type, document|
  # Note: This assumes you're already on the Available Balances lookup page and have run the lookup
  doc_object = document_object_for(document)
  alt = AccountingLineObject::get_type_conversion(al_type)
  col = on(AvailableBalancesLookupPage).column_index(snake_case(column))

  case snake_case(column)
    when :encumbrance_amount
      on(AvailableBalancesLookupPage) do |p|
        p.item_row(doc_object.accounting_lines[alt].first.object)[col]
         .link
         .click
        p.use_new_tab
        p.close_parents
      end
    else
      # Do nothing
  end
end

And /^the (Encumbrance|Disencumbrance|Source|Target|From|To) Accounting Line on the General Ledger Balance lookup for the (.*) document equals the displayed amounts$/ do |al_type, document|
  doc_object = document_object_for(document)
  alt = AccountingLineObject::get_type_conversion(al_type)
  col = on(GeneralLedgerBalanceLookupPage).column_index(snake_case('Transaction Ledger Entry Amount'))

  on GeneralLedgerBalanceLookupPage do |p|
    p.item_row(document_object_for(document).document_id)[col].text.to_f.should == doc_object.accounting_lines[alt].first.amount.to_f
  end
end

And /^the (Encumbrance|Disencumbrance|Source|Target|From|To) Accounting Line entry matches the (.*) document's entry$/ do |al_type, document|
  doc_object = document_object_for(document)
  alt = AccountingLineObject::get_type_conversion(al_type)
  on AccountingLine do |entry_page|
    # We're going to just compare against the first submitted line
    ((entry_page.send("result_#{alt.to_s}_chart_code")).should == doc_object.accounting_lines[alt].first.chart_code) unless doc_object.accounting_lines[alt].first.chart_code.nil?
    ((entry_page.send("result_#{alt.to_s}_account_number")).should == doc_object.accounting_lines[alt].first.account_number) unless doc_object.accounting_lines[alt].first.account_number.nil?
    ((entry_page.send("result_#{alt.to_s}_sub_account_code")).should == doc_object.accounting_lines[alt].first.sub_account) unless doc_object.accounting_lines[alt].first.sub_account.nil?
    ((entry_page.send("result_#{alt.to_s}_object_code")).should == doc_object.accounting_lines[alt].first.object) unless doc_object.accounting_lines[alt].first.object.nil?
    ((entry_page.send("result_#{alt.to_s}_sub_object_code")).should == doc_object.accounting_lines[alt].first.sub_object) unless doc_object.accounting_lines[alt].first.sub_object.nil?
    ((entry_page.send("result_#{alt.to_s}_project_code")).should == doc_object.accounting_lines[alt].first.project) unless doc_object.accounting_lines[alt].first.project.nil?
    ((entry_page.send("result_#{alt.to_s}_organization_reference_id")).should == doc_object.accounting_lines[alt].first.org_ref_id) unless doc_object.accounting_lines[alt].first.org_ref_id.nil?
    ((entry_page.send("result_#{alt.to_s}_line_description")).should == doc_object.accounting_lines[alt].first.line_description) unless doc_object.accounting_lines[alt].first.line_description.nil?
    ((entry_page.send("result_#{alt.to_s}_reference_origin_code")).should == doc_object.accounting_lines[alt].first.reference_origin_code) unless doc_object.accounting_lines[alt].first.reference_origin_code.nil?
    ((entry_page.send("result_#{alt.to_s}_reference_number")).should == doc_object.accounting_lines[alt].first.reference_number) unless doc_object.accounting_lines[alt].first.reference_number.nil?
    ((entry_page.send("result_#{alt.to_s}_amount")).to_f.should == doc_object.accounting_lines[alt].first.amount.to_f) unless doc_object.accounting_lines[alt].first.amount.nil?
    ((entry_page.send("result_#{alt.to_s}_base_amount")).to_f.should == doc_object.accounting_lines[alt].first.base_amount.to_f) unless doc_object.accounting_lines[alt].first.base_amount.nil?
    ((entry_page.send("result_#{alt.to_s}_current_amount")).to_f.should == doc_object.accounting_lines[alt].first.current_amount.to_f) unless doc_object.accounting_lines[alt].first.current_amount.nil?
  end
end