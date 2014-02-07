And /^I copy a random (.*) document with (.*) status/ do |document, doc_status|
  doc_object = snake_case document
  doc_object_class = document.gsub(' ', '') + 'Object'
  doc_page_class = document.gsub(' ', '') + 'Page'
  object_klass = Kernel.const_get(doc_object_class)
  page_klass = Kernel.const_get(doc_page_class)

  on DocumentSearch do |search|
    search.document_type.set object_klass::DOC_INFO[:type_code]
    search.search
    @document_id = search.docs_with_status(doc_status, search).sample
    search.open_doc @document_id
  end

  on page_klass do |page|
    page.copy_current_document
    @document_id = page.document_id
  end

  set(doc_object, make(object_klass, document_id: @document_id))
  get(doc_object).save
#  get(doc_object).pull
end

When /^I view the (.*) document$/ do |document|
  doc_object = snake_case document
  get(doc_object).view
end

When /^I (#{BasePage::available_buttons}) the (.*) document$/ do |button, document|
  doc_object = snake_case document
  button.gsub!(' ', '_')
  get(doc_object).send(button)
  on(YesOrNoPage).yes if button == 'cancel'
end

Then /^the (.*) document goes to (.*)/ do |document, doc_status|
  doc_object = snake_case document

  sleep 10
  get(doc_object).view
  $current_page.document_status.should == doc_status
end


And /^I create a (.*) document$/ do |document|
  doc_object = snake_case document
  doc_object_class = document.gsub(' ', '') + 'Object'
  object_klass = Kernel.const_get(doc_object_class)

  #object_klass.skip_default_accounting_lines
  set(doc_object, create(object_klass))
  get(doc_object).save
end

And /^I create a (.*) document without accounting lines$/ do |document|
  doc_object = snake_case document
  doc_object_class = document.gsub(' ', '') + 'Object'
  object_klass = Kernel.const_get(doc_object_class)

  set(doc_object, create(object_klass, accounting_lines: [
      { new_account_number: '', new_account_object_code: '',
        new_account_amount: ''}], add_accounting_line: false,  press: :save))
  get(doc_object).save
end

And /^I enter to an Accounting Line on the (.*) document with account number (.*?) and object code (.*?) and amount (.*?)$/ do |document, account_number, object_code, amount|
  doc_page_class = document.gsub(' ', '') + 'Page'
  page_klass = Kernel.const_get(doc_page_class)

  on page_klass do |page|
    page.to_account_number.fit account_number
    page.to_object_code.fit object_code

    page.to_current_amount.fit amount if page_klass.to_s == 'BudgetAdjustmentPage'
    page.add_to_increase_accounting_line if page_klass.to_s == 'BudgetAdjustmentPage'

    page.to_amount.fit amount unless page_klass.to_s == 'BudgetAdjustmentPage'

    page.add_to_accounting_line
  end
end

And /^I enter from an Accounting Line on the (.*) document with account number (.*?) and object code (.*?) and amount (.*?)$/ do |document, account_number, object_code, amount|
  doc_page_class = document.gsub(' ', '') + 'Page'
  page_klass = Kernel.const_get(doc_page_class)

  puts page_klass.inspect
  on page_klass do |page|
    page.from_account_number.fit account_number
    page.from_object_code.fit object_code

    page.from_current_amount.fit amount if page_klass.to_s == 'BudgetAdjustmentPage'
    #page.add_from_decrease_accounting_line if page_klass.to_s == 'BudgetAdjustmentPage'



    page.from_amount.fit amount unless page_klass.to_s == 'BudgetAdjustmentPage'

    page.add_from_accounting_line

  end
end



And /^I enter a from Accounting Line on the (.*?) document with account number (.*?) and object code (.*?) and amount (.*?) and reference origin code (.*?) and reference number (.*)$/ do |document, account_number, object_code, amount, ref_org_code, ref_number|
  #for General Error Corection
  doc_page_class = document.gsub(' ', '') + 'Page'
  page_klass = Kernel.const_get(doc_page_class)

  on page_klass do |page|
    page.from_account_number.fit account_number
    page.from_object_code.fit object_code

    #page.to_current_amount.fit amount if page_klass.to_s == 'BudgetAdjustmentPage'
    #page.add_to_increase_accounting_line if page_klass.to_s == 'BudgetAdjustmentPage'

    page.from_amount.fit amount #unless page_klass.to_s == 'BudgetAdjustmentPage'

    page.from_reference_origin_code.fit ref_org_code
    page.from_reference_number.fit ref_number

    page.add_from_accounting_line
  end
end


And /^I enter a to Accounting Line on the (.*?) document with account number (.*?) and object code (.*?) and amount (.*?) and reference origin code (.*?) and reference number (.*)$/ do |document, account_number, object_code, amount, ref_org_code, ref_number|
  #for General Error Corection
  doc_page_class = document.gsub(' ', '') + 'Page'
  page_klass = Kernel.const_get(doc_page_class)

  on page_klass do |page|
    page.to_account_number.fit account_number
    page.to_object_code.fit object_code

    #page.to_current_amount.fit amount if page_klass.to_s == 'BudgetAdjustmentPage'
    #page.add_to_increase_accounting_line if page_klass.to_s == 'BudgetAdjustmentPage'

    page.to_amount.fit amount #unless page_klass.to_s == 'BudgetAdjustmentPage'

    page.to_reference_origin_code.fit ref_org_code
    page.to_reference_number.fit ref_number

    page.add_to_accounting_line
  end
end