include Utilities

And /^the next pending action for the (.*) document is an? (.*) from a (.*)$/ do |document, action, user_type|
  on page_class_for(document) do |page|

    page.pnd_act_req_table_action.visible?.should
    if page.pnd_act_req_table_requested_of.text.match(/Multiple/m)
      page.show_future_action_requests

      page.pnd_act_req_table_multi_action.table.visible?.should
      page.pnd_act_req_table_multi_action.text.should match(/#{action}/)
      page.pnd_act_req_table_multi_annotation.text.should match(/#{user_type}/)
    else
      page.pnd_act_req_table_action.text.should match(/#{action}/)
      page.pnd_act_req_table_annotation.text.should match(/#{user_type}/)
    end
  end
  pending
end
