require 'open-uri'
class GamesController < ApplicationController
  VOWELS = %w(A E I O U)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = params[:word].upcase
    @include = include?(@word, @letters)
    @english_word = english_word?(@word)
    @scores = scores(@word, @letters)
  end

  private

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read
    repo = JSON.parse(response)
    repo['found']
  end

  def include?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def scores(word, letters)
    letters.join.count(word)
  end
end
