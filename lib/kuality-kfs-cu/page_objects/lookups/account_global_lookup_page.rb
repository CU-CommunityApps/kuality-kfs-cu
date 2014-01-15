#overriding kuality-kfs object
class AccountGlobalLookupPage

  #TODO:: Think about out lookup is done as of this time major_reporting_category_code is on 3 different_page.rb
  #element(:major_reporting_category_code) { |b| b.frm.text_field(name: 'extension.majorReportingCategoryCode') }
  action(:major_reporting_category_code_lookup) { |b| b.frm.button(alt: 'Search Major Reporting Category Code').click }

end