require 'pry'
class Node
  attr_accessor :children, :flag

  def initialize
    @children = {}
    @flag = false
  end
  def insert_letter(letter)
    self.children[letter.to_sym] = Node.new
  end
  def next_node(letter)
    self.children[letter.to_sym]
  end
  def next_node_symbol(symbol)
    self.children[symbol]
  end
  def count
    if self.flag
      1
    else
      0
    end
  end
end
