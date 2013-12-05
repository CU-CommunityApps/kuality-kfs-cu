require 'test-factory'

Dir["#{File.dirname(__FILE__)}/kuality-kfs/*.rb"].alphabetize.each {|f| require f }
Dir["#{File.dirname(__FILE__)}/kuality-kfs/page_objects/*.rb"].alphabetize.each {|f| require f }
Dir["#{File.dirname(__FILE__)}/kuality-kfs/page_objects/*/*.rb"].alphabetize.each {|f| require f }
Dir["#{File.dirname(__FILE__)}/kuality-kfs/data_objects/*.rb"].alphabetize.each {|f| require f }
Dir["#{File.dirname(__FILE__)}/kuality-kfs/data_objects/*/*.rb"].alphabetize.each {|f| require f }

# Initialize this class at the start of your test cases to
# open the specified test browser at the specified welcome page URL.
#
# The initialization will
# create the browser object that can be used throughout the page classes
class Kuality

  attr_reader :browser

  def initialize(web_browser)
    @browser = Watir::Browser.new web_browser
    @browser.window.resize_to(1400,900)
    @browser.goto $base_url
  end

end