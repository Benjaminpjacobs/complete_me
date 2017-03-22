require_relative "./lib/trie"
require 'pry'

class CompleteMe
  attr_accessor :trie
  def initialize
    @trie = Trie.new  
  end

  def input_word(string)
    chars = string.chars
  end
end

binding.pry
cm = CompleteMe.new