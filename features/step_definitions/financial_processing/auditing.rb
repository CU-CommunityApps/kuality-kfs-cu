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

And /^on the (.*) document I modify the (From|To) Object Code line item (\d+) to be (.*)$/ do |document, from_or_to, line_item, new_object_code|
  on page_class_for(document) do |page|
    case from_or_to
      when 'From'
        page.update_source_object_code(line_item).fit new_object_code

      when 'To'
        page.update_target_object_code(line_item).fit new_object_code
    end
  end
end

And /^on the (.*) document I modify the Object Code line item (\d+) to be (.*)$/ do |document, line_item, new_object_code|
  on page_class_for(document) do |page|
    page.update_source_object_code(line_item).fit new_object_code
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

    @budget_adjustment.add_source_line({
      account_number: 'G003704',
      object: '4480',
      current_amount: '250'
    })
    @budget_adjustment.add_source_line({
      account_number: 'G003704',
      object: '6510',
      current_amount: '250'
    })
    @budget_adjustment.add_target_line({
      account_number: 'G013300',
      object: '4480',
      current_amount: '250'
    })
    @budget_adjustment.add_target_line({
      account_number: 'G013300',
      object: '6510',
      current_amount: '250'
    })
  end
end

And /^I add accounting lines to test the notes tab for the Auxiliary Voucher doc$/   do
  on AuxiliaryVoucherPage do
  @auxiliary_voucher.add_source_line({
    account_number: 'H853800',
    object: '6690',
    debit: '100'
  })
  @auxiliary_voucher.add_source_line({
    account_number: 'H853800',
    object: '6690',
    credit: '100'
  })
  end
end

And /^I add accounting lines to test the notes tab for the General Error Correction doc$/ do
  on GeneralErrorCorrectionPage do

    @general_error_correction.add_source_line({
      account_number: 'G003704',
      object: '4480',
      amount: '255.55',
      reference_origin_code: '01',
      reference_number: '777001'
    })

    @general_error_correction.add_target_line({
      account_number: 'G013300',
      object: '4480',
      amount: '255.55',
      reference_origin_code: '01',
      reference_number: '777002'
    })
  end
end

And /^I add accounting lines to test the notes tab for the Pre-Encumbrance doc$/ do
  on PreEncumbrancePage do
    @pre_encumbrance.add_source_line({
      account_number: 'G003704',
      object: '6540',
      amount: '345000'
    })
  end
end

And /^I add accounting lines to test the notes tab for the Non Check Disbursement doc$/ do
  on NonCheckDisbursementPage do
    @non_check_disbursement.add_source_line({
      account_number: 'G003704',
      object: '6540',
      amount: '200000.22',
      reference_number: '1234'
    })
  end
end

And /^I add a (From|To) accounting line to the (.*) document with:$/ do |from_or_to, document, table|
  doc_object = snake_case document
  page_klass = page_class_for document

  updates = table.rows_hash

  case from_or_to
    when 'From'
      on page_klass do
        get(doc_object).add_source_line({
          account_number: updates['from account number'],
          object: updates['from object code'],
          amount: updates['from amount']
        })
      end

    when 'To'
      on page_klass do
        get(doc_object).add_target_line({
          account_number: updates['to account number'],
          object: updates['to object code'],
          amount: updates['to amount']
        })
      end
  end
end
