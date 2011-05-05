require "rubygems"
require "bundler/setup"

require "tweetstream"

hit_count = 0

NEED_HELP_PHRASES = [
  'call',
  'dammit',
  'damnit',
  'difficult',
  'dispute',
  'fail',
  'fuck',
  'hard',
  'hate',
  'help',
  'never using',
  'never use',
  'settings',
  'sucks',
  'sux',
  'worst'
]

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
  else
    puts "miss: #{status.user.screen_name} just wrote: \"#{status.text}\""
  end
  
  client.stop if hit_count >= 3
end
end_time = Time.now
puts "#{hit_count} jokes played on macasek by #{end_time}"
puts "Elapsed time: #{start_time - end_time} seconds."