class TransactionalDocument < BasePage

  element(:explanation) { |b| b.frm.text_field(name: 'document.documentHeader.explanation') }
  element(:org_doc_num) { |b| b.frm.text_field(name: 'document.documentHeader.organizationDocumentNumber') }
  element(:add_source_button) { |b| b.frm.button(name: 'methodToCall.insertSourceLine.anchoraccountingSourceAnchor') }
  action(:add_source) { |b| b.add_source_button.click }
  element(:add_target_button) { |b| b.frm.button(name: 'methodToCall.insertTargetLine.anchoraccountingTargetAnchor') }
  action(:add_target) { |b| b.add_target_button.click }

end