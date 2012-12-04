require 'net/http'
require 'uri'
require 'json'
require 'time'
require 'cgi'

def http_get(domain,path,params)
  return Net::HTTP.get(domain, "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))) if not params.nil?
  return Net::HTTP.get(domain, path)
end

def twoxy_get(url)
  JSON.parse http_get('twoxy.spongecell.com', '/fetch/url', {source: url})
end

def is_chairman_nearby?
  chairman_json = twoxy_get('http://twitter.com/statuses/user_timeline/chairmantruck.json')

  chairman_json.each do |tweet|
    # puts JSON.pretty_generate tweet
    # puts tweet["created_at"] + tweet["text"]
    if tweet["text"].match(Regexp.new('Hayward', Regexp::IGNORECASE)) != nil
      tweet_time = Time.parse tweet["created_at"]
      now = Time.now
      
      if tweet_time + (19 * 60 * 60) > now
        return true
      end
    end
  end
  return false
end

def turn_kitten_off
  puts "Kitten go to sleep!"
end

def turn_kitten_on
  puts "Kitten is awake!"
end

while true
  if is_chairman_nearby?
    turn_kitten_on()
  else
    turn_kitten_off()
  end
  sleep(10)
end
