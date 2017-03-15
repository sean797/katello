require 'uri'
module Katello
  module KatelloUrlsHelper
    def host(url)
      URI(url).host unless url.nil?
    end

    def subscription_manager_configuration_url(host = nil, rpm = true)
      prefix = if host && host.content_source_url
                 "http://#{@host.content_source_url.hostname}"
               else
                 Setting[:foreman_url].sub(/\Ahttps/, 'http')
               end
      config = rpm ? SETTINGS[:katello][:consumer_cert_rpm] : SETTINGS[:katello][:consumer_cert_sh]

      "#{prefix}/pub/#{config}"
    end
  end
end
