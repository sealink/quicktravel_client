require 'openssl'
require 'base64'

DIGEST = OpenSSL::Digest.new('sha256')

module QuickTravel
  module Encrypt
    def self.access_key(text)
      digest = OpenSSL::HMAC.hexdigest(DIGEST, QuickTravel.config.access_key, text)
      Base64.encode64s(digest).chomp
    end
  end
end
