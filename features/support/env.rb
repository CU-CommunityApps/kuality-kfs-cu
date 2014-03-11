require 'rubygems'
require 'yaml'
require 'cucumber'
require 'headless'
#require 'csv'

@config = YAML.load_file("#{File.dirname(__FILE__)}/config.yml")[:basic]

$base_url = @config[:kfs_url]
$base_rice_url = @config[:rice_url]
if ENV['URL']
  $base_url = ENV['URL']
end

$file_folder = "#{File.dirname(__FILE__)}/../../lib/resources/"

require "#{File.dirname(__FILE__)}/../../lib/kuality-kfs-cu"
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

kuality = KualityKFS.new @config[:browser]
$users = Users.instance

Before do
  @browser = kuality.browser
  $users.clear
  # Add the admin user to the Users...
  $users << UserObject.new(@browser)
end

After do |scenario|

  if scenario.failed?
    @browser.screenshot.save 'screenshot.png'
    embed 'screenshot.png', 'image/png'
  end

  $users.current_user.sign_out unless $users.current_user.nil?

end

if !ENV['DEBUG']
  at_exit { kuality.browser.close }
end