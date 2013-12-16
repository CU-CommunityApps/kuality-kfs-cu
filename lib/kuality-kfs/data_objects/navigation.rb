module Navigation

  include Utilities

  def open_document doc_header
    doc_search unless on_document?(doc_header)
  end

  def on_document?(doc_header)
    begin
      on(DocumentHeader).document_id==@document_id && @browser.frm.div(id: 'headerarea').h1.text==doc_header
    rescue Watir::Exception::UnknownObjectException, Selenium::WebDriver::Error::StaleElementReferenceError
      false
    end
  end

  def doc_search
    visit DocumentSearch do |search|
      search.close_parents
      search.document_id.set @document_id
      search.search
      search.open_doc @document_id
    end
  end

  def on_page? element
    begin
      element.exist?
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      false
    end
  end

  # Use this if the confirmation dialog may appear.
  # For example: due to missing rates...
  def confirmation(answer='yes')
    begin
      on(Confirmation) do |conf|
        conf.send(answer) if conf.yes_button.present?
      end
    rescue
      # do nothing because the dialog isn't there
    end
  end

  private

  # This overrides the method in the TestFactory.
  # We need this here because of the special way that
  # KC defines radio buttons. See below...
  def parse_fields(opts, name, page, *fields)
    watir_methods=[ lambda{|n, p, f, v| p.send(*[f, n].compact).fit(v) }, # Text & Checkbox
                    lambda{|n, p, f, v| p.send(*[f, n].compact).pick!(v) }, # Select
                    lambda{|n, p, f, v| p.send(*[f, n].compact, v) } # Radio
    ]
    fields.each do |field|
      # This rescue is here because the radio button
      # "element" definitions are *actions* that
      # require a parameter, so just sending the method to the page
      # is not going to work.
      begin
        x = page.send(*[field, name].compact).class.to_s=='Watir::Select' ? 1 : 0
      rescue NoMethodError
        x = 2
      end
      val = opts.nil? ? get(field) : opts[field]
      watir_methods[x].call(name, page, field, val)
    end
  end

end