When /^I perform a (.*) Lookup using account number (.*)$/ do |gl_balance_inquiry_lookup, account_number|
  gl_balance_inquiry_lookup = gl_balance_inquiry_lookup.gsub!(' ', '_').downcase
  visit(MainPage).send(gl_balance_inquiry_lookup)
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
    page.fiscal_year.fit               right_now[:year]
    page.fiscal_period.fit             fiscal_period_conversion(right_now[:MON])
    page.account_number.fit            '*'
    page.reference_document_number.fit doc_object.document_id
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
    page.fiscal_year.fit               right_now[:year]
    page.fiscal_period.fit             fiscal_period_conversion(right_now[:MON])
    page.account_number.fit            '*'
    page.reference_document_number.fit doc_object.document_id
    page.search
  end
end

And /^the (Encumbrance|Disencumbrance|Source|Target|From|To) Accounting Line appears in the (.*) document's GLPE entry$/ do |al_type, document|
  doc_object = document_object_for(document)
  alt = AccountingLineObject::get_type_conversion(al_type)
  step "I lookup the #{al_type} Accounting Line of the #{document} document in the GLPE"

  on(GeneralLedgerPendingEntryLookupPage).open_item_via_text(doc_object.accounting_lines[alt].first.line_description, doc_object.document_id)

  step "the #{al_type} Accounting Line entry matches the #{document} document's entry"

  #on AccountingLine do |entry_page|
  #  # We're going to just compare against the first submitted line
  #  ((entry_page.send("result_#{alt.to_s}_chart_code")).should == doc_object.accounting_lines[alt].first.chart_code) unless doc_object.accounting_lines[alt].first.chart_code.nil?
  #  ((entry_page.send("result_#{alt.to_s}_account_number")).should == doc_object.accounting_lines[alt].first.account_number) unless doc_object.accounting_lines[alt].first.account_number.nil?
  #  ((entry_page.send("result_#{alt.to_s}_sub_account_code")).should == doc_object.accounting_lines[alt].first.sub_account) unless doc_object.accounting_lines[alt].first.sub_account.nil?
  #  ((entry_page.send("result_#{alt.to_s}_object_code")).should == doc_object.accounting_lines[alt].first.object) unless doc_object.accounting_lines[alt].first.object.nil?
  #  ((entry_page.send("result_#{alt.to_s}_sub_object_code")).should == doc_object.accounting_lines[alt].first.sub_object) unless doc_object.accounting_lines[alt].first.sub_object.nil?
  #  ((entry_page.send("result_#{alt.to_s}_project_code")).should == doc_object.accounting_lines[alt].first.project) unless doc_object.accounting_lines[alt].first.project.nil?
  #  ((entry_page.send("result_#{alt.to_s}_organization_reference_id")).should == doc_object.accounting_lines[alt].first.org_ref_id) unless doc_object.accounting_lines[alt].first.org_ref_id.nil?
  #  ((entry_page.send("result_#{alt.to_s}_line_description")).should == doc_object.accounting_lines[alt].first.line_description) unless doc_object.accounting_lines[alt].first.line_description.nil?
  #  ((entry_page.send("result_#{alt.to_s}_reference_origin_code")).should == doc_object.accounting_lines[alt].first.reference_origin_code) unless doc_object.accounting_lines[alt].first.reference_origin_code.nil?
  #  ((entry_page.send("result_#{alt.to_s}_reference_number")).should == doc_object.accounting_lines[alt].first.reference_number) unless doc_object.accounting_lines[alt].first.reference_number.nil?
  #  ((entry_page.send("result_#{alt.to_s}_amount")).to_f.should == doc_object.accounting_lines[alt].first.amount.to_f) unless doc_object.accounting_lines[alt].first.amount.nil?
  #  ((entry_page.send("result_#{alt.to_s}_base_amount")).to_f.should == doc_object.accounting_lines[alt].first.base_amount.to_f) unless doc_object.accounting_lines[alt].first.base_amount.nil?
  #  ((entry_page.send("result_#{alt.to_s}_current_amount")).to_f.should == doc_object.accounting_lines[alt].first.current_amount.to_f) unless doc_object.accounting_lines[alt].first.current_amount.nil?
  #end
end

Then /^the (Encumbrance|Disencumbrance|Source|Target|From|To) Accounting Line appears in the (.*) document's GL entry$/ do |al_type, document|
  doc_object = document_object_for(document)
  alt = AccountingLineObject::get_type_conversion(al_type)
  step "I lookup the #{al_type} Accounting Line of the #{document} document in the GL"

  on(GeneralLedgerEntryLookupPage).open_item_via_text(doc_object.accounting_lines[alt].first.line_description, doc_object.document_id)

  step "the #{al_type} Accounting Line entry matches the #{document} document's entry"
end

When /^I lookup all entries for the current month in the General Ledger Balance lookup entry$/ do
  # This assumes you're already on the GLBL entry page somehow
  on(GeneralLedgerBalanceLookupPage).single_entry_monthly_item(fiscal_period_conversion(right_now[:MON]))
end

Then /^the General Ledger Balance lookup displays the document ID for the (.*) document$/ do |document|
  on(GeneralLedgerBalanceLookupPage).item_row(document_object_for(document).document_id).should
end