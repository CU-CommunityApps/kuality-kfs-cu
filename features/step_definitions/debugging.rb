# These steps can be useful for debugging, but *should not*
# be used in production/master runs.

And /^I sleep for (\d+)$/ do |time|
  sleep time.to_i
end

And /^I stop here because (.*)$/ do |msg|
  pending msg
end

And /^I stop here$/ do
  pending
end
