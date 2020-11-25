require 'open-uri'
require 'json'


class GamesController < ApplicationController
  def new
    @letters = Array.new(9) { ('A'..'Z').to_a.sample };
  end

  def score
    @word = params[:word].downcase
    @grid = params[:grid].split

    if !word_in_grid?(@word, @grid)
      @result = "Sorry but #{@word.upcase} can't be built from #{@grid.join(' ')}"
    elsif !word_exists?(@word)
      @result = "Sorry but #{@word.upcase} does´t seem to be a valid English word..."
    else
      @result = "Congratulations! #{@word.upcase} is a valid English word!"
    end
  end

  # ----------------------------------------------------------------------------
  private

  def word_exists?(word)
    # 1) Validate that attempt is an actual English word
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
  
  def word_in_grid?(word, grid)
    # 2) Validate that every letter in attempt appears in the grid (use each letter once)
    word = word.upcase
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end
  
end