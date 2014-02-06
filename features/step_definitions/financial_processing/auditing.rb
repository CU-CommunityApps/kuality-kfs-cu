And /^I create my Auxiliary Voucher document without accounting lines$/ do
  @auxiliary_voucher = create AuxiliaryVoucherObject,  accounting_lines: [
      # Dangerously close to needing to be a Data Object proper...
      { new_account_number: '', #TODO get from config
        new_account_object_code: '', #TODO get from config
        new_account_amount: '', add_accounting_line: false }],  press: :save
end

And /^I create my Budget Adjustment document without accounting lines$/ do
  @budget_adjustment = create BudgetAdjustmentObject,  accounting_lines: [
      # Dangerously close to needing to be a Data Object proper...
      { new_account_number: '', #TODO get from config
        new_account_object_code: '', #TODO get from config
        new_account_amount: '', add_accounting_line: false }],  press: :save
end

And /^I create my Distribution Of Income And Expense document without accounting lines$/ do
 @distribution_of_income_and_expense = create DistributionOfIncomeAndExpenseObject,  accounting_lines: [
      # Dangerously close to needing to be a Data Object proper...
      { from_account_number: '', #TODO get from config
        from_account_object_code: '', #TODO get from config
        from_account_amount: '', add_accounting_line: false }],  press: :save
end


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
And /^I visit the main page$/ do
  visit(MainPage)
  on MainPage do |page|
       puts 'am i on main page'

     end
end

And /^I sleep for (.*?)$/ do |time|
  sleep time.to_i
end

And /^On the Budget Adjustment document I add a From Accounting Line with account number (.*) and object code (.*?) and amount (.*)$/ do |account_number, object_code, amount|
  on BudgetAdjustmentPage do |page|
    page.from_account_number.fit account_number
    page.from_object_code.fit object_code
    page.from_current_amount.fit amount
    page.add_from_accounting_line
  end
end

And /^On the Budget Adjustment document I add a To Accounting Line with account number (.*) and object code (.*?) and amount (.*)$/ do |account_number, object_code, amount|
  on BudgetAdjustmentPage do |page|
    page.to_account_number.fit account_number
    page.to_object_code.fit object_code
    page.to_current_amount.fit amount
    page.add_to_accounting_line
  end
end


#And /^On the (.*) I enter a From Accounting Line with account number (.*?) and object code (.*?) and amount (.*)$/ do |document, account_number, object_code, amount|
#  doc_page_class = document.gsub(' ', '') + 'Page'
#  page_klass = Kernel.const_get(doc_page_class)
#
#  if page_klass == AuxiliaryVoucherPage
#    on page_klass do |page|
#      page.account_number.fit account_number
#      page.object_code.fit object_code
#      page.debit.fit amount
#      page.add_accounting_line
#    end
#  end
#
#  if page_klass == BudgetAdjustmentPage
#    on page_klass do |page|
#      page.from_account_number.fit account_number
#      page.from_object_code.fit object_code
#      page.from_current_amount.fit amount
#      page.add_from_accounting_line
#      #budget adjustment needs 2
#
#      page.from_account_number.fit 'G003704'
#      page.from_object_code.fit '6510'
#      page.from_current_amount.fit '250'
#      page.add_from_accounting_line
#      #budget adjustment needs 2
#
#    end
#  end
#
#
#  if page_klass == DistributionOfIncomeAndExpensePage
#    on page_klass do |page|
#      page.from_account_number.fit account_number
#      page.from_object_code.fit object_code
#      page.from_amount.fit amount
#      page.add_from_accounting_line
#    end
#  end
#
#end

#And /^On the (.*) I enter a To Accounting Line with account number (.*?) and object code (.*?) and amount (.*)$/ do |document, account_number, object_code, amount|
#  doc_page_class = document.gsub(' ', '') + 'Page'
#  page_klass = Kernel.const_get(doc_page_class)
#
#  if page_klass == AuxiliaryVoucherPage
#    on page_klass do |page|
#      page.account_number.fit account_number
#      page.object_code.fit object_code
#      #Credit makes this a To, but uses the basic account html tags.
#      page.credit.fit amount
#      page.add_accounting_line
#    end
#  end
#
#  if page_klass == BudgetAdjustmentPage
#    on page_klass do |page|
#      page.to_account_number.fit account_number
#      page.to_object_code.fit object_code
#      page.to_current_amount.fit amount
#      page.add_to_accounting_line
#
#      page.to_account_number.fit 'G013300'
#      page.to_object_code.fit '6510'
#      page.to_current_amount.fit '250'
#      page.add_to_accounting_line
#      #budget adjustment needs 2
#    end
#  end
#
#  if page_klass == DistributionOfIncomeAndExpensePage
#    on page_klass do |page|
#      page.to_account_number.fit account_number
#      page.to_object_code.fit object_code
#      page.to_amount.fit amount
#      page.add_to_accounting_line
#    end
#  end
#end
#

#And /^On the (.*) I modify the From Accounting Line with (.*)$/ do |document, change_amount|
#  doc_page_class = document.gsub(' ', '') + 'Page'
#  page_klass = Kernel.const_get(doc_page_class)
#
#  puts page_klass.inspect
#
#  if page_klass == AuxiliaryVoucherPage
#    on page_klass do |page|
#      page.debit_line_item(0).fit change_amount
#      page.save
#    end
#  end
#
#  if page_klass ==   BudgetAdjustmentPage
#    puts 'Budget adjust need 2 time to add From and To'
#    on page_klass do |page|
#
#      @press = :save
#      page.send(@press)
#    end
#  end
#
#  if page_klass ==  DistributionOfIncomeAndExpensePage
#    puts 'Dis of Income time to add From and To'
#    on page_klass do |page|
#       sleep 30
#
#       @press = :save
#       page.send(@press)
#    end
#  end
#end
#
#And /^On the (.*) I modify the To Accounting Line with (.*)$/ do |document, change_amount|
#  doc_page_class = document.gsub(' ', '') + 'Page'
#  page_klass = Kernel.const_get(doc_page_class)
#
#  puts page_klass.inspect
#
#  if page_klass == AuxiliaryVoucherPage
#    on page_klass do |page|
#      page.credit_line_item(1).fit change_amount
#      page.save
#    end
#  end
#end




Then /^The Notes and Attachment Tab displays “Accounting Line changed from”$/ do
  on AuxiliaryVoucherPage do |page|
    page.expand_all
    page.account_line_changed_text.should exist
  end
end