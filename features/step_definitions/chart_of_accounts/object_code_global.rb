And /^I (#{ObjectCodeGlobalPage::available_buttons}) an Object Code Global document$/ do |button|
  @object_code_global = create ObjectCodeGlobalObject, press: button.gsub(' ', '_')
end

And /^I enter an invalid CG Reporting Code of (.*)$/ do |invalid_code|
  on(ObjectCodeGlobalPage).cg_reporting_code.fit invalid_code
end
