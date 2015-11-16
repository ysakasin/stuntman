require 'natto'
require 'active_record'
require_relative 'user'
require_relative '../../config'

ActiveRecord::Base.default_timezone = :local
ActiveRecord::Base.establish_connection(
  'adapter' => 'sqlite3',
  'database' => ENV['DB'] || './stuntman.db'
)

module Stuntman
  class Markov < ActiveRecord::Base
    def self.import_tweet(tweet)
      if tweet.retweet? ||
         tweet.urls? ||
         tweet.source.match(/twittbot.net/) ||
         tweet.text.match(/(@[0-9A-Za-z_]+)|[BOTテスト]/) ||
         tweet.text.blank?
        return
      end

      text = Markov.normalize(tweet.text)
      wakati = Markov.tagger.parse(text).split
      Markov.import_wakati(wakati)
    end

    def self.import_wakati(wakati)
      head = nil
      Markov.transaction do
        while wakati[0] != nil
          Markov.create(:head => head, :middle => wakati[0], :tail => wakati[1])
          head = wakati.shift
        end
      end
    end

    def self.import_csv(screen_name, path)
      require 'csv'

      header_converter = lambda { |h| h == 'tweet_id' ? :id : h.to_sym }
      since_id = nil
      CSV.foreach(path, :headers => true, :header_converters => header_converter) do |row|
        tweet = Twitter::Tweet.new(row)
        since_id ||= tweet.id
        Markov.import_tweet(tweet)
      end
      User.find_by_screen_name(screen_name).update(:since_id => since_id)
    end

    def self.import_api
      User.all.each do |user|
        user.user_timeline.each do |tweet|
          Markov.import_tweet(tweet)
        end
      end
    end

    def self.normalize(text)
      text.gsub(/#\S+/) {|word| word.gsub('#', '')}
          .gsub(/\s*＞＞+.*$/, '')
          .gsub('　　', '　')
          .strip
    end

    def self.tagger
      @@tagger ||= Natto::MeCab.new("-O wakati -d #{CONFIG[:mecab_dic_path]}")
    end

    def to_s
      "[#{head}, #{middle}, #{tail}]"
    end
  end
end
