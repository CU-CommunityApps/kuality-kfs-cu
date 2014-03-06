And(/^I start a blank '(.*)' document$/) do   |document|
  doc_object = snake_case document
  #page_klass = Kernel.const_get(page_class_for(document))
  object_klass = Kernel.const_get(object_class_for(document))

  #visit(MainPage).(doc_object)
  set(doc_object, create(object_klass, press: nil))
end

And /^I start a (.*) document for "(.*)" file import$/ do  |document, file_name|
  doc_object = snake_case document
  #page_klass = Kernel.const_get(page_class_for(document))
  object_klass = Kernel.const_get(object_class_for(document))

  #visit(MainPage).(doc_object)
  set(doc_object, create(object_klass, press: nil,
                         description: random_alphanums(20, 'AFT AV '),
                         initial_lines: [{
                                             type: :source,
                                             file_name: file_name.to_s
                                         }], document_id: @document_id))
end

And /^I start a (.*) document for from "(.*)" file import and to "(.*)" file import$/ do  |document, from_file_name, to_file_name|
  doc_object = snake_case document
  object_klass = Kernel.const_get(object_class_for(document))

  set(doc_object, create(object_klass, press: nil,
                         description: random_alphanums(20, 'AFT AV '),
                         initial_lines: [{
                                             type: :source,
                                             file_name: from_file_name.to_s
                                         },
                                        {
                                            type: :target,
                                            file_name: to_file_name.to_s
                         }], document_id: @document_id))
end

And /^On the (.*) I import the (From|To) Accounting Lines from a csv file$/ do |document, type|
  page_klass = Kernel.const_get(page_class_for(document))
  doc_object = snake_case document
    case type
      when 'From'
        get(doc_object).accounting_lines[:source][0].import_lines
      when 'To'
        get(doc_object).accounting_lines[:target][0].import_lines
    end
end

Then(/^The Template Accounting Line Description equal the General Ledger$/) do

    visit(MainPage).general_ledger_pending_entry
    on GeneralLedgerPendingEntryLookupPage do |page|
      page.balance_type_code.fit 'AC'
      page.document_number.fit @auxiliary_voucher.document_id
      page.search
      #SELECT THE ID
      #CHECK THAT LINE DESCRIPTION IS PRESENT THAT WAS IN TEMPLATE
      page.open_item_via_text(@auxiliary_voucher.document_id)
    end

    on AuxiliaryVoucherPage do |page|
      page.item_row('****************40**********************').should exist
      #Need the File name, loop through file and then check that data exists on page

      puts 'Desc for AV found, now time to fail as these should not exists'
      page.item_row('LINE 2 FROM').should exist
      page.item_row('LINE 1 TO').should exist
      page.item_row('LINE 2 TO').should exist
    end
    endpending # express the regexp above with the code you wish you had
end
