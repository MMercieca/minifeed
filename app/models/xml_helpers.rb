# frozen_string_literal: true

class XmlHelpers
  def self.scrub_emoji(xml)
    xml.gsub(/[^\x00-\x7F]/, '')
  end
end
