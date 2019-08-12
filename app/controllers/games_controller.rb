require 'open-uri'
require 'json'

class GamesController < ApplicationController
  LETTERS = (0..9).to_a
  LETTERS.map! { ("A".."Z").to_a.sample }

  def new
    @letters = LETTERS
  end

  def analyze(word, collected_letters)
    check = true
    collected_letters_split = collected_letters.split
    word.upcase.split("").each do |letter|
      if collected_letters_split.include?(letter)
        collected_letters_split.delete_at(collected_letters_split.index(letter))
      else
        check = false
      end
    end
    return check
  end

  def check_word(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    dic_serialized = open(url).read
    dic_search_result = JSON.parse(dic_serialized)["found"]
    return dic_search_result
  end

  def score

    @word = params[:word]
    @collected_letters = params[:collected_letters]
    result = ""
    if analyze(@word, @collected_letters) == false
      result = "The word is not in the grid!"
    elsif check_word(@word) == true
      result = "Well done. The word is correct!"
    elsif check_word(@word) == false
      result = "The word is not an english word!"
    end
    @result = result
  end
end
