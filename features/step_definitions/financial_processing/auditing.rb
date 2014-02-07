And /^I view my Budget Adjustment document$/ do
   on(MainPage).doc_search
  on DocumentSearch do |page|
    page.document_id_field.fit @document_id
    page.search
    page.open_item(@budget_adjustment.document_id)
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

#
#And(/^On the Budget Adjustment I modify the From Object Code line item (\d+) to be (.*)$/) do |document, line_item, new_object_code|
#  doc_page_class = document.gsub(' ', '') + 'Page'
#  page_klass = Kernel.const_get(doc_page_class)
#
#  on page_klass do |page|
#    page.from_object_code_line_item(line_item).fit new_object_code
#  end
#end


And(/^On the (.*) I modify the Object Code line item (\d+) to be (.*)$/) do |document, line_item, new_object_code|
  doc_page_class = document.gsub(' ', '') + 'Page'
  page_klass = Kernel.const_get(doc_page_class)

  on page_klass do |page|
    page.object_code_line_item(line_item).fit new_object_code
  end
end

Then /^The Notes and Attachment Tab displays “Accounting Line changed from”$/ do
  on AuxiliaryVoucherPage do |page|
    page.expand_all
    page.account_line_changed_text.should exist
  end
end

And /^I visit the main page$/ do
  visit(MainPage)
  puts 'om on main page'
end

And /^I sleep for (\d+)$/ do |time|
  sleep time.to_i
end
