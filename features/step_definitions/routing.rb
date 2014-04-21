And /^the next pending action for the (.*) document is an? (.*) from a (.*)$/ do |document, action, user_type|
  on page_object_for(document) do |page|
    page.pnd_act_req_table_action.visible?.should
    page.pnd_act_req_table_action.should match(/#{action}/)
    page.pnd_act_req_table_annotation.should match(/#{user_type}/)
  end
end
