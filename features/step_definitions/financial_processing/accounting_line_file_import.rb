And /^I open a blank (.*) document$/ do |document|
  doc_object = snake_case document

  get(doc_object).send(button)

  object_klass = Kernel.const_get(object_class_for(document))
  page_klass = Kernel.const_get(page_class_for(document))

end


And /^For the (.*) document I upload a csv file (.*) with From accounting lines$/ do   |document, file_name|
  page_klass = Kernel.const_get(page_class_for(document))

  on page_klass do |page|
  page.import_lines_from

  page.account_line_from_file_name.set($file_folder+@budget_adjustment.(file_name) )

  page.add_from_import
  #set to array ?
  end

end

And /^ I upload csv file (.*) containing to accounting lines$/ do   |file_name|
  page.import_lines_to

  page.account_line_to_file_name.set($file_folder+@budget_adjustment.(file_name) )

  page.add_to_import
  #set to array ?
end
