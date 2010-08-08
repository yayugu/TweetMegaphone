require 'rubygems'
require 'oauth'
$KCODE = 'u'

CONSUMER_KEY = 'c8idEr7Y2bGmHA5M6XG1g'
CONSUMER_SECRET = 'A5y5Y4165epvdqxGpTZlDKAdkJLATDksobhAdH0Ke0'

consumer = OAuth::Consumer.new(
  CONSUMER_KEY,
  CONSUMER_SECRET,
  :site => 'http://twitter.com'
  )

request_token = consumer.get_request_token
puts request_token.authorize_url

verifier = gets.strip
access_token = request_token.get_access_token(:oauth_verifier => verifier)

puts "ACCESS_TOKEN = #{access_token.token}"
puts "ACCESS_TOKEN_SECRET = #{access_token.secret}"
