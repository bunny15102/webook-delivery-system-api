require 'net/http'
require 'uri'
require 'openssl'
require 'base64'

class ThirdPartyNotifier
  def initialize(order,action)
    @order = order
    @action = action 
    @secret_key = ENV['secret_key']
    @url = ENV['third_party_webhook']
  end

  def notify
    payload = create_payload
    hmac_signature = compute_hmac_signature(payload)
    uri = URI(@url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri)
    request.body = payload
    request["Content-Type"] = "application/json"
    request["X-Signature"] = hmac_signature
    response = https.request(request)

    response.code == 200
  rescue StandardError => e
    false
  end

  private
  def create_payload
    payload = {id: @order.id, product: @order.product_name, action: @action}.to_json
  end

  def compute_hmac_signature(payload)
    digest = OpenSSL::Digest.new('sha256')
    hmac = OpenSSL::HMAC.digest(digest, @secret_key, payload)
    Base64.strict_encode64(hmac)
  end
end