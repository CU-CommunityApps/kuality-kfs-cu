module Watir
  module Container
    def frm
      case
        when frame(id: 'iframeportlet').exist?
          frame(id: 'iframeportlet')
        when frame(id: /easyXDM_default\d+_provider/).frame(id: 'iframeportlet').exist?
          frame(id: /easyXDM_default\d+_provider/).frame(id: 'iframeportlet')
        when frame(id: /easyXDM_default\d+_provider/).exist?
          frame(id: /easyXDM_default\d+_provider/)
        else
          self
      end
    end
  end

  # Because of the unique way we
  # set up radio buttons in Coeus,
  # we can use this method in our
  # radio button definitions.
  class Radio
    def fit answer
      set unless answer==nil
    end
  end
end