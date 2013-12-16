class ActionList < BasePage

  page_url "#{$base_url}portal.do?channelTitle=Action List&channelUrl=#{$base_url[/^.+com/]}kew/ActionList.do"

  search_results_table

  # TD Count for Columns in results table
  SHOW_BUTTON = 0
  ITEM_ID = 1
  TYPE = 2
  TITLE = 3
  ROUTE_STATUS = 4
  ACTION_REQUESTED = 5
  DELEGATOR = 6
  DATE_CREATED = 7
  GROUP_REQUEST = 8
  ACTIONS = 9
  LOG = 10

  action(:action_requested) { |item_id, b| b.item_row(item_id).tds[ACTION_REQUESTED].text }
  action(:route_status) { |item_id, b| b.item_row(item_id).tds[ROUTE_STATUS].text }
  action(:filter) { |b| b.frm.button(name: 'methodToCall.viewFilter').click; b.loading }
  action(:take_actions) { |b| b.frm.link(id: 'takeMassActions').click; b.loading }
  action(:action) { |item_id, b| b.item_row(item_id).select(name: /actionTakenCd/) }
  action(:outbox) { |b| b.frm.link(href: /viewOutbox/).click }
  action(:last) { |b| b.frm.link(text: 'Last').click }
  action(:refresh) { |b| b.frm.button(name: 'methodToCall.refresh').click; b.loading }

  #Default action select list for FYIs
  action(:default_action) { |b| b.frm.select(name: 'defaultActionToTake') }
  action(:apply_default_action) { |b| b.frm.link(align: 'absmiddle').click }
end