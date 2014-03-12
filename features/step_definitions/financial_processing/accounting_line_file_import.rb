#And(/^I start a blank '(.*)' document$/) do   |document|
#  doc_object = snake_case document
#  object_klass = Kernel.const_get(object_class_for(document))
#  set(doc_object, create(object_klass, press: nil))
#end

And /^I start a (.*) document for "(.*)" file import$/ do  |document, file_name|
  doc_object = snake_case document
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
    when document == 'General Error Correction'
      @line_item =  @import_split[9].upcase
    else
       @line_item =  @import_split[7].upcase
   end
  end

  set(doc_object, create(object_klass, press: nil,
                         description: random_alphanums(20, 'AFT AV '),
                         initial_lines: [{
                                             type: :source,
                                             file_name: file_name.to_s
                                         }], document_id: @document_id))
end

And /^I start a (.*) document for from "(.*)" file import and to "(.*)" file import$/ do  |document, file_name, to_file_name|
  doc_object = snake_case document
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
      when document == 'General Error Correction'
        @line_item =  @import_split[9].upcase
      else
        @line_item =  @import_split[7].upcase
    end
  end

  set(doc_object, create(object_klass, press: nil,
                         description: random_alphanums(20, 'AFT AV '),
                         initial_lines: [{
                                             type: :source,
                                             file_name: file_name.to_s
                                         },
                                        {
                                            type: :target,
                                            file_name: to_file_name.to_s
                         }], document_id: @document_id))
end

And /^On the (.*) I import the (From|To) Accounting Lines from a csv file$/ do |document, type|
  doc_object = snake_case document
    case type
      when 'From'
        get(doc_object).accounting_lines[:source][0].import_lines
      when 'To'
        get(doc_object).accounting_lines[:target][0].import_lines
    end
  end

And /^I view the (.*) document on the General Ledger Entry$/ do |document|
  doc_object = snake_case document

  visit(MainPage).general_ledger_entry

  on GeneralLedgerEntryLookupPage do |page|
    page.document_number.fit get(doc_object).document_id
    page.chart_code.fit 'IT'
    page.balance_type_code.fit ''
    page.search
    page.open_item(get(document).document_id)
  end
end

And /^The Template Accounting Line Description for (.*) equal the General Ledger$/ do |document|
  page_klass = Kernel.const_get(page_class_for(document))

  #requires the @import_file_array
  on(page_klass).source_line_description_value.should == @line_item
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

    case
      when document == 'Non Check Disbursement'
        @line_item =  @import_split[8].upcase
      when document == 'General Error Correction'
        @line_item =  @import_split[9].upcase
      else
        @line_item =  @import_split[7].upcase
     end
  end #file.open
end #step
