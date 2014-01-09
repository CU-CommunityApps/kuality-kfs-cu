# Cornell Specific mod
class MajorReportingCategoryLookupPage < Lookups

  #element(:major_reporting_category_code) { |b| b.frm.text_field(name: 'extension.majorReportingCategoryCode') }
  element(:major_reporting_category_name) { |b| b.frm.text_field(name: 'majorReportingCategoryName') }

end