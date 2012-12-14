require 'net/http'
require 'uri'
require 'json'
require 'time'
require 'cgi'
require 'yaml'
require 'debugger'
require 'twitter'

config = YAML::load( File.open( 'config.yml' ) )
PANDA_LOCATION="UN Plaza"
PANDA_WINDOW=19
PANDA_USERNAME="chairmantruck"

Twitter.configure do |t|
  t.consumer_key = config["consumer_key"]
  t.consumer_secret = config["consumer_secret"]
  t.oauth_token = config["oauth_token"]
  t.oauth_token_secret = config["oauth_token_secret"]
end

def is_chairman_nearby?
  chairman_tweets = Twitter.user_timeline PANDA_USERNAME

  chairman_tweets.each do |tweet|
    if tweet.text.match(Regexp.new(PANDA_LOCATION, Regexp::IGNORECASE)) != nil
      tweet_time = tweet.created_at
      now = Time.now
      
      if tweet_time + (PANDA_WINDOW * 60 * 60) > now
        yield tweet.text + tweet.created_at.to_s
      end
    end
  end
  yield false
end

def turn_kitten_off
  `gpio -g write 4 0 && gpio -g write 17 0`
  puts "Kitty go to sleep!"
end

def turn_kitten_on
  `gpio -g write 4 1 && gpio -g write 17 1`
  puts "Kitty want a sandwich!"
end

while true
  is_chairman_nearby? do |info|
    if info
      turn_kitten_on()
      puts info
    else
      turn_kitten_off()
      puts "Kitty go to sleep"
    end
  end
  sleep(60)
end
