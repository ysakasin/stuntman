require 'twitter_oauth'
require 'twitter'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require_relative 'lib/stuntman'
require_relative 'config'

task :import_csv do
  Stuntman::Markov.import_csv(ENV['NAME'], ENV['CSV'])
end

task :import_api do
  Stuntman::Markov.import_api
end

task :oauth do
  client = TwitterOAuth::Client.new(
    :consumer_key => CONFIG[:consumer_key],
    :consumer_secret => CONFIG[:consumer_secret]
  )
  request_token = client.request_token

  puts request_token.authorize_url
  print 'PIN:'
  pin = STDIN.gets.chomp

  access_token = client.authorize(
    request_token.token,
    request_token.secret,
    :oauth_verifier => pin
  )

  unless client.authorized?
    puts 'fail authorize'
    exit
  end

  twitter_client =  Twitter::REST::Client.new do |config|
    config.consumer_key = CONFIG[:consumer_key]
    config.consumer_secret = CONFIG[:consumer_secret]
    config.access_token = access_token.token
    config.access_token_secret = access_token.secret
  end

  user = twitter_client.user
  puts "[success] #{user.screen_name}"
  Stuntman::User.create(
    :screen_name => user.screen_name,
    :access_token => access_token.token,
    :access_token_secret => access_token.secret
  )
end

task :gen do
  tweet = Stuntman::Tweet.new
  puts tweet.text
end

task :post do
  user = Stuntman::User.find_by_screen_name(ENV['NAME'])
  tweet = Stuntman::Tweet.new

  puts tweet.text
  user.post(tweet.text)
end
