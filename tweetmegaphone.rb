require 'yaml/store'
require 'open-uri'
require 'rubygems'
require 'json'
require 'oauth_login'

ACCESS_TOKEN = [['175956300-uWfB3MFDFuyWkKhFghtz5ZofP9PEzzIyIlPwr6hZ', 
                   'MgRwm79DRLvs6R81PtbeMdAQjNKyrkfOlG44VxxnsVQ'],
                ['175957485-WHFTBc695j5VM3HBPzEulzUEu0xNQlBMDeROuc7E',
                   'cF4ne4NH6WGpUssPVvFmRcVKlgOscriN36UdYrC8E4'],
                ['175957965-IqZIroiPcu1MrgTCqb34PbG0Qh0hu9yvjXsMYwop',
                   'DZP1ZjgEAo7sLdj4IXRTNlK88jYs67TJXeAhYC0swPU']]

twitter = ACCESS_TOKEN.map do |a|
  Twitter.login(a[0], a[1])
end

search_result = JSON.parse open("http://search.twitter.com/search.json?q=%23TweetMegaphone").read

db = YAML::Store.new('./data.yaml')
db.transaction do
  search_result['results'].each do |tweet|
    id = tweet['id'].to_s
    unless db[id]
      twitter.each do |t|
        p t.post("http://api.twitter.com/1/favorites/create/#{id}.json")
        p t.post("http://api.twitter.com/1/statuses/retweet/#{id}.json")
      end
      db[id] = true
    end
  end
end

