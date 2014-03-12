require 'rubygems'
require 'yaml'
require 'cucumber'
require 'headless'

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

  if ENV['DRAGONSTYLE']
    # This will (hopefully) provide more aggressive modal-dialog punching.
    # It overrides the related JavaScript method to always click true. Since
    # KFS doesn't rely on modal dialogs, this *should* be safe...
    @browser.execute_script('window.confirm = function() {return true}')
  end
end

After do |scenario|

  if scenario.failed?
    @browser.screenshot.save 'screenshot.png'
    embed 'screenshot.png', 'image/png'
  end

  $users.current_user.sign_out unless $users.current_user.nil?

end

unless ENV['DEBUG']
  at_exit { kuality.browser.close }
end