class AccountObject < DataObject

#  include Navigation
#  include DateFactory
  include StringFactory

  attr_accessor :description, :chart_code, :number, :name, :org_cd, :campus_cd, :effective_date,
                :postal_cd, :city, :state, :address,
                :type_cd, :sub_fnd_group_cd, :higher_ed_funct_cd, :restricted_status_cd,
                :fo_principal_name, :supervisor_principal_name, :manager_principal_name,
                :budget_record_level_cd, :sufficient_funds_cd,
                :expense_guideline_text, :income_guideline_txt, :purpose_text,
                :income_stream_financial_cost_cd, :income_stream_account_number

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        description:          random_alphanums(40, 'AFT'),
        chart_code:           'BL', #TODO grab this from config file
        number:               random_alphanums(7),
        name:                 random_alphanums(10),
        org_cd:               'BI',
        campus_cd:            'BL - BLOOMINGTON', #TODO grab this from config file
        effective_date:       '01/01/2010',
        postal_cd:            '14853',
        city:                 'Ithaca',
        state:                'NY',
        address:              'Cornell University',
        type_cd:              'NA - NOT APPLICABLE',
        sub_fnd_group_cd:     'GENFND',
        higher_ed_funct_cd:   'IN',
        restricted_status_cd: 'U - UNRESTRICTED',
        fo_principal_name:    'jguillor',
        supervisor_principal_name:  'jaraujo',
        manager_principal_name: 'warriaga',
        budget_record_level_cd: 'C - Consolidation',
        sufficient_funds_cd:    'C - Consolidation',
        expense_guideline_text: 'expense guideline text',
        income_guideline_txt:   'incomde guideline text',
        purpose_text:           'purpose text',
        income_stream_financial_cost_cd:  'BL - BLOOMINGTON',
        income_stream_account_number:     '0142900'
    }
    set_options(defaults.merge(opts))
  end

  def create
    visit(MainPage).account
    on(AccountLookup).create
    on AccountPage do |page|
      page.expand_all
      page.type_cd.fit @type_cd
      page.description.focus
      page.alert.ok
      fill_out page, :description, :chart_code, :number, :name, :org_cd, :campus_cd,
               :effective_date, :postal_cd, :city, :state, :address, :sub_fnd_group_cd,
               :higher_ed_funct_cd, :restricted_status_cd, :fo_principal_name, :supervisor_principal_name,
               :manager_principal_name, :budget_record_level_cd, :sufficient_funds_cd, :expense_guideline_text,
               :income_guideline_txt, :purpose_text, :income_stream_financial_cost_cd, :income_stream_account_number
      page.save
    end
  end

  def submit
    on(AccountPage).submit
  end


end