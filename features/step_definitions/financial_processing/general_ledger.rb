When /^I perform a (.*) Lookup using account number (.*)$/ do |gl_balance_inquiry_lookup, account_number|
  gl_balance_inquiry_lookup = gl_balance_inquiry_lookup.gsub!(' ', '_').downcase
  visit(MainPage).send(gl_balance_inquiry_lookup)
  if gl_balance_inquiry_lookup == 'current_fund_balance'
    on CurrentFundBalanceLookupPage do |page|
      page.chart_code.fit     get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
      page.account_number.fit account_number
      page.search
    end
  else
    on GeneralLedgerEntryLookupPage do |page|
      page.chart_code.fit     get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
      page.account_number.fit account_number
      page.search
    end
  end
end

Then /^the (.*) document GL Entry Lookup matches the document's GL entry$/ do |document|
  step "I lookup the Source Accounting Line of the #{document} document in the GL"

  on GeneralLedgerEntryLookupPage do |page|
    tled_col = page.results_table.keyed_column_index(:transaction_ledger_entry_description)
    tlea_col = page.results_table.keyed_column_index(:transaction_ledger_entry_amount)
    oc_col = page.results_table.keyed_column_index(:object_code)
    peai_col = page.results_table.keyed_column_index(:pending_entry_approved_indicator)
    rdn_col = page.results_table.keyed_column_index(:reference_document_number)

    page.results_table
        .column(tled_col)
        .rest
        .map(&:text)
        .should include 'TP Generated Offset' # This verifies that the offset was actually generated.

    document_object_for(document).accounting_lines.each_value do |als|
      als.each do |al|
        page.item_row(al.object)[oc_col].text.should == al.object
        page.item_row(al.object)[tled_col].text.should == al.line_description
        page.item_row(al.object)[tlea_col].text.to_f.should == al.amount.to_f
        page.item_row(al.object)[peai_col].text.should == ''
        page.item_row(al.object)[rdn_col].text.should == document_object_for(document).document_id
      end
    end
  end
end

And /^the (.*) document has matching GL and GLPE offsets$/ do |document|
  step "I lookup the offset for the #{document} document in the document's GLPE entry"
  step "I lookup the offset for the #{document} document in the document's GL entry"
  @glpe_offset_amount.should == @gl_offset_amount
end

And /^I lookup the offset for the (.*) document in the document's GLPE entry$/ do |document|
  step "I lookup the Source Accounting Line of the #{document} document in the GLPE"

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

And /^I lookup the offset for the (.*) document in the document's GL entry$/ do |document|
  step "I lookup the Source Accounting Line of the #{document} document in the GL"

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
  step "I lookup the Source Accounting Line of the #{document} document in the GLPE"

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

And /^I lookup the (Encumbrance|Disencumbrance|Source|Target|From|To) Accounting Line of the (.*) document in the GLPE$/ do |al_type, document|
  doc_object = document_object_for(document)
  alt = AccountingLineObject::get_type_conversion(al_type)

  visit(MainPage).general_ledger_pending_entry
  on GeneralLedgerPendingEntryLookupPage do |page|
    page.balance_type_code.fit         ''
    page.chart_code.fit                doc_object.accounting_lines[alt][0].chart_code # We're assuming this exists, of course.
    page.fiscal_year.fit               get_aft_parameter_value(ParameterConstants::CURRENT_FISCAL_YEAR)
    page.fiscal_period.fit             fiscal_period_conversion(right_now[:MON])
    page.account_number.fit            '*'
    page.reference_document_number.fit doc_object.document_id
    page.pending_entry_all.set
    page.search
  end
end

And /^I lookup the (Encumbrance|Disencumbrance|Source|Target|From|To) Accounting Line of the (.*) document in the GL$/ do |al_type, document|
  doc_object = document_object_for(document)
  alt = AccountingLineObject::get_type_conversion(al_type)

  visit(MainPage).general_ledger_entry
  on GeneralLedgerEntryLookupPage do |page|
    page.balance_type_code.fit         ''
    page.chart_code.fit                doc_object.accounting_lines[alt][0].chart_code # We're assuming this exists, of course.
    page.fiscal_year.fit               get_aft_parameter_value(ParameterConstants::CURRENT_FISCAL_YEAR)
    page.fiscal_period.fit             fiscal_period_conversion(right_now[:MON])
    page.account_number.fit            '*'
    page.reference_document_number.fit doc_object.document_id
    page.pending_entry_approved_indicator_all
    page.search
  end
end

And /^the (Encumbrance|Disencumbrance|Source|Target|From|To) Accounting Line appears in the (.*) document's (GLPE|GL) entry$/ do |al_type, document, entry_lookup|
  doc_object = document_object_for(document)
  alt = AccountingLineObject::get_type_conversion(al_type)
  step "I lookup the #{al_type} Accounting Line of the #{document} document in the #{entry_lookup}"

  case entry_lookup
    when 'GLPE'
      on(GeneralLedgerPendingEntryLookupPage).open_item_via_text(doc_object.accounting_lines[alt].first.line_description, doc_object.document_id)
    when 'GL'
      on(GeneralLedgerEntryLookupPage).open_item_via_text(doc_object.accounting_lines[alt].first.line_description, doc_object.document_id)
    else
      %w('GLPE', 'GL').any? { |opt| opt.include? entry_lookup }
  end

  step "the #{al_type} Accounting Line entry matches the #{document} document's entry"
end

When /^I lookup all entries for the current month in the General Ledger Balance lookup entry$/ do
  # This assumes you're already on the GLBL entry page somehow
  on(GeneralLedgerBalanceLookupPage).single_entry_monthly_item(fiscal_period_conversion(right_now[:MON]))
end

Then /^the General Ledger Balance lookup displays the document ID for the (.*) document$/ do |document|
  on(GeneralLedgerBalanceLookupPage).item_row(document_object_for(document).document_id).should
end