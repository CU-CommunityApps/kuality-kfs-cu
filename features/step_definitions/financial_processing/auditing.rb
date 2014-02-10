And /^I view my Budget Adjustment document$/ do
   on(MainPage).doc_search
  on DocumentSearch do |page|
    page.document_id_field.fit @document_id
    page.search
    page.open_item(@budget_adjustment.document_id)
  end
end

And /^I enter an Accounting Line on the (.*) document with account number (.*?) and object code (.*?) and amount (.*?) and reference number of (.*)$/ do |document, account_number, object_code, amount, reference_number|
  doc_page_class = document.gsub(' ', '') + 'Page'
  page_klass = Kernel.const_get(doc_page_class)

  on page_klass do |page|
    page.account_number.fit account_number
    page.object_code.fit object_code
    page.amount.fit amount
    page.reference_number.fit reference_number
    page.add_accounting_line
  end
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

  on page_klass do |page|
    page.from_account_number.fit account_number
    page.from_object_code.fit object_code

    page.from_current_amount.fit amount if page_klass.to_s == 'BudgetAdjustmentPage'

    page.from_amount.fit amount unless page_klass.to_s == 'BudgetAdjustmentPage'
    page.add_from_accounting_line
  end
end

And /^I enter a from Accounting Line on the (.*?) document with account number (.*?) and object code (.*?) and amount (.*?) and reference origin code (.*?) and reference number (.*)$/ do |document, account_number, object_code, amount, ref_org_code, ref_number|
  #for General Error CorRection
  doc_page_class = document.gsub(' ', '') + 'Page'
  page_klass = Kernel.const_get(doc_page_class)

  on page_klass do |page|
    page.from_account_number.fit account_number
    page.from_object_code.fit object_code
    page.from_amount.fit amount
    page.from_reference_origin_code.fit ref_org_code
    page.from_reference_number.fit ref_number
    page.add_from_accounting_line
  end
end

And /^I enter a to Accounting Line on the (.*?) document with account number (.*?) and object code (.*?) and amount (.*?) and reference origin code (.*?) and reference number (.*)$/ do |document, account_number, object_code, amount, ref_org_code, ref_number|
  #for General Error CoRrection
  doc_page_class = document.gsub(' ', '') + 'Page'
  page_klass = Kernel.const_get(doc_page_class)

  on page_klass do |page|
    page.to_account_number.fit account_number
    page.to_object_code.fit object_code
    page.to_amount.fit amount
    page.to_reference_origin_code.fit ref_org_code
    page.to_reference_number.fit ref_number
    page.add_to_accounting_line
  end
end

And /^On the Budget Adjustment I modify the From current amount line item (.*) to be (.*)$/ do |line_item, amount|
  on BudgetAdjustmentPage do |page|
    page.from_amount_line_item(line_item).fit amount
  end
end

And /^On the Budget Adjustment I modify the To current amount line item (.*) to be (.*)$/ do |line_item, amount|
  on BudgetAdjustmentPage do |page|
    page.to_amount_line_item(line_item).fit amount
  end
end

And /^I enter an Accounting Line on the (.*) document with account number (.*) and object code (.*) and debit amount (.*)$/ do |document, account_number, object_code, amount|
  doc_page_class = document.gsub(' ', '') + 'Page'
  page_klass = Kernel.const_get(doc_page_class)

  on page_klass do |page|
    page.account_number.fit account_number
    page.object_code.fit object_code
    page.debit.fit amount
    page.add_accounting_line
  end
end

And /^I enter an Accounting Line on the (.*) document with account number (.*) and object code (.*) and credit amount (.*)$/ do |document, account_number, object_code, amount|
  doc_page_class = document.gsub(' ', '') + 'Page'
  page_klass = Kernel.const_get(doc_page_class)

  on page_klass do |page|
    page.account_number.fit account_number
    page.object_code.fit object_code
    page.credit.fit amount
    page.add_accounting_line
  end
end

And(/^On the (.*) I modify the From Object Code line item (\d+) to be (.*)$/) do |document, line_item, new_object_code|
  doc_page_class = document.gsub(' ', '') + 'Page'
  page_klass = Kernel.const_get(doc_page_class)

  on page_klass do |page|
    page.from_object_code_line_item(line_item).fit new_object_code
  end
end

And(/^On the (.*) I modify the To Object Code line item (\d+) to be (.*)$/) do |document, line_item, new_object_code|
  doc_page_class = document.gsub(' ', '') + 'Page'
  page_klass = Kernel.const_get(doc_page_class)

  on page_klass do |page|
    page.to_object_code_line_item(line_item).fit new_object_code
  end
end

And(/^On the (.*) I modify the Object Code line item (\d+) to be (.*)$/) do |document, line_item, new_object_code|
  doc_page_class = document.gsub(' ', '') + 'Page'
  page_klass = Kernel.const_get(doc_page_class)

  on page_klass do |page|
    page.object_code_line_item(line_item).fit new_object_code
  end
end

Then /^The Notes and Attachment Tab displays "Accounting Line changed from"$/ do
  on AuxiliaryVoucherPage do |page|
    page.expand_all
    page.account_line_changed_text.should exist
  end
end

And /^I view my Pre Encumbrance document$/ do
  visit(MainPage).doc_search
  on DocumentSearch do |page|
    page.document_id_field.fit @document_id
    page.search
    page.open_item(@document_id)
  end
end

#SHOULD PROBABLY MOVE THESE AT SOME POINT TO A BETTER PLACE
And /^I visit the main page$/ do
  visit(MainPage)
  puts 'om on main page'
end

And /^I sleep for (\d+)$/ do |time|
  sleep time.to_i
end