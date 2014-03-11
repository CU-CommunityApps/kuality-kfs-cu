When /^I perform a (.*) Lookup using account number (.*)$/ do |gl_balance_inquiry_lookup, account_number|
  gl_balance_inquiry_lookup = gl_balance_inquiry_lookup.gsub!(' ', '_').downcase
  visit(MainPage).send(gl_balance_inquiry_lookup)
  puts gl_balance_inquiry_lookup
  if gl_balance_inquiry_lookup == 'current_fund_balance'
    on CurrentFundBalanceLookupPage do |page|
      page.chart_code.fit     'IT'
      page.account_number.fit account_number
      page.search
    end
  else
    on GeneralLedgerEntryLookupPage do |page|
      page.chart_code.fit     'IT' #TODO get from config
      page.account_number.fit account_number
      page.search
    end
  end
end

Then /^the (.*) document GL Entry Lookup matches the document's GL entry$/ do |document|
  pending
end

And /^the (.*) document has matching GL and GLPE offsets$/ do |document|
  step "I look up the offset for the #{document} document in the document's GLPE entry"
  step "I look up the offset for the #{document} document in the document's GL entry"
  @glpe_offset_amount.should == @gl_offset_amount
end

And /^I look up the offset for the (.*) document in the document's GLPE entry$/ do |document|
  step "I look up the #{document} document in the GLPE"

  on GeneralLedgerPendingEntryLookupPage do |page|
    tled_col = page.results_table.keyed_column_index(:transaction_ledger_entry_description)
    tlea_col = page.results_table.keyed_column_index(:transaction_ledger_entry_amount)

    page.results_table
        .column(tled_col)
        .rest
        .length.should == 2 # We must get two lines to know the offset was generated.
    page.results_table
        .column(tled_col)
        .rest
        .map(&:text)
        .should include 'TP Generated Offset' # This verifies that the offset was actually generated.

    document_object_for(document).accounting_lines.each_value do |als|
      als.each do |al|
        @glpe_offset_amount = al.amount.to_f if @glpe_offset_amount.nil? # Grab it on the first go.

        @glpe_offset_amount.should == al.amount.to_f # If this gets tripped, we added multiple lines and we probably need to refactor.

        # Now match both lines.
        page.item_row(al.line_description)[tlea_col].text.to_f.should == @glpe_offset_amount
        page.item_row('TP Generated Offset')[tlea_col].text.to_f.should == @glpe_offset_amount

      end
    end
  end
end

And /^I look up the offset for the (.*) document in the document's GL entry$/ do |document|
  step "I look up the #{document} document in the GL"

  on GeneralLedgerEntryLookupPage do |page|
    tled_col = page.results_table.keyed_column_index(:transaction_ledger_entry_description)
    tlea_col = page.results_table.keyed_column_index(:transaction_ledger_entry_amount)

    page.results_table
        .column(tled_col)
        .rest
        .length.should == 2 # We must get two lines to know the offset was generated.
    page.results_table
        .column(tled_col)
        .rest
        .map(&:text)
        .should include 'TP Generated Offset' # This verifies that the offset was actually generated.

    document_object_for(document).accounting_lines.each_value do |als|
      als.each do |al|
        @gl_offset_amount = al.amount.to_f if @gl_offset_amount.nil? # Grab it on the first go.

        @gl_offset_amount.should == al.amount.to_f # If this gets tripped, we added multiple lines and we probably need to refactor.

        # Now match both lines.
        page.item_row(al.line_description)[tlea_col].text.to_f.should == @gl_offset_amount
        page.item_row('TP Generated Offset')[tlea_col].text.to_f.should == @gl_offset_amount

      end
    end
  end
end

And /^the Object Codes for the (.*) document appear in the document's GLPE entry$/ do |document|
  step "I look up the #{document} document in the GLPE"

  on GeneralLedgerPendingEntryLookupPage do |page|
    document_object_for(document).accounting_lines.each_value do |als|
      als.each do |al|
        # This pulls the text of the Object Code column and makes sure the
        # Object Codes in each Accounting Line of the object are in that column.
        page.results_table
            .column(page.results_table.keyed_column_index(:object_code))
            .rest
            .map(&:text)
            .should include al.object
      end
    end
  end
end

And /^I look up the (.*) document in the GLPE$/ do |document|
  doc_object = document_object_for(document)

  visit(MainPage).general_ledger_pending_entry
  on GeneralLedgerPendingEntryLookupPage do |page|
    page.balance_type_code.fit         ''
    page.chart_code.fit                doc_object.accounting_lines[:source][0].chart_code # We're assuming this exists, of course.
    page.fiscal_year.fit               right_now[:year]
    page.fiscal_period.fit             fiscal_period_conversion(right_now[:MON])
    page.account_number.fit            '*'
    page.reference_document_number.fit doc_object.document_id
    page.search
  end
end

And /^I look up the (.*) document in the GL$/ do |document|
  doc_object = document_object_for(document)

  visit(MainPage).general_ledger_entry
  on GeneralLedgerEntryLookupPage do |page|
    page.balance_type_code.fit         ''
    page.chart_code.fit                doc_object.accounting_lines[:source][0].chart_code # We're assuming this exists, of course.
    page.fiscal_year.fit               right_now[:year]
    page.fiscal_period.fit             fiscal_period_conversion(right_now[:MON])
    page.account_number.fit            '*'
    page.reference_document_number.fit doc_object.document_id
    page.pending_entry_approved_indicator_all
    page.search
  end
end
