require 'rubygems'
require 'yaml'
require 'cucumber'
require 'headless'

@config = YAML.load_file("#{File.dirname(__FILE__)}/config.yml")[:basic]
@config[:browser] = ENV['BROWSER'].to_sym if ENV['BROWSER']

$base_url = ENV['KFS_URL'] ? ENV['KFS_URL'] : @config[:kfs_url]
$base_rice_url = ENV['RICE_URL'] ? ENV['RICE_URL'] : @config[:rice_url]
$file_folder = "#{File.dirname(__FILE__)}/../../lib/resources/"

require "#{File.dirname(__FILE__)}/../../lib/kuality-kfs-cu"
require 'rspec/matchers'

World Foundry
World StringFactory
World DateFactory
World GlobalConfig

# Explicitly enable both rspec formats. If the tests start failing someday,
# the new RSpec version has probably completely removed the deprecated
# .should syntax and you need to revise.
require 'rspec/core'
require 'rspec/core/configuration'

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

# End explicit RSpec enablement

if ENV['HEADLESS']
  headless = Headless.new(:reuse           => false,
                          :destroy_at_exit => false)
  headless.start
end

kuality = KualityKFS.new @config[:browser]
$users = Users.instance

Before do

  @browser = kuality.browser
  $users.clear
  # Add the admin user to the Users...
  $users << UserObject.new(@browser)

end

After do

  # If there are any extant modal dialogs,
  # hopefully this will save the run, at least.
  if @browser.alert.exists?
    @browser.alert.close
    kuality.browser.close
    kuality = KualityKFS.new @config[:browser]
    $users = Users.instance
  end

end

After do |scenario|

  if scenario.failed?
    @browser.screenshot.save 'screenshot.png'
    embed 'screenshot.png', 'image/png'
  end

  $users.current_user.sign_out unless $users.current_user.nil?

  if ENV['DEBUG']
    # Tell Cucumber to quit after this scenario is done - if it failed.
    # This will kill a Scenario Outline on the first failed step for the first
    # failing Example.
    Cucumber.wants_to_quit = scenario.failed?
  end

end

at_exit { kuality.browser.close } unless ENV['DEBUG']
