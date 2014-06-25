include Utilities

And /^the next pending action for the (.*) document is an? (.*) from a (.*)$/ do |document, action, user_type|
  on page_class_for(document) do |page|
    page.show_route_log_button.wait_until_present
    page.show_route_log unless page.route_log_shown?

    page.pnd_act_req_table_action.visible?.should

    if page.pnd_act_req_table_requested_of.text.match(/Multiple/m)
      page.show_pending_action_requests_in_action_list if page.pending_action_requests_in_action_list_hidden?

      page.pnd_act_req_table_multi.visible?.should
      page.pnd_act_req_table_multi_action.text.should match(/#{action}/)
      page.pnd_act_req_table_multi_annotation.text.should match(/#{user_type}/)
    else
      page.pnd_act_req_table_action.text.should match(/#{action}/)
      page.pnd_act_req_table_annotation.text.should match(/#{user_type}/)
    end
  end
end

When /^I route the (.*) document to final$/ do |document|
  step "I view the #{document} document"
  until 'FINALPROCESSSED'.include?on(page_class_for(document)).document_status
    step "I switch to the user with the next Pending Action in the Route Log for the #{document} document"
    step "I view the #{document} document"
    step "I approve the #{document} document if it is not already FINAL"
    step "I view the #{document} document"
  end

end

Then /^I switch to the user with the next Pending Action in the Route Log for the (.*) document$/ do |document|
  new_user = ''
  on page_class_for(document) do |page|
    page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up... #debug
    page.expand_all
    page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up... #debug
    page.show_route_log unless page.route_log_shown?

    page.pnd_act_req_table_action.visible?.should

    if page.pnd_act_req_table_requested_of.text.match(/Multiple/m)
      page.show_pending_action_requests_in_action_list if page.pending_action_requests_in_action_list_hidden?

      page.pnd_act_req_table_multi_requested_of.links.first.click
    else
      #page.pnd_act_req_table_requested_of.links.first.click
      page.first_pending_approve
    end

    page.use_new_tab

    # TODO: Actually build a functioning PersonPage to grab this. It seems our current PersonPage ain't right.
    puts 'Check for frame or no frame'
    sleep 10 #debug

    if page.frm.div(id: 'tab-Overview-div').exists?
      # WITH FRAME
      puts 'frame for user'
      page.frm.div(id: 'tab-Overview-div').tables[0][1].tds.first.should exist
      page.frm.div(id: 'tab-Overview-div').tables[0][1].tds.first.text.empty?.should_not

      if page.frm.div(id: 'tab-Overview-div').tables[0][1].text.include?('Principal Name:')
        new_user = page.frm.div(id: 'tab-Overview-div').tables[0][1].tds.first.text
      else
        # TODO : this is for group.  any other alternative ?
        mbr_tr = page.frm.select(id: 'document.members[0].memberTypeCode').parent.parent.parent
        new_user = mbr_tr[4].text
      end

    elsif page.div(id: 'tab-Overview-div').exists?
      #NO FRAME
      puts 'no frame for user'
      page.div(id: 'tab-Overview-div').tables[0][1].tds.first.should exist
      page.div(id: 'tab-Overview-div').tables[0][1].tds.first.text.empty?.should_not

      if page.div(id: 'tab-Overview-div').tables[0][1].text.include?('Principal Name:')
        new_user = page.div(id: 'tab-Overview-div').tables[0][1].tds.first.text
      else
        # TODO : this is for group.  any other alternative ?
        mbr_tr = page.select(id: 'document.members[0].memberTypeCode').parent.parent.parent
        new_user = mbr_tr[4].text
      end
    end


  puts "New user to login as is: #{new_user}" #debug

  page.close_children
  end

  step "I am logged in as \"#{new_user}\""
end

And /^the initiator is not an approver in the Future Actions table$/ do
  on KFSBasePage do |page|
    page.expand_all
    page.show_future_action_requests if page.show_future_action_requests_button.exists?
    page.future_actions_table.rows(text: /APPROVE/m).any? { |r| r.text.include? 'Initiator' }.should_not
  end
end
