require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = []
    @letters << alphabet.sample while @letters.length < 10
    @letters
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split(' ')
    if !word_in_grid?(@word, @letters)
      # The word can’t be built out of the original grid
      @result = 'grid'
      # "Sorry but #{@word} can't be built out of #{@letters.join(', ')}"
    elsif !word_in_dictionary?(@word)
      # The word is valid according to the grid, but is not a valid English word
      @result = 'dictionary'
      # "Sorry but #{@word} does not seem to be a valid English word."
    elsif word_in_grid?(@word, @letters) && word_in_dictionary?(@word)
      # The word is valid according to the grid and is an English word
      @result = 'valid'
      # "Congratulations! #{@word} is a valid English word!"
    end
  end

  def word_in_grid?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def word_in_dictionary?(word)
    # create url variable
    url = "https://wagon-dictionary.herokuapp.com/#{word}"

    # create variable for dictionary json
    word_hash = JSON.parse(URI.open(url).read)

    # return "found" key in Hash
    word_hash['found']
  end
end
