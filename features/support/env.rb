require 'rubygems'
require 'yaml'
require 'cucumber'
require 'headless'

@config = YAML.load_file("#{File.dirname(__FILE__)}/config.yml")[:basic]

$base_url = @config[:url]
if ENV['URL']
  $base_url = ENV['URL']
end

$file_folder = "#{File.dirname(__FILE__)}/../../lib/resources/"

require "#{File.dirname(__FILE__)}/../../lib/kuality-kfs"
require 'rspec/matchers'

World Foundry
World StringFactory
World DateFactory

if ENV['HEADLESS']
  headless = Headless.new
  headless.start
  at_exit do
    headless.destroy
  end
end

kuality = Kuality.new @config[:browser]

Before do
  @browser = kuality.browser
end

After do |scenario|

  if scenario.failed?
    @browser.screenshot.save 'screenshot.png'
    embed 'screenshot.png', 'image/png'
  end

end

# Comment out to help with debugging...
at_exit { kuality.browser.close }