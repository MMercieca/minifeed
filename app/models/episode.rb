class Episode
  def initialize(xpath)
    @xpath = xpath
  end

  def url
    @xpath.xpath('enclosure').attribute('url').value
  end

  def title
    @xpath.xpath('title').children.first.text
  end

  def description
    @xpath.xpath('description').children.first.text
  end
end