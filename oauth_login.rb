require 'rubygems'
require 'oauth'
$KCODE = 'u'

CONSUMER_KEY = 'c8idEr7Y2bGmHA5M6XG1g'
CONSUMER_SECRET = 'A5y5Y4165epvdqxGpTZlDKAdkJLATDksobhAdH0Ke0'


class Twitter
  private :initialize

  def Twitter.login(access_token, access_token_secret)
    @consumer = OAuth::Consumer.new(
      CONSUMER_KEY,
      CONSUMER_SECRET,
      :site => 'http://api.twitter.com/'
    )

    @token = OAuth::AccessToken.new(
      @consumer,
      access_token,
      access_token_secret
    )

    return @token
  end
end
