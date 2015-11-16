require 'active_record'
require_relative '../../config'

module Stuntman
  class User < ActiveRecord::Base
    def client
      @client ||= Twitter::REST::Client.new do |config|
        config.consumer_key = CONFIG[:consumer_key]
        config.consumer_secret = CONFIG[:consumer_secret]
        config.access_token = access_token
        config.access_token_secret = access_token_secret
      end
    end

    def user_timeline
      tweets = []
      res = client.user_timeline(screen_name, :since_id => since_id, :count => 200)
      while res.present?
        tweets += res
        max_id = res.last.id - 1
        res = client.user_timeline(screen_name, :since_id => since_id, :max_id => max_id, :count => 200)
      end

      update(:since_id => tweets.first.id) if tweets.present?
      return tweets
    end

    def post(text)
      client.update(text)
    end
  end
end
