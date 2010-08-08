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
                   'DZP1ZjgEAo7sLdj4IXRTNlK88jYs67TJXeAhYC0swPU'],
                ['175970888-1AJ9U6cqpYMDSK3l5sGNEhy0gziyPDxsVHTnlZVc',
                   'XMGgDooOynK9oFloZhwVwloIStLvyI42oy9XJkPrGnU'],
                ['175971343-Q1iDaj6L03VSluKqCMHbGVQeTlTdehmA2H7iSsMH',
                   '6jVjGD7RAoluaugl81cqnFZvUkSByOpNvDRQchuOaUA'],
                ['175971828-KfTfoiotil5wX5KzkhKL0sUvmwzKTgIb2vZQsZOA',
                   'zJzWlr4bqgP7dBFs8VGfHFCyCOGEezWwJ0kkcfYbJxY'],
                ['175972528-hIGmt67ORyZUcBJM2xjKtrAnE31cfrs4xsYzto6O',
                   'ioBuBcedswZCylCMrZuQ1HfXU5bJ3l6TZF5Yc8KJMo'],
                ['175972898-VcEsm7VyDZ4KwjAY2EHpaQsDnaygv81WAbVORxxM',
                   'UN2jiUJ2D0q83kpEQmqdIo4zztpedmO5jW8EGj0MNU'],
                ['175973344-odFw3XKkI1G6Bg1PXpbZzHxefB3MNgov4XWKUxqP',
                   '2jrQo9GZUm29bxqwFxiRV6kbiDXJPzG5EqKtbCAL20'],
                ['175974221-YsRj59xTguhcFx6fjQWpnyskxVhfWcQx9taeNEDE',
                   'KnZ9hTlOrNcEvQtzZvxzFiiXkADavQc3oU087oULtk']]
twitter = ACCESS_TOKEN.map do |a|
  Twitter.login(a[0], a[1])
end

search_result = JSON.parse(open("http://search.twitter.com/search.json?q=%23TweetMegaphone").read)
search_result = search_result['results'].map{|tweet| tweet['id'].to_s}
yayugu_tweets = JSON.parse(open("http://api.twitter.com/1/statuses/user_timeline.json?screen_name=yayugu").read)
yayugu_tweets = yayugu_tweets.map{|tweet| tweet['id'].to_s}
search_result += yayugu_tweets

db = YAML::Store.new('./data.yaml')
db.transaction do
  search_result.each do |id|
    unless db[id]
      twitter.each do |t|
        p t.post("http://api.twitter.com/1/favorites/create/#{id}.json")
        p t.post("http://api.twitter.com/1/statuses/retweet/#{id}.json")
      end
      db[id] = true
    end
  end
end

