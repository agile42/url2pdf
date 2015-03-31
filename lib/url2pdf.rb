require "url2pdf/version"
require 'httparty'
require 'rack'

module Url2pdf

  class Client

    DEFAULT_PDF_SERVICE_URL = 'http://icanhazpdf.lsfapp.com/generate_pdf'
    DEFAULT_HTTP_TIMEOUT = 10000

    def initialize(api_key, options = {})
      @api_key = api_key
      @service_options = options
    end

    def pdf_from_url(full_url, options = {})
      raise "API Key Is Required" if @api_key.nil?
      uri = URI(full_url)
      params = URI.decode_www_form(uri.query || "") << ['icanhazpdf', @api_key]
      uri.query = URI.encode_www_form(params)
      encoded_url = "#{@service_options[:server_url] || DEFAULT_PDF_SERVICE_URL}?url=#{Rack::Utils.escape(uri)}"
      encoded_url += "&engine=#{options[:engine]}" if options.has_key?(:engine)
      encoded_url += "&margin=#{options[:margin]}" if options.has_key?(:margin)
      encoded_url += "&orientation=#{options[:orientation]}" if options.has_key?(:orientation)

      HTTParty.get(encoded_url, timeout: @service_options[:timeout] || DEFAULT_HTTP_TIMEOUT)
    end
  end

end
