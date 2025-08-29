# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RssService, type: :service do
  let(:url) { 'https://example.com/rss' }
  let(:uri) { URI.parse(url) }
  let(:mock_http) { instance_double(Net::HTTP) }
  let(:mock_request) { instance_double(Net::HTTP::Get) }
  let(:response_body) { 'HTTP Body' }

  before do
    allow(Net::HTTP).to receive(:new).with(uri.host, uri.port).and_return(mock_http)
    allow(mock_http).to receive(:use_ssl=)
    allow(Net::HTTP::Get).to receive(:new).with(uri.request_uri).and_return(mock_request)
    allow(mock_http).to receive(:request).with(mock_request).and_return(mock_response)
  end

  context 'when successful' do
    let(:mock_response) { instance_double(Net::HTTPResponse, body: response_body, code: "200") }
    
    before do
      allow(mock_response).to receive(:code).and_return("200")
    end  

    it 'returns the body on success' do
      rss = RssService.get('https://example.com/rss')

      expect(rss).to eq('HTTP Body')
    end
  end

  context 'when the feed has moved' do
    let(:headers) { {} }
    let(:mock_response) { instance_double(Net::HTTPResponse, body: response_body, code: '301', header: headers) }

    it 'raises an RssFeedMoved exception' do
      expect { RssService.get('https://example.com/rss') }.to raise_error(RssFeedMoved)
    end

    it 'includes the new location in the error' do
      headers['location'] = 'https://example.com/rss/2'
      begin
        RssService.get('https://example.com/rss')
      rescue => e
        expect(e.message).to eq('https://example.com/rss/2')
      end
    end
  end

  context 'when something else goes wrong' do
    let(:mock_response) { instance_double(Net::HTTPResponse, body: response_body, code: '401', message: 'something else') }
 
    it 'raises an RssResponseError exception' do
      expect { RssService.get('https://example.com/rss') }.to raise_error(RssResponseError)
    end 
  end
end