require 'csv'

And /^I start a (.*) document for "(.*)" file import$/ do  |document, file_name|
  doc_object = snake_case document
  object_klass = object_class_for(document)

  set(doc_object, create(object_klass, press:         nil,
                                       document_id:   @document_id,
                                       description:   random_alphanums(20, 'AFT AV '),
                                       initial_lines: [{
                                                         type:        :source,
                                                         file_name:   file_name.to_s
                                                       }]))

  step "I take the csv file \"#{file_name}\" and make into an array for the #{document} document"
end

And /^I start a (.*) document for from "(.*)" file import and to "(.*)" file import$/ do  |document, file_name, to_file_name|
  doc_object = snake_case document
  object_klass = object_class_for(document)

  set(doc_object, create(object_klass, press:         nil,
                                       document_id:   @document_id,
                                       description:   random_alphanums(20, 'AFT AV '),
                                       initial_lines: [{
                                                         type:      :source,
                                                         file_name: file_name
                                                       },
                                                       {
                                                         type:      :target,
                                                         file_name: to_file_name
                                                       }]))

  step "I take the csv file \"#{file_name}\" and make into an array for the #{document} document"
end

And /^on the (.*) I import the (From|To) Accounting Lines from a csv file$/ do |document, type|
  # This assumes you've provided a file_name in the first initial_lines entry for that type.
  doc_object = document_object_for(document)
    case type
      when 'From'
        doc_object.import_initial_lines(:source)
      when 'To'
        doc_object.import_initial_lines(:target)
    end
end

And /^I view the (.*) document on the General Ledger Entry$/ do |document|
  doc_object = document_object_for(document)

  visit(MainPage).general_ledger_entry

  on GeneralLedgerEntryLookupPage do |page|
    page.document_number.fit   doc_object.document_id
    page.chart_code.fit        get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
    page.balance_type_code.fit ''
    page.pending_entry_approved_indicator_all
    page.search
    page.open_item(doc_object.document_id)
  end
end

And /^the Template Accounting Line Description for (.*) equals the General Ledger entry$/ do |document|
  # This step requires that the CSV file content is placed into an array and that the CSV file was the last one loaded
  @imported_file.any?.should
  @imported_file.each { |line| line.collect{|c| c.nil? ? c : c.upcase}.should include on(AccountingLine).result_source_line_description.upcase }
end

And /^the (Grant|Receipt|Source|Target|Encumbrance|Disencumbrance) Template Accounting Line Description for (.*) equals the General Ledger entry$/ do |type, document|
  # This step requires that the CSV file content is placed into an array
  alt = AccountingLineObject::get_type_conversion(type)
  @imported_files[alt].each do |file|
    file.each do |line|
      line.collect { |c| c.nil? ? c : c.upcase }.should include on(AccountingLine).send("result_#{alt}_line_description").upcase
    end
  end
end

And /^I take the csv file "(.*)" and make into an array for the (.*) document$/ do |file_name, document|
#Leaving as a step def for now. If we get more tests that use reading a CSV import to test data then we should pull this into a method.
  @imported_file = []
  CSV.foreach($file_folder+file_name) do |line|
    case document
      when 'Non Check Disbursement'
        line[8].upcase!
      when 'General Error Correction'
        line[9].upcase!
      else
        line[7].upcase!
    end
    @imported_file << line
  end
end #step

And /^I upload a (Grant|Receipt|Source|Target|Encumbrance|Disencumbrance) line template for the (.*) document$/ do |type, document|
  doc_object = document_object_for(document)
  file_name = "#{object_class_for(document)::DOC_INFO[:type_code]}_#{snake_case(type).to_s}_line.csv"
  doc_object.import_lines(AccountingLineObject::get_type_conversion(type), file_name)

  step "I take the csv file \"#{file_name}\" and make into an array for the #{document} document"
  step "I add the imported #{type} Accounting Line file data to the stack"
end

And /^I add the imported (.*) Accounting Line file data to the stack$/ do |type|
  alt = AccountingLineObject::get_type_conversion(type)
  if @imported_files.nil?
    @imported_files = {alt => [@imported_file]}
  elsif @imported_files[alt].nil?
    @imported_files.merge!({alt => [@imported_file]})
  else
    @imported_files[alt] << @imported_file
  end
end