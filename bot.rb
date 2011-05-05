require "rubygems"
require "bundler/setup"

require "tweetstream"
require "twitter"

hit_count = 0

NEED_HELP_PHRASES = [
  'difficult',
  'dispute',
  'fail',
  'fuck',
  'hate',
  'horrible',
  'never using',
  'never use',
  'settings',
  'sucks',
  'sux',
  'wish',
  'worst'
]

Twitter.configure do |config|
  config.consumer_key = ENV['TWITTER_BOT_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_BOT_CONSUMER_SECRET']
  config.oauth_token = ENV['TWITTER_BOT_OAUTH_KEY']
  config.oauth_token_secret = ENV['TWITTER_BOT_OAUTH_SECRET']
end

VICTIM = ENV['VICTIM']

start_time = Time.now
puts "Beginning joke at #{start_time}"
TweetStream::Client.new(ENV['TWITTER_BOT_USERNAME'], ENV['TWITTER_BOT_PASSWORD']).track('paypal') do |status, client|
  found_a_hit = false
  
  search_text = status.text.downcase
  NEED_HELP_PHRASES.map do |phrase|
    found_a_hit = true if search_text.include?(phrase)
  end
  
  if found_a_hit
    hit_count += 1
    puts "HIT: #{status.user.screen_name} just wrote: \"#{status.text}\""
    str = "@#{status.user.screen_name} Sorry you're having trouble. For prompt service, please contact @#{VICTIM}, our friendly support rep."
    Twitter.update(str)
    puts "TWEETED: #{str}"
  else
    puts "miss: #{status.user.screen_name} just wrote: \"#{status.text}\""
  end
  
  client.stop if hit_count >= 5
end
end_time = Time.now
puts "#{hit_count} jokes played on #{VICTIM} by #{end_time}"
puts "Elapsed time: #{start_time - end_time} seconds."