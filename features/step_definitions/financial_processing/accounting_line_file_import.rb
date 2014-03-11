And(/^I start a blank '(.*)' document$/) do   |document|
  doc_object = snake_case document
  #page_klass = Kernel.const_get(page_class_for(document))
  object_klass = Kernel.const_get(object_class_for(document))

  set(doc_object, create(object_klass, press: nil))
end

And /^I start a (.*) document for "(.*)" file import$/ do  |document, file_name|
  doc_object = snake_case document
  #page_klass = Kernel.const_get(page_class_for(document))
  object_klass = Kernel.const_get(object_class_for(document))

  @import_file_array = []

  File.open($file_folder+file_name) do |file|
    while line = file.gets
      @import_file_array << line
    end

    @import_file_array.each do |comm|
      @import_split = comm.split(',')
    end
   case
     when document == 'Non Check Disbursement'
       @line_item =  @import_split[8].upcase
     else
       @line_item =  @import_split[7].upcase
   end

    #creates line_item array for verification
    puts @line_item.inspect
  end


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

  @import_file_array = []

  File.open($file_folder+from_file_name) do |file|
    while line = file.gets
      @import_file_array << line
    end

    @import_file_array.each do |comm|
      @import_split = comm.split(',')
    end

    @line_item =  @import_split[7].upcase
    #creates line_item array for verification
    puts @line_item.inspect
  end

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

#Then(/^The Template Accounting Line Description equal the General Ledger$/) do
#
#    visit(MainPage).general_ledger_pending_entry
#    on GeneralLedgerPendingEntryLookupPage do |page|
#      page.balance_type_code.fit 'AC'
#      page.document_number.fit @auxiliary_voucher.document_id
#      page.search
#      #SELECT THE ID
#      #CHECK THAT LINE DESCRIPTION IS PRESENT THAT WAS IN TEMPLATE
#      page.open_item_via_text(@auxiliary_voucher.document_id)
#    end
#
#    on AuxiliaryVoucherPage do |page|
#      page.item_row('****************40**********************').should exist
#      #Need the File name, loop through file and then check that data exists on page
#
#      puts 'Desc for AV found, now time to fail as these should not exists'
#      page.item_row('LINE 2 FROM').should exist
#      page.item_row('LINE 1 TO').should exist
#      page.item_row('LINE 2 TO').should exist
#    end
#    endpending # express the regexp above with the code you wish you had
#end

And /^I view the (.*) document on the General Ledger Entry$/ do |document|
  doc_object = snake_case document

  visit(MainPage).general_ledger_entry
  #visit(MainPage).general_ledger_pending_entry
  on GeneralLedgerEntryLookupPage do |page|
    page.document_number.fit get(doc_object).document_id
    #page.document_number.fit '9059379'
    #page.chart_code.fit get(document).chart_code
    page.chart_code.fit 'IT'
    page.balance_type_code.fit ''
    page.search
    sleep 3
    page.open_item(get(document).document_id)
    #page.open_item('9059379')
    #page.open_item_via_text(get(document).document_id)

  end

end

And /^The Template Accounting Line Description for (.*) equal the General Ledger$/ do |document|
  doc_object = snake_case document
  page_klass = Kernel.const_get(page_class_for(document))

  puts gets(doc_object).document_id.inspect

  puts 'line item is '
  puts @line_item.inspect

  on(page_klass).source_line_description_value.should == @line_item
  #
  #case
  #  when document == 'Auxiliary Voucher'
  #      on(page_klass).source_line_description_value.should == '****************40**********************'
  #  when document == 'Advanced Deposit'
  #    on(page_klass).source_line_description_value.should == 'TEST 643 ACCOUNTING LINE IMPORT'
  #  when document == 'Budget Adjustment'
  #    on(page_klass).source_line_description_value.should == 'TEST 643 ACCOUNTING LINE IMPORT'
  #  when document == 'Credit Card Receipt'
  #    on(page_klass).source_line_description_value.should == 'TEST 643 ACCT IMPORT'
  #  when document == 'Distribution of Income and Expense'
  #    on(page_klass).source_line_description_value.should == 'TEST 643 ACCOUNTING LINE IMPORT'
  #  when document == 'General Error Correction'
  #    on(page_klass).source_line_description_value.should == 'TEST 643 ACCOUNTING LINE IMPORT'
  #  when document == 'Internal Billing'
  #    on(page_klass).source_line_description_value.should == 'TEST 643 ACCOUNTING LINE IMPORT'
  #  when document == 'Service Billing'
  #    on(page_klass).source_line_description_value.should == @line_item[7].upcase
  #  when document == 'Journal Voucher'
  #    on(page_klass).source_line_description_value.should == 'TEST 643 ACCOUNTING LINE IMPORT'
  #  when document == 'Non Check Disbursement'
  #    on(page_klass).source_line_description_value.should == 'TEST 643 LINE IMPORT'
  #  when document == 'Transfer of Funds'
  #    on(page_klass).source_line_description_value.should == 'LINE IMPORT TEST --FROM'
  #  else
  #    on(page_klass).source_line_description_value.should == 'FAIL'
  #end
end


 And /^I take the csv file "(.*)" and make into an array$/ do |file_name|
@import_file_array = []

  File.open($file_folder+file_name) do |file|
    while line = file.gets
      @import_file_array << line
    end

    @import_file_array.each do |comm|
      @import_split = comm.split(',')
    end

    @line_item =  @import_split[7].upcase
    #creates line_item array for verification
    puts @line_item.inspect
  end
end



