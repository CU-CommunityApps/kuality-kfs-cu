And /^I create an Account$/ do
  @account = create AccountObject
end

And /^I create an Account with a lower case Sub Fund Program$/ do
  @account = create AccountObject, sub_fnd_group_cd: 'board', press: AccountPage::SAVE
end

When /^I submit the Account$/ do
  @account.submit
end

When /^I blanket approve the Account$/ do
  @account.blanket_approve
  sleep(10)
end

Then /^the Account Maintenance Document goes to (.*)/ do |doc_status|
  @account.view
  on(AccountPage).document_status.should == doc_status
end

When /^I create an account with blank SubFund group Code$/ do
  @account = create AccountObject, sub_fnd_group_cd: '', press: AccountPage::SUBMIT
end

Then /^I should get an error on saving that I left the SubFund Group Code field blank$/ do
  on(AccountPage).errors.should include 'Sub-Fund Group Code (SubFundGrpCd) is a required field.'
end


And /^I copy an Account$/ do
  steps %{
    Given I access Account Lookup
    And   I search for all accounts
  }
  on AccountLookupPage do |page|
    page.copy_random
  end
  on AccountPage do |page|
    page.description.set 'testing copy'
    page.save
  end
end

Then /^the Account Maintenance Document saves with no errors$/  do
  on(AccountPage).document_status.should == 'SAVED'
end

Then /^the Account Maintenance Document has no errors$/  do
  on(AccountPage).document_status.should == 'ENROUTE'
end

And /^I edit an Account to enter a Sub Fund Program in lower case$/ do
  visit(MainPage).account
  on AccountLookupPage do |page|
    page.subfund_program_code.set 'BOARD'
    page.search
    page.edit_random
  end
  on AccountPage do |page|
    page.description.set random_alphanums(40, 'AFT')
    page.subfund_program_code.set 'board'
    page.save
  end
  @account = make AccountObject
end

When /^I create an Account document with only the ([^"]*) field populated$/ do |field|
  default_fields = {
      description:          random_alphanums(40, 'AFT'),
      chart_code:           'IT', #TODO grab this from config file
      number:               random_alphanums(7),
      name:                 random_alphanums(10),
      org_cd:               '01G0',
      campus_cd:            'IT - Ithaca', #TODO grab this from config file
      effective_date:       '01/01/2010',
      postal_cd:            '14853', #TODO grab this from config file
      city:                 'Ithaca', #TODO grab this from config file
      state:                'NY', #TODO grab this from config file
      address:              'Cornell University', #TODO grab this from config file
      type_cd:              'CC - Contract College', #TODO grab this from config file
      sub_fnd_group_cd:     'ADMSYS',
      higher_ed_funct_cd:   '4000',
      restricted_status_cd: 'U - Unrestricted',
      fo_principal_name:    'dh273',
      supervisor_principal_name:  'ccs1',
      manager_principal_name: 'aap98',
      budget_record_level_cd: 'C - Consolidation',
      sufficient_funds_cd:    'C - Consolidation',
      expense_guideline_text: 'expense guideline text',
      income_guideline_txt:   'incomde guideline text',
      purpose_text:           'purpose text',
      income_stream_financial_cost_cd:  'IT - Ithaca Campus',
      income_stream_account_number:     '1000710',
      labor_benefit_rate_cat_code:      'CC'
  }

  # TODO: Make the Account document creation with a single field step more flexible.
  case field
    when 'Description'
      default_fields.each {|k, _| default_fields[k] = '' unless k.to_s.eql?('description') }
  end

  @account = create AccountObject, default_fields
end

And /^I clone a random Account with the following changes:$/ do |table|
  updates = table.rows_hash
  visit(MainPage).account
  on AccountLookupPage do |page|
    step 'I search for all accounts'
    page.copy_random
  end
  on AccountPage do |page|
    @account_number = random_alphanums(7)
    page.description.fit updates['Description']
    page.name.fit updates['Name']
    page.chart_code.fit updates['Chart Code']
    page.number.fit @account_number
    page.blanket_approve
  end
end

When /^I close the Account$/ do
  visit AccountLookupPage do |page|
    page.search
  end
end
