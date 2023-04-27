class Rss
  attr_accessor :url

  def initialize(url)
    @url = url
  end

  def xml
    begin
      @xml ||= URI.open(url).read
    rescue
      @xml = nil
    end
  end

  def feed_xml
    @feed_xml ||= Nokogiri(xml)
  end

  def has_image?
    !image_url.blank?
  end

  def image_url
    @image_url ||= feed_xml.xpath('/rss/channel/image/url').text
  end

  def patreon?
    @url.include?('https://www.patreon.com')
  end

  def episodes
    episodes = feed_xml.xpath("/rss/channel/item")
  end

  def updated_at
    return "Not found" unless episodes.count > 0
    Episode.new(episodes.first).pub_date.strftime("%A %B %d, %Y")
  end

  def title
    @title ||= feed_xml.xpath("/rss/channel/title").text
  end

  def valid?
    !xml.nil? && !title.blank? && has_image? && episodes.count > 0
  end
end