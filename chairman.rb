require 'net/http'
require 'uri'
require 'json'
require 'time'
require 'cgi'

PANDA_LOCATION="UN Plaza"
PANDA_WINDOW=19
PANDA_USERNAME="chairmantruck"

def http_get(domain,path,params)
  return Net::HTTP.get(domain, "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))) if not params.nil?
  return Net::HTTP.get(domain, path)
end

def twoxy_get(url)
  JSON.parse http_get('twoxy.spongecell.com', '/fetch/url', {source: url})
end

def is_chairman_nearby?
  chairman_json = twoxy_get('http://twitter.com/statuses/user_timeline/' + PANDA_USERNAME + '.json')

  chairman_json.each do |tweet|
    if tweet["text"].match(Regexp.new(PANDA_LOCATION, Regexp::IGNORECASE)) != nil
      tweet_time = Time.parse tweet["created_at"]
      now = Time.now
      
      if tweet_time + (PANDA_WINDOW * 60 * 60) > now
        return true
      end
    end
  end
  return false
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
  if is_chairman_nearby?
    turn_kitten_on()
  else
    turn_kitten_off()
  end
  sleep(10)
end
