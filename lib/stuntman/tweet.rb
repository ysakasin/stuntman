require 'twitter'
require_relative 'markov'

module Stuntman
  class Tweet
    def text
      @text ||= generate
    end

    def generate
      @text = ''
      tail = nil
      middle = nil
      markov = Markov.where(:head => tail).sample

      if markov.tail.nil?
        @text = markov.middle
        return @text
      end

      num_morpheme = 1
      @alphabet = false
      while markov != nil && markov.tail != nil
        tail = markov.tail

        concat(markov.middle)
        concat(markov.tail)

        if num_morpheme > 8
          markov = Markov.where(:head => tail, :tail => nil).sample
        elsif num_morpheme > 4
          markov = Markov.where(:head => tail, :tail => nil).sample
          markov ||= Markov.where(:head => tail).sample
        else
          markov = Markov.where(:head => tail).sample
        end
        num_morpheme += 1
      end

      concat(markov.middle) unless markov.nil?
      return @text
    end

    def concat(text)
      if text_last.match(/[:almun:]/) && text[0].match(/[:almun:]/)
        @text = "#{@text} #{text}"
      else
        @text = "#{@text}#{text}"
      end
    end

    def text_last
      @text[-1] || ''
    end
  end
end
