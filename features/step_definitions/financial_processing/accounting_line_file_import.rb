And /^I create a blank '(.*)' document$/ do |document|
  doc_object = snake_case document
  page_klass = Kernel.const_get(page_class_for(document))
  object_klass = Kernel.const_get(object_class_for(document))

  doc_var = doc_object.to_s


  puts doc_object.inspect
  puts 'aws the doc obj'
  puts object_klass.inspect
  puts 'was the object klass'
  puts doc_var.inspect
  puts 'was the doc var'
  visit(MainPage).send(doc_object)
  #doc_var.to_s = make object_klass.to_s

  @doc_var = make object_klass

  puts @doc_var.inspect
  puts 'was the @cdoc var'
end


And /^For the (.*) document I upload a csv file (.*) with From accounting lines$/ do   |document, file_name|
  page_klass = Kernel.const_get(page_class_for(document))

  on page_klass do |page|
    page.import_lines_from
    page.account_line_from_file_name.set($file_folder+"#{file_name}" )
    page.add_from_import
    #set to array ?
  end

end

And /^For the (.*) document I upload a csv file (.*) with To accounting lines$/ do   |document, file_name|
  page_klass = Kernel.const_get(page_class_for(document))

  on page_klass do |page|
    page.import_lines_to
    page.account_line_to_file_name.set($file_folder+"#{file_name}" )
    page.add_to_import
    #set to array ?
  end

end
