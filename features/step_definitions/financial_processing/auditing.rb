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

And(/^On the (.*) I modify the (From|To) Object Code line item (\d+) to be (.*)$/) do |document, from_or_to, line_item, new_object_code|
  doc_page_class = document.gsub(' ', '') + 'Page'
  page_klass = Kernel.const_get(doc_page_class)

  on page_klass do |page|
    case from_or_to
      when 'From'
        page.from_object_code_line_item(line_item).fit new_object_code

      when 'To'
        page.to_object_code_line_item(line_item).fit new_object_code
    end
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

And /^I add accounting lines to test the notes tab for the Budget Adjustment doc$/ do

  on BudgetAdjustmentPage do
    @budget_adjustment.add_from_line({
      from_account_number: 'G003704',
      from_object_code: '4480',
      from_current_amount: '250'
    })
    @budget_adjustment.add_from_line({
      from_account_number: 'G003704',
      from_object_code: '6510',
      from_current_amount: '250'
    })
    @budget_adjustment.add_to_line({
      to_account_number: 'G013300',
      to_object_code: '4480',
      to_current_amount: '250'
    })
    @budget_adjustment.add_to_line({
      to_account_number: 'G013300',
      to_object_code: '6510',
      to_current_amount: '250'
    })
  end
end

And /^I add accounting lines to test the notes tab for the Auxiliary Voucher doc$/   do
  on AuxiliaryVoucherPage do
  @auxiliary_voucher.add_from_line({
    from_account_number: 'H853800',
    from_object_code: '6690',
    debit: '100'
  })
  @auxiliary_voucher.add_from_line({
    from_account_number: 'H853800',
    from_object_code: '6690',
    credit: '100'
  })
  end
end

And /^I add accounting lines to test the notes tab for the General Error Correction doc$/ do
  on GeneralErrorCorrectionPage do

    @general_error_correction.add_from_line({
      from_account_number: 'G003704',
      from_object_code: '4480',
      from_amount: '255.55',
      from_reference_origin_code: '01',
      from_reference_number: '777001'
    })

    @general_error_correction.add_to_line({
      to_account_number: 'G013300',
      to_object_code: '4480',
      to_amount: '255.55',
      to_reference_origin_code: '01',
      to_reference_number: '777002'
    })
  end
end

And /^I add accounting lines to test the notes tab for the Pre Encumbrance doc$/ do
  on PreEncumbrancePage do
    @pre_encumbrance.add_from_line({
      from_account_number: 'G003704',
      from_object_code: '6540',
      from_amount: '345000'
    })
  end
end

And /^I add accounting lines to test the notes tab for the Non Check Disbursement doc$/ do
  on NonCheckDisbursementPage do
    @non_check_disbursement.add_from_line({
      from_account_number: 'G003704',
      from_object_code: '6540',
      from_amount: '200000.22',
      from_reference_number: '1234'
    })
  end
end

And /^I add a (From|To) accounting line to the (.*) document with:$/ do |from_or_to, document, table|
  doc_object = snake_case document
  doc_page_class = document.gsub(' ', '') + 'Page'
  page_klass = Kernel.const_get(doc_page_class)

  updates = table.rows_hash

  case from_or_to
    when 'From'
      on page_klass do
        get(doc_object).add_from_line({
          from_account_number: updates['from account number'],
          from_object_code: updates['from object code'],
          from_amount: updates['from amount']
        })
      end

    when 'To'
      on page_klass do
        get(doc_object).add_to_line({
          to_account_number: updates['to account number'],
          to_object_code: updates['to object code'],
          to_amount: updates['to amount']
        })
      end
  end
end

#SHOULD PROBABLY MOVE THESE AT SOME POINT TO A BETTER PLACE
And /^I visit the main page$/ do
  visit(MainPage)
end

And /^I sleep for (\d+)$/ do |time|
  sleep time.to_i
end
