When /^I? ?create a Group$/ do
  @group = create GroupObject
end

When /^I? ?add the User to the Group$/ do
  # Note that this step is assuming you're adding the user that was
  # last created in the scenario...
  @group.add_assignee member_identifier: $users[-1].principal_id
end

Given /^I? ?add the Group to the User$/ do
  $users[-1].add_group id: @group.id
end
