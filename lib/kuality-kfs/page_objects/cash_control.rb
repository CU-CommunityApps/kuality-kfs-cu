=begin

class InternalBillingDocument < TransactionalDocument

  #http://testdrive.kfs.kuali.org/kfs-ptd/portal.do?channelTitle=Cash%20Control&channelUrl=arCashControlDocument.do?methodToCall=docHandler&command=initiate&docTypeName=CTRL

  element(:processing_org) { |b| b.frm.text_field(name: 'document.documentHeader.explanation') }
  element(:bank_code) { |b| b.frm.text_field(name: 'document.bankCode') }
  element(:cust_pmnt_med_cd) { |b| b.frm.text_field(name: 'document.customerPaymentMediumCode') }
  value(:processing_org_ro) { |b| b.frm.table(summary: 'General Info')[0][1].text }

end

=end
