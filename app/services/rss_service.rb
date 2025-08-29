# frozen_string_literal: true

class RssFeedMoved < StandardError; end;
class RssNetworkError < StandardError; end;
class RssResponseError < StandardError; end;

class RssService
  def self.get(url)
    uri = URI.parse(url)
    
    # Check if the URL is valid
    unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      raise ArgumentError, "Invalid URL format"
    end

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')

    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)
    return response.body if response.code == "200"

    raise RssFeedMoved, response.header['location'] if response.code == "301"
    raise RssResponseError, "Request failed with status: #{response&.code} #{response&.message}"
  end
end